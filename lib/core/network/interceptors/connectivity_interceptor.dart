import 'package:dio/dio.dart';
import 'package:nexa_app/core/network/connectivity_service.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Interceptor que verifica conectividade antes de fazer requests HTTP.
///
/// Funcionalidades:
/// - ✅ Verifica se está online antes de cada request
/// - ✅ Falha rapidamente se offline (sem timeout)
/// - ✅ Logs de status de conexão
/// - ✅ Previne requests desnecessários
class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService _connectivityService;

  ConnectivityInterceptor(this._connectivityService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Verifica conectividade antes de fazer o request
      if (!_connectivityService.isOnline.value) {
        AppLogger.w('Request cancelado: sem conexão - ${options.uri}',
            tag: 'ConnectivityInterceptor');
        
        // Retorna erro de conectividade sem fazer o request
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'Sem conexão com a internet',
          message: 'Verifique sua conexão e tente novamente',
        );
        
        handler.reject(error);
        return;
      }
    } catch (e) {
      // Se houver erro ao acessar ConnectivityService, permite o request
      AppLogger.w('Erro ao verificar conectividade, permitindo request: $e',
          tag: 'ConnectivityInterceptor');
      handler.next(options);
      return;
    }

    // Log do tipo de conexão para requests importantes
    if (_shouldLogConnectionType(options)) {
      AppLogger.d('Request via ${_connectivityService.connectionTypeDescription}: ${options.uri}',
          tag: 'ConnectivityInterceptor');
    }

    // Log para requests críticos
    if (_isCriticalRequest(options)) {
      AppLogger.d('Request crítico: ${options.uri}',
          tag: 'ConnectivityInterceptor');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Se o erro for de conectividade, atualiza o status
    if (_isConnectivityError(err)) {
      AppLogger.w('Erro de conectividade detectado: ${err.message}',
          tag: 'ConnectivityInterceptor');
      
      // Força verificação de conectividade
      _connectivityService.checkConnectivity();
    }

    handler.next(err);
  }

  /// Verifica se deve logar o tipo de conexão para este request
  bool _shouldLogConnectionType(RequestOptions options) {
    // Log para requests de sincronização e autenticação
    return options.uri.path.contains('/sync') ||
           options.uri.path.contains('/auth') ||
           options.uri.path.contains('/login');
  }

  /// Verifica se é um request crítico que requer boa conexão
  bool _isCriticalRequest(RequestOptions options) {
    // Requests críticos que precisam de boa conexão
    return options.uri.path.contains('/turno') ||
           options.uri.path.contains('/checklist') ||
           options.uri.path.contains('/upload');
  }

  /// Verifica se o erro é relacionado à conectividade
  bool _isConnectivityError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           (err.message?.toLowerCase().contains('network') ?? false) ||
           (err.message?.toLowerCase().contains('connection') ?? false);
  }
}
