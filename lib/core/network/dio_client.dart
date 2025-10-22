import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/network/connectivity_service.dart';
import 'package:nexa_app/core/network/interceptors/auth_interceptor.dart';
import 'package:nexa_app/core/network/interceptors/connectivity_interceptor.dart';
import 'package:nexa_app/core/network/interceptors/error_handler_interceptor.dart';
import 'package:nexa_app/core/network/interceptors/headers_interceptor.dart';
import 'package:nexa_app/core/network/interceptors/logging_interceptor.dart';

/// Cliente HTTP centralizado para comunicação com APIs externas.
///
/// Esta classe implementa um cliente HTTP robusto baseado no framework Dio,
/// fornecendo funcionalidades avançadas de comunicação de rede através de
/// interceptors especializados.
///
/// ## Funcionalidades Principais:
///
/// 1. **Configuração Centralizada**: Base URL, timeouts e configurações padrão
/// 2. **Autenticação Automática**: Anexação e refresh automático de tokens (via AuthInterceptor)
/// 3. **Logging Detalhado**: Logs completos de requests/responses (via LoggingInterceptor)
/// 4. **Headers Padrão**: Versionamento e content-type automáticos (via HeadersInterceptor)
/// 5. **Tratamento de Erros**: Mensagens amigáveis e padronizadas (via ErrorHandlerInterceptor)
///
/// ## Arquitetura:
///
/// - **Singleton Pattern**: Instância única para toda a aplicação
/// - **Interceptor Pattern**: Separação de responsabilidades em interceptors dedicados
/// - **Clean Architecture**: DioClient focado apenas em configuração e delegação
///
/// ## Interceptors (ordem de execução):
///
/// **Request (ordem)**:
/// 1. HeadersInterceptor → Adiciona headers padrão
/// 2. AuthInterceptor → Adiciona token de autenticação
/// 3. LoggingInterceptor → Registra requisição
///
/// **Response (ordem inversa)**:
/// 1. LoggingInterceptor → Registra resposta
/// 2. AuthInterceptor → (não processa response)
/// 3. HeadersInterceptor → (não processa response)
///
/// **Error (ordem inversa)**:
/// 1. LoggingInterceptor → Registra erro
/// 2. AuthInterceptor → Trata 401 e refresh de token
/// 3. ErrorHandlerInterceptor → Traduz erros para mensagens amigáveis
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
///
/// // PUT request
/// final response = await dioClient.put('/users/123', data: userData);
///
/// // DELETE request
/// final response = await dioClient.delete('/users/123');
/// ```
///
/// ## Dependências:
/// - `Dio`: Framework HTTP para Dart/Flutter
/// - `AuthInterceptor`: Gerenciamento de autenticação e tokens
/// - `LoggingInterceptor`: Sistema de logging de requisições
/// - `HeadersInterceptor`: Configuração de headers padrão
/// - `ErrorHandlerInterceptor`: Tratamento padronizado de erros
/// - `ApiConstants`: Configurações de API e constantes
class DioClient {
  // ==========================================================================
  // CONFIGURAÇÃO DO CLIENTE HTTP
  // ==========================================================================

  /// Instância do cliente HTTP Dio configurado com interceptors.
  final dio.Dio _dio;

  /// Construtor do DioClient que inicializa o cliente HTTP.
  ///
  /// Configura o cliente Dio com:
  /// - Base URL obtida de `ApiConstants`
  /// - Timeouts de 30 segundos (conexão, envio e recebimento)
  /// - Interceptors especializados para diferentes responsabilidades
  ///
  /// ## Configurações:
  /// - **Base URL**: `ApiConstants.baseUrl`
  /// - **Connect Timeout**: 30 segundos
  /// - **Receive Timeout**: 30 segundos
  /// - **Send Timeout**: 30 segundos
  ///
  /// ## Interceptors (na ordem de adição):
  /// 1. `HeadersInterceptor`: Headers padrão e versionamento
  /// 2. `AuthInterceptor`: Autenticação e refresh de tokens
  /// 3. `LoggingInterceptor`: Logging detalhado
  /// 4. `ErrorHandlerInterceptor`: Tratamento de erros
  DioClient()
      : _dio = dio.Dio(
          dio.BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
        ) {
    _setupInterceptors();
  }

  // ==========================================================================
  // CONFIGURAÇÃO DE INTERCEPTORS
  // ==========================================================================

  /// Configura todos os interceptors necessários na ordem correta.
  ///
  /// A ordem de adição é importante pois define a ordem de execução:
  /// - Na requisição: executam na ordem de adição
  /// - Na resposta/erro: executam na ordem inversa
  void _setupInterceptors() {
    // 1. Connectivity (executado primeiro - verifica conectividade)
    _dio.interceptors
        .add(ConnectivityInterceptor(Get.find<ConnectivityService>()));

    // 2. Headers padrão (executado após verificação de conectividade)
    _dio.interceptors.add(HeadersInterceptor());

    // 3. Autenticação (adiciona token após headers padrão)
    // Passa a instância do Dio para permitir retry de requisições
    _dio.interceptors.add(AuthInterceptor(_dio));

    // 4. Logging (registra tudo após configuração completa)
    _dio.interceptors.add(LoggingInterceptor());

    // 5. Tratamento de erros (último na cadeia de errors)
    _dio.interceptors.add(ErrorHandlerInterceptor());
  }

  // ==========================================================================
  // MÉTODOS HTTP PÚBLICOS
  // ==========================================================================

  /// Executa uma requisição HTTP GET.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (concatenado com baseUrl)
  /// - `queryParameters`: Parâmetros de query opcionais
  ///
  /// ## Retorno:
  /// - `Future<Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.get(
  ///   '/users',
  ///   queryParameters: {'page': 1, 'limit': 10},
  /// );
  /// ```
  Future<dio.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  /// Executa uma requisição HTTP POST.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (concatenado com baseUrl)
  /// - `data`: Dados a serem enviados no body da requisição
  ///
  /// ## Retorno:
  /// - `Future<Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.post(
  ///   '/login',
  ///   data: {'email': 'user@example.com', 'password': '123456'},
  /// );
  /// ```
  Future<dio.Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  /// Executa uma requisição HTTP PUT.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (concatenado com baseUrl)
  /// - `data`: Dados a serem enviados no body da requisição
  ///
  /// ## Retorno:
  /// - `Future<Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.put(
  ///   '/users/123',
  ///   data: {'name': 'John Doe', 'email': 'john@example.com'},
  /// );
  /// ```
  Future<dio.Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  /// Executa uma requisição HTTP DELETE.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (concatenado com baseUrl)
  ///
  /// ## Retorno:
  /// - `Future<Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.delete('/users/123');
  /// ```
  Future<dio.Response> delete(String path) {
    return _dio.delete(path);
  }

  /// Executa uma requisição HTTP PATCH.
  ///
  /// ## Parâmetros:
  /// - `path`: Caminho relativo da API (concatenado com baseUrl)
  /// - `data`: Dados a serem enviados no body da requisição
  ///
  /// ## Retorno:
  /// - `Future<Response>`: Resposta da requisição
  ///
  /// ## Exemplo:
  /// ```dart
  /// final response = await dioClient.patch(
  ///   '/users/123',
  ///   data: {'status': 'active'},
  /// );
  /// ```
  Future<dio.Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }

  // ==========================================================================
  // ACESSO DIRETO AO CLIENTE DIO
  // ==========================================================================

  /// Retorna a instância do cliente Dio para acesso direto.
  ///
  /// Este getter permite acesso direto ao cliente Dio subjacente para casos
  /// onde funcionalidades específicas do Dio são necessárias que não estão
  /// expostas pelos métodos públicos desta classe.
  ///
  /// **Nota**: Use com cautela. Prefira usar os métodos públicos quando possível
  /// para manter a consistência e garantir que os interceptors sejam aplicados.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final dio = dioClient.client;
  /// final response = await dio.download('/file', '/path/to/save');
  /// ```
  dio.Dio get client => _dio;
}
