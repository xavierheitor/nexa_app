import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' as g;
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/app_version.dart';

/// Cliente HTTP centralizado para comunicação com APIs externas.
///
/// Esta classe implementa um cliente HTTP robusto baseado no framework Dio,
/// fornecendo funcionalidades avançadas de comunicação de rede, incluindo
/// autenticação automática, refresh de tokens, logging detalhado e tratamento
/// padronizado de erros para toda a aplicação.
///
/// ## Funcionalidades Principais:
///
/// 1. **Configuração Centralizada**: Base URL, timeouts e configurações padrão
/// 2. **Autenticação Automática**: Anexação automática de Bearer Token nas requisições
/// 3. **Refresh de Token**: Renovação automática de tokens expirados (401)
/// 4. **Logging Detalhado**: Logs completos de requests/responses para debugging
/// 5. **Tratamento de Erros**: Tratamento padronizado de diferentes tipos de erro
/// 6. **Controle de Concorrência**: Prevenção de múltiplas tentativas simultâneas de refresh
/// 7. **Versionamento**: Anexação automática da versão do app nos headers
///
/// ## Arquitetura:
///
/// - **Singleton Pattern**: Instância única para toda a aplicação
/// - **Interceptor Pattern**: Interceptação de requests/responses via Dio
/// - **Completer Pattern**: Controle de operações assíncronas de refresh
/// - **Error Handling**: Tratamento centralizado de exceções de rede
///
/// ## Fluxo de Autenticação:
///
/// 1. Request é interceptado e token é anexado automaticamente
/// 2. Se token expirou (401), inicia processo de refresh
/// 3. Outras requisições aguardam o refresh em andamento
/// 4. Após refresh bem-sucedido, requisição é reexecutada
/// 5. Se refresh falha, usuário é redirecionado para login
///
/// ## Tratamento de Erros:
///
/// - **401 Unauthorized**: Refresh automático de token
/// - **Timeout**: Tempo de conexão esgotado
/// - **Connection Error**: Falha de conectividade
/// - **Server Error**: Erros do servidor (500, etc.)
/// - **SSL Error**: Problemas de certificado
///
/// ## Uso:
///
/// ```dart
/// final dioClient = DioClient();
///
/// // GET request
/// final response = await dioClient.get('/users');
///
/// // POST request
/// final response = await dioClient.post('/login', data: credentials);
/// ```
///
/// ## Dependências:
/// - `Dio`: Framework HTTP para Dart/Flutter
/// - `SessionManager`: Gerenciamento de sessões e tokens
/// - `AppLogger`: Sistema de logging centralizado
/// - `AppVersion`: Informações de versão do aplicativo
/// - `ApiConstants`: Configurações de API e constantes
class DioClient {
  // ============================================================================
  // CONFIGURAÇÃO E ESTADO DO CLIENTE HTTP
  // ============================================================================

  /// Instância do cliente HTTP Dio configurado com interceptors e opções.
  ///
  /// Esta instância contém toda a configuração necessária para comunicação
  /// com APIs, incluindo base URL, timeouts e interceptors para autenticação,
  /// logging e tratamento de erros.
  final dio.Dio _dio;

  /// Flag que indica se uma operação de refresh de token está em andamento.
  ///
  /// Esta flag previne múltiplas tentativas simultâneas de refresh de token,
  /// garantindo que apenas uma operação de renovação seja executada por vez.
  /// Outras requisições que recebem 401 aguardam a conclusão desta operação.
  bool _isRefreshing = false;

  /// Completer usado para sincronizar múltiplas requisições durante refresh de token.
  ///
  /// Quando uma requisição inicia o processo de refresh, outras requisições
  /// que recebem 401 aguardam a conclusão através deste completer, evitando
  /// múltiplas tentativas desnecessárias de renovação de token.
  Completer<void>? _refreshCompleter;

  /// Construtor do DioClient que inicializa o cliente HTTP com configurações padrão.
  ///
  /// Este construtor configura o cliente Dio com:
  /// - Base URL obtida de `ApiConstants`
  /// - Timeouts de conexão e recebimento de 10 segundos
  /// - Interceptors para autenticação, logging e tratamento de erros
  ///
  /// ## Configurações Aplicadas:
  /// - **Base URL**: Configurada através de `ApiConstants.baseUrl`
  /// - **Connect Timeout**: 10 segundos para estabelecer conexão
  /// - **Receive Timeout**: 10 segundos para receber resposta
  /// - **Interceptors**: Autenticação, logging e tratamento de erros
  DioClient()
      : _dio = dio.Dio(
          dio.BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    // ============================================================================
    // CONFIGURAÇÃO DOS INTERCEPTORS DO DIO
    // ============================================================================

    /// Adiciona o interceptor principal que gerencia autenticação, logging
    /// e tratamento de erros para todas as requisições HTTP.
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        // ========================================================================
        // INTERCEPTOR DE REQUESTS (ANTES DO ENVIO)
        // ========================================================================

        /// Interceptor executado antes de cada requisição ser enviada.
        /// Responsável por anexar headers de autenticação, versionamento
        /// e logging detalhado das requisições.
        onRequest: (options, handler) {
          // ====================================================================
          // CONFIGURAÇÃO DE AUTENTICAÇÃO
          // ====================================================================

          /// Obtém o gerenciador de sessão através do sistema de injeção
          /// de dependências do GetX para acessar o token de autenticação.
          final sessionManager = g.Get.find<SessionManager>();

          /// Recupera o token de autenticação de forma síncrona.
          /// O token é obtido do SessionManager que gerencia toda a sessão do usuário.
          final token = sessionManager.tokenSync;

          /// Anexa o token Bearer ao header Authorization se disponível.
          /// Isso garante que todas as requisições incluam automaticamente
          /// as credenciais de autenticação necessárias.
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            AppLogger.d('🔐 Token adicionado ao header');
          }

          // ====================================================================
          // CONFIGURAÇÃO DE HEADERS PADRÃO
          // ====================================================================

          /// Define o Content-Type padrão para todas as requisições.
          /// Isso garante que o servidor entenda que estamos enviando JSON.
          options.headers['Content-Type'] = 'application/json';

          /// Anexa a versão completa do aplicativo ao header.
          /// Isso permite que o servidor identifique a versão do cliente
          /// para compatibilidade, logging e analytics.
          options.headers['App-Version'] = AppVersion.fullVersion;

          /// Registra a adição da versão do app para debugging.
          AppLogger.d('📱 Versão do app adicionada: ${AppVersion.fullVersion}');

          // ====================================================================
          // LOGGING DETALHADO DA REQUISIÇÃO
          // ====================================================================

          /// Inicia o logging detalhado da requisição para debugging e monitoramento.
          /// Os logs incluem método, URL, headers e body da requisição.
          AppLogger.v('➡️ [API REQUEST]');
          AppLogger.v('🔹 Method: ${options.method}');
          AppLogger.v('🔹 URL: ${options.uri}');

          /// Cria uma cópia segura dos headers para logging, mascarando o token
          /// de autenticação para evitar exposição de credenciais em logs.
          final headersSafe = Map.of(options.headers);
          if (headersSafe.containsKey('Authorization')) {
            headersSafe['Authorization'] = 'Bearer ***';
          }
          AppLogger.v('🔹 Headers: $headersSafe');
          AppLogger.v('🔹 Body: ${options.data}');

          /// Prossegue com a requisição após configuração completa.
          handler.next(options);
        },
        // ========================================================================
        // INTERCEPTOR DE RESPONSES (APÓS RECEBIMENTO)
        // ========================================================================

        /// Interceptor executado após receber uma resposta bem-sucedida do servidor.
        /// Responsável por logging detalhado das respostas para debugging e monitoramento.
        onResponse: (response, handler) {
          /// Registra o recebimento de uma resposta bem-sucedida.
          /// Os logs incluem status code, URL e dados da resposta para
          /// facilitar debugging e monitoramento de APIs.
          AppLogger.i('✅ [API RESPONSE]');
          AppLogger.v('🔸 Status: ${response.statusCode}');
          AppLogger.v('🔸 URL: ${response.requestOptions.uri}');
          AppLogger.v('🔸 Data: ${response.data}');

          /// Prossegue com o processamento da resposta.
          handler.next(response);
        },
        // ========================================================================
        // INTERCEPTOR DE ERROS (TRATAMENTO DE FALHAS)
        // ========================================================================

        /// Interceptor executado quando uma requisição falha ou retorna erro.
        /// Responsável pelo tratamento centralizado de erros, incluindo refresh
        /// automático de tokens, tratamento de diferentes tipos de erro e logging detalhado.
        onError: (error, handler) async {
          // ====================================================================
          // EXTRAÇÃO DE INFORMAÇÕES DO ERRO
          // ====================================================================

          /// Extrai informações essenciais do erro para tratamento e logging.
          final status = error.response?.statusCode ?? 0;
          final uri = error.requestOptions.uri;
          final tipo = error.type;
          final options = error.requestOptions;
          final session = g.Get.find<SessionManager>();

          /// Recupera o número de tentativas de refresh já realizadas para esta requisição.
          /// Isso previne loops infinitos de tentativas de renovação de token.
          final int retryCount = (options.extra['refreshAttempts'] ?? 0) as int;

          // ====================================================================
          // TRATAMENTO DE ERRO 401 (UNAUTHORIZED)
          // ====================================================================

          /// Trata erros de autenticação (401) com refresh automático de token.
          /// Este é o fluxo mais complexo, envolvendo renovação de token e retry da requisição.
          if (status == 401) {
            /// Verifica se já excedeu o número máximo de tentativas de refresh.
            /// Isso previne loops infinitos e força logout após falhas repetidas.
            if (retryCount >= ApiConstants.maxRefreshAttempts) {
              AppLogger.e(
                  '❌ Máximo de tentativas de refresh atingido para $uri');
              await session.logout();
              await g.Get.offAllNamed('/login');
              return handler.next(error);
            }

            /// Verifica se há um usuário logado e refresh token disponível antes de tentar renovar.
            final refreshToken = session.usuario?.refreshToken;
            if (refreshToken == null || refreshToken.isEmpty) {
              /// Se não há refresh token, deixa o erro 401 passar para ser tratado pelo controller.
              /// Isso permite que erros de login (credenciais inválidas) sejam exibidos corretamente.
              AppLogger.w(
                  '🚫 Refresh token ausente. Deixando erro 401 passar para tratamento.');
              return handler.next(error);
            }

            /// Se já existe um refresh em andamento, aguarda sua conclusão
            /// para evitar múltiplas tentativas simultâneas de renovação.
            if (_isRefreshing) {
              AppLogger.d('🔄 Aguardando outra renovação de token');
              try {
                /// Aguarda a conclusão do refresh em andamento com timeout de 5 segundos.
                await _refreshCompleter?.future
                    .timeout(const Duration(seconds: 5));

                /// Após o refresh, tenta usar o novo token para reexecutar a requisição.
                final newToken = session.tokenSync;
                if (newToken != null && newToken.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $newToken';
                  options.extra['refreshAttempts'] = retryCount + 1;
                  final retryResponse = await _dio.fetch(options);
                  return handler.resolve(retryResponse);
                }
              } catch (_) {
                /// Se o timeout ou outro erro ocorrer, prossegue com o erro original.
                return handler.next(error);
              }
            }

            /// Inicia o processo de refresh de token.
            AppLogger.w(
                '🔁 Tentando renovar token... (tentativa ${retryCount + 1})');
            _isRefreshing = true;
            _refreshCompleter = Completer();

            try {
              /// Executa a renovação do token através do serviço de autenticação.
              await session.authService
                  .refreshToken(refreshToken)
                  .timeout(const Duration(seconds: 5));

              /// Marca o refresh como concluído e libera outras requisições aguardando.
              _refreshCompleter?.complete();
              _isRefreshing = false;

              /// Após refresh bem-sucedido, reexecuta a requisição original com o novo token.
              final newToken = session.tokenSync;
              if (newToken != null && newToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $newToken';
                options.extra['refreshAttempts'] = retryCount + 1;
                AppLogger.d('🔁 Retentando requisição após refresh');
                final retryResponse = await _dio.fetch(options);
                return handler.resolve(retryResponse);
              }
            } catch (e, s) {
              /// Em caso de falha no refresh, limpa o estado e força logout.
              if (!(_refreshCompleter?.isCompleted ?? true)) {
                _refreshCompleter?.completeError(e, s);
              }
              _isRefreshing = false;

              AppLogger.e('🚫 Falha ao renovar token. Forçando logout.',
                  error: e, stackTrace: s);
              await session.logout();
              await g.Get.offAllNamed('/login');
            }

            /// Se chegou até aqui, prossegue com o erro original.
            return handler.next(error);
          }

          // ====================================================================
          // TRATAMENTO GENÉRICO DE ERROS DE REDE
          // ====================================================================

          /// Trata diferentes tipos de erro de rede com mensagens padronizadas.
          /// Isso garante que os usuários recebam mensagens de erro claras e úteis.
          String mensagem;
          switch (tipo) {
            case dio.DioExceptionType.connectionTimeout:
            case dio.DioExceptionType.sendTimeout:
            case dio.DioExceptionType.receiveTimeout:
              mensagem = 'Tempo de conexão esgotado';
              break;
            case dio.DioExceptionType.connectionError:
              mensagem = 'Falha de conexão: verifique sua internet';
              break;
            case dio.DioExceptionType.badResponse:
              mensagem = status == 500
                  ? 'Erro interno no servidor (500)'
                  : 'Erro do servidor: status $status';
              break;
            case dio.DioExceptionType.cancel:
              mensagem = 'Requisição cancelada';
              break;
            case dio.DioExceptionType.unknown:
              mensagem = 'Erro desconhecido de rede';
              break;
            case dio.DioExceptionType.badCertificate:
              mensagem = 'Certificado SSL inválido';
              break;
          }

          // ====================================================================
          // LOGGING DETALHADO DO ERRO
          // ====================================================================

          /// Registra informações detalhadas do erro para debugging e monitoramento.
          /// Os logs incluem status, URL, tipo de erro e dados da resposta.
          AppLogger.e('❌ [API ERROR]');
          AppLogger.e('🔻 Status: $status');
          AppLogger.e('🔻 URL: $uri');
          AppLogger.e('🔻 Tipo: $tipo');
          AppLogger.e('🔻 Mensagem tratada: $mensagem');
          AppLogger.v('🔻 Body: ${error.response?.data}');

          /// Rejeita o erro com informações tratadas e padronizadas.
          return handler.reject(
            dio.DioException(
              requestOptions: options,
              error: mensagem,
              type: tipo,
              response: error.response,
            ),
          );
        },
      ),
    );
  }

  // ============================================================================
  // MÉTODOS HTTP PÚBLICOS
  // ============================================================================

  /// Executa uma requisição HTTP GET.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (será concatenado com baseUrl)
  /// - `queryParameters`: Parâmetros de query opcionais
  ///
  /// ## Retorno:
  /// - `Future<dio.Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.get('/users', queryParameters: {'page': 1});
  /// ```
  Future<dio.Response> get(String path,
      {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  /// Executa uma requisição HTTP POST.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (será concatenado com baseUrl)
  /// - `data`: Dados a serem enviados no body da requisição
  ///
  /// ## Retorno:
  /// - `Future<dio.Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.post('/login', data: {'email': 'user@example.com'});
  /// ```
  Future<dio.Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  /// Executa uma requisição HTTP PUT.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (será concatenado com baseUrl)
  /// - `data`: Dados a serem enviados no body da requisição
  ///
  /// ## Retorno:
  /// - `Future<dio.Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.put('/users/123', data: {'name': 'John'});
  /// ```
  Future<dio.Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  /// Executa uma requisição HTTP DELETE.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (será concatenado com baseUrl)
  ///
  /// ## Retorno:
  /// - `Future<dio.Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.delete('/users/123');
  /// ```
  Future<dio.Response> delete(String path) {
    return _dio.delete(path);
  }

  // ============================================================================
  // ACESSO AO CLIENTE DIO
  // ============================================================================

  /// Retorna a instância do cliente Dio para acesso direto.
  ///
  /// Este getter permite acesso direto ao cliente Dio subjacente para casos
  /// onde funcionalidades específicas do Dio são necessárias que não estão
  /// expostas pelos métodos públicos desta classe.
  ///
  /// ## Uso:
  /// ```dart
  /// final dio = dioClient.client;
  /// final response = await dio.patch('/path', data: data);
  /// ```
  dio.Dio get client => _dio;
}
