import 'package:dio/dio.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Interceptor responsável por logging detalhado de requisições HTTP.
///
/// Este interceptor registra informações completas sobre todas as requisições,
/// respostas e erros HTTP, facilitando debugging e monitoramento.
///
/// ## Funcionalidades:
/// 1. **Log de Requisições**: Registra método, URL, headers e body
/// 2. **Log de Respostas**: Registra status code, URL e dados
/// 3. **Log de Erros**: Registra detalhes completos de falhas
/// 4. **Segurança**: Mascara tokens de autenticação nos logs
///
/// ## Níveis de Log:
/// - `VERBOSE`: Detalhes completos (headers, body, data)
/// - `INFO`: Respostas bem-sucedidas
/// - `ERROR`: Falhas e erros
/// - `DEBUG`: Informações de autenticação e versionamento
class LoggingInterceptor extends Interceptor {
  // ==========================================================================
  // INTERCEPTOR DE REQUEST
  // ==========================================================================

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.v('➡️ [API REQUEST]', tag: 'HTTP');
    AppLogger.v('🔹 Method: ${options.method}', tag: 'HTTP');
    AppLogger.v('🔹 URL: ${options.uri}', tag: 'HTTP');

    // Cria cópia segura dos headers mascarando o token
    final headersSafe = _maskSensitiveHeaders(options.headers);
    AppLogger.v('🔹 Headers: $headersSafe', tag: 'HTTP');

    // Log do body (se houver)
    if (options.data != null) {
      AppLogger.v('🔹 Body: ${_formatBody(options.data)}', tag: 'HTTP');
    }

    handler.next(options);
  }

  // ==========================================================================
  // INTERCEPTOR DE RESPONSE
  // ==========================================================================

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i('✅ [API RESPONSE]', tag: 'HTTP');
    AppLogger.v('🔸 Status: ${response.statusCode}', tag: 'HTTP');
    AppLogger.v('🔸 URL: ${response.requestOptions.uri}', tag: 'HTTP');

    // Log dos dados da resposta (limitado para evitar logs muito grandes)
    if (response.data != null) {
      AppLogger.v('🔸 Data: ${_formatResponseData(response.data)}', tag: 'HTTP');
    }

    handler.next(response);
  }

  // ==========================================================================
  // INTERCEPTOR DE ERROR
  // ==========================================================================

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode ?? 0;
    final uri = err.requestOptions.uri;
    final tipo = err.type;

    AppLogger.e('❌ [API ERROR]', tag: 'HTTP');
    AppLogger.e('🔻 Status: $status', tag: 'HTTP');
    AppLogger.e('🔻 URL: $uri', tag: 'HTTP');
    AppLogger.e('🔻 Tipo: $tipo', tag: 'HTTP');

    // Log da mensagem de erro
    if (err.message != null) {
      AppLogger.e('🔻 Mensagem: ${err.message}', tag: 'HTTP');
    }

    // Log do body da resposta de erro (se houver)
    if (err.response?.data != null) {
      AppLogger.v('🔻 Body: ${_formatResponseData(err.response!.data)}', tag: 'HTTP');
    }

    handler.next(err);
  }

  // ==========================================================================
  // MÉTODOS AUXILIARES
  // ==========================================================================

  /// Mascara informações sensíveis dos headers para logging seguro.
  Map<String, dynamic> _maskSensitiveHeaders(Map<String, dynamic> headers) {
    final headersSafe = Map<String, dynamic>.of(headers);

    // Mascara token de autorização
    if (headersSafe.containsKey('Authorization')) {
      headersSafe['Authorization'] = 'Bearer ***';
    }

    // Mascara outros headers sensíveis se necessário
    final sensitiveKeys = ['api-key', 'x-api-key', 'password'];
    for (final key in sensitiveKeys) {
      if (headersSafe.containsKey(key)) {
        headersSafe[key] = '***';
      }
    }

    return headersSafe;
  }

  /// Formata o body da requisição para log.
  String _formatBody(dynamic data) {
    if (data == null) return 'null';

    try {
      // Se for Map, verifica se tem dados sensíveis para mascarar
      if (data is Map) {
        final safeDat = Map.from(data);
        final sensitiveKeys = ['password', 'senha', 'token', 'secret'];

        for (final key in sensitiveKeys) {
          if (safeDat.containsKey(key)) {
            safeDat[key] = '***';
          }
        }
        return safeDat.toString();
      }

      return data.toString();
    } catch (e) {
      return 'Error formatting body: $e';
    }
  }

  /// Formata dados da resposta limitando tamanho para evitar logs muito grandes.
  String _formatResponseData(dynamic data) {
    if (data == null) return 'null';

    try {
      final dataStr = data.toString();

      // Limita tamanho do log a 1000 caracteres
      if (dataStr.length > 1000) {
        return '${dataStr.substring(0, 1000)}... (truncated)';
      }

      return dataStr;
    } catch (e) {
      return 'Error formatting response: $e';
    }
  }
}

