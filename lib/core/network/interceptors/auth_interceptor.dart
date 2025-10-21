import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/security/session_manager.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Interceptor responsável por autenticação e refresh automático de tokens.
///
/// Este interceptor gerencia todo o fluxo de autenticação das requisições HTTP:
///
/// ## Funcionalidades:
/// 1. **Anexação Automática de Token**: Adiciona Bearer token em todas as requisições
/// 2. **Refresh Automático**: Renova token expirado quando recebe erro 401
/// 3. **Controle de Concorrência**: Evita múltiplas tentativas simultâneas de refresh
/// 4. **Retry Inteligente**: Reexecuta requisições após refresh bem-sucedido
/// 5. **Logout Automático**: Redireciona para login após falha de refresh
///
/// ## Fluxo de Autenticação:
/// ```
/// Request → Adiciona Token → Envia
///    ↓
/// 401 Unauthorized?
///    ↓ Sim
/// Já refreshing?
///    ↓ Não
/// Refresh Token → Sucesso? → Retry Request
///    ↓ Não
/// Logout → Redirect Login
/// ```
class AuthInterceptor extends Interceptor {
  // ==========================================================================
  // DEPENDÊNCIAS
  // ==========================================================================

  /// Instância do Dio usada para retry de requisições.
  final Dio _dio;

  /// Construtor que recebe a instância do Dio.
  AuthInterceptor(this._dio);

  // ==========================================================================
  // ESTADO DE CONTROLE DE REFRESH
  // ==========================================================================

  /// Flag que indica se uma operação de refresh está em andamento.
  bool _isRefreshing = false;

  /// Completer usado para sincronizar múltiplas requisições durante refresh.
  Completer<void>? _refreshCompleter;

  // ==========================================================================
  // INTERCEPTOR DE REQUEST
  // ==========================================================================

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Obtém SessionManager e token
      final sessionManager = g.Get.find<SessionManager>();
      
      // NOTA: Usamos tokenSync aqui pois interceptors precisam de acesso síncrono.
      // O token é mantido em cache em memória após ser carregado do SecureStorage.
      // ignore: deprecated_member_use_from_same_package
      final token = sessionManager.tokenSync;

      // Anexa token ao header se disponível
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        AppLogger.d('🔐 Token adicionado ao header', tag: 'AuthInterceptor');
      }
    } catch (e) {
      AppLogger.w('⚠️ Erro ao adicionar token: $e', tag: 'AuthInterceptor');
    }

    handler.next(options);
  }

  // ==========================================================================
  // INTERCEPTOR DE ERROR - REFRESH DE TOKEN
  // ==========================================================================

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    // Apenas processa erros 401 (Unauthorized)
    if (status != 401) {
      return handler.next(err);
    }

    try {
      final sessionManager = g.Get.find<SessionManager>();
      final refreshToken = sessionManager.usuario?.refreshToken;
      final options = err.requestOptions;

      // Recupera número de tentativas de refresh
      final int retryCount = (options.extra['refreshAttempts'] ?? 0) as int;

      // Verifica limite de tentativas
      if (retryCount >= ApiConstants.maxRefreshAttempts) {
        AppLogger.e(
          '❌ Máximo de tentativas de refresh atingido',
          tag: 'AuthInterceptor',
        );
        await _performLogout(sessionManager);
        return handler.next(err);
      }

      // Verifica se há refresh token disponível
      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.w(
          '🚫 Refresh token ausente. Deixando erro 401 passar.',
          tag: 'AuthInterceptor',
        );
        return handler.next(err);
      }

      // Se já está refreshing, aguarda conclusão
      if (_isRefreshing) {
        final newToken = await _waitForRefresh(sessionManager);
        if (newToken != null) {
          final retryResponse = await _retryRequest(options, newToken, retryCount);
          return handler.resolve(retryResponse);
        }
        return handler.next(err);
      }

      // Inicia processo de refresh
      AppLogger.w(
        '🔁 Tentando renovar token... (tentativa ${retryCount + 1})',
        tag: 'AuthInterceptor',
      );

      final newToken = await _performRefresh(sessionManager, refreshToken);

      if (newToken != null) {
        final retryResponse = await _retryRequest(options, newToken, retryCount);
        return handler.resolve(retryResponse);
      }

      // Se refresh falhou, faz logout
      await _performLogout(sessionManager);
      return handler.next(err);
    } catch (e, s) {
      AppLogger.e(
        '❌ Erro no interceptor de autenticação',
        tag: 'AuthInterceptor',
        error: e,
        stackTrace: s,
      );
      return handler.next(err);
    }
  }

  // ==========================================================================
  // MÉTODOS AUXILIARES
  // ==========================================================================

  /// Aguarda a conclusão de um refresh em andamento.
  Future<String?> _waitForRefresh(SessionManager sessionManager) async {
    AppLogger.d('🔄 Aguardando outra renovação de token', tag: 'AuthInterceptor');

    try {
      await _refreshCompleter?.future.timeout(const Duration(seconds: 5));
      
      // NOTA: Usa tokenSync para acesso síncrono após refresh
      // ignore: deprecated_member_use_from_same_package
      final newToken = sessionManager.tokenSync;

      if (newToken != null && newToken.isNotEmpty) {
        return newToken;
      }
    } catch (e) {
      AppLogger.w('⏱️ Timeout aguardando refresh', tag: 'AuthInterceptor');
    }

    return null;
  }

  /// Executa o processo de refresh do token.
  Future<String?> _performRefresh(
    SessionManager sessionManager,
    String refreshToken,
  ) async {
    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      // Executa refresh com timeout
      await sessionManager.authService
          .refreshToken(refreshToken)
          .timeout(const Duration(seconds: 5));

      // Marca como concluído
      _refreshCompleter?.complete();
      _isRefreshing = false;

      // Retorna o novo token
      // NOTA: Usa tokenSync para acesso síncrono após refresh
      // ignore: deprecated_member_use_from_same_package
      final newToken = sessionManager.tokenSync;
      if (newToken != null && newToken.isNotEmpty) {
        AppLogger.i('✅ Token renovado com sucesso', tag: 'AuthInterceptor');
        return newToken;
      }
    } catch (e, s) {
      // Completa com erro
      if (!(_refreshCompleter?.isCompleted ?? true)) {
        _refreshCompleter?.completeError(e, s);
      }
      _isRefreshing = false;

      AppLogger.e(
        '🚫 Falha ao renovar token',
        tag: 'AuthInterceptor',
        error: e,
        stackTrace: s,
      );
    }

    return null;
  }

  /// Reexecuta a requisição original com o novo token.
  Future<Response<dynamic>> _retryRequest(
    RequestOptions options,
    String token,
    int currentRetryCount,
  ) async {
    // Atualiza o token e incrementa contador de tentativas
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['refreshAttempts'] = currentRetryCount + 1;

    AppLogger.d('🔁 Retentando requisição após refresh', tag: 'AuthInterceptor');

    // Reexecuta a requisição usando a instância do Dio injetada
    return await _dio.fetch(options);
  }

  /// Executa logout e redireciona para tela de login.
  Future<void> _performLogout(SessionManager sessionManager) async {
    AppLogger.w('👋 Forçando logout devido a falha de autenticação', tag: 'AuthInterceptor');

    try {
      await sessionManager.logout();
      await g.Get.offAllNamed('/login');
    } catch (e) {
      AppLogger.e('❌ Erro ao fazer logout', tag: 'AuthInterceptor', error: e);
    }
  }
}

