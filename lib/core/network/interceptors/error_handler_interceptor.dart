import 'package:dio/dio.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

/// Interceptor responsável por tratamento padronizado de erros HTTP.
///
/// Este interceptor transforma erros genéricos do Dio em mensagens
/// mais amigáveis e compreensíveis para o usuário final.
///
/// ## Tipos de Erro Tratados:
/// 1. **Timeout**: Conexão, envio ou recebimento
/// 2. **Connection Error**: Sem internet ou servidor inacessível
/// 3. **Bad Response**: Respostas com códigos de erro (4xx, 5xx)
/// 4. **Cancel**: Requisição cancelada pelo usuário
/// 5. **Bad Certificate**: Problemas com SSL/TLS
/// 6. **Unknown**: Erros inesperados
///
/// ## Nota sobre 401:
/// Erros 401 (Unauthorized) são tratados pelo AuthInterceptor
/// e não são modificados aqui para não interferir no fluxo de refresh.
class ErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Ignora 401 - será tratado pelo AuthInterceptor
    if (err.response?.statusCode == 401) {
      return handler.next(err);
    }

    // Traduz tipo de erro para mensagem amigável
    final mensagem = _getErrorMessage(err);

    AppLogger.e(
      '🔻 Erro tratado: $mensagem',
      tag: 'ErrorHandler',
    );

    // Rejeita com mensagem traduzida
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mensagem,
        type: err.type,
        response: err.response,
      ),
    );
  }

  // ==========================================================================
  // MÉTODOS AUXILIARES
  // ==========================================================================

  /// Traduz DioExceptionType em mensagem amigável.
  String _getErrorMessage(DioException err) {
    final status = err.response?.statusCode ?? 0;
    final tipo = err.type;

    switch (tipo) {
      case DioExceptionType.connectionTimeout:
        return 'Tempo de conexão esgotado. Verifique sua internet.';

      case DioExceptionType.sendTimeout:
        return 'Tempo esgotado ao enviar dados. Tente novamente.';

      case DioExceptionType.receiveTimeout:
        return 'Tempo esgotado ao receber dados. Tente novamente.';

      case DioExceptionType.connectionError:
        return 'Falha de conexão. Verifique sua internet.';

      case DioExceptionType.badResponse:
        return _getBadResponseMessage(status, err.response?.data);

      case DioExceptionType.cancel:
        return 'Requisição cancelada.';

      case DioExceptionType.badCertificate:
        return 'Certificado SSL inválido. Verifique a segurança da conexão.';

      case DioExceptionType.unknown:
        return _getUnknownErrorMessage(err);
    }
  }

  /// Retorna mensagem específica para erros de resposta (4xx, 5xx).
  String _getBadResponseMessage(int status, dynamic responseData) {
    // Tenta extrair mensagem do backend
    if (responseData is Map && responseData.containsKey('message')) {
      return responseData['message'].toString();
    }

    if (responseData is Map && responseData.containsKey('error')) {
      return responseData['error'].toString();
    }

    // Mensagens padrão por status code
    switch (status) {
      case 400:
        return 'Requisição inválida. Verifique os dados enviados.';
      case 403:
        return 'Acesso negado. Você não tem permissão para esta ação.';
      case 404:
        return 'Recurso não encontrado.';
      case 422:
        return 'Dados inválidos. Verifique as informações.';
      case 429:
        return 'Muitas requisições. Aguarde um momento e tente novamente.';
      case 500:
        return 'Erro interno no servidor. Tente novamente mais tarde.';
      case 502:
        return 'Servidor temporariamente indisponível.';
      case 503:
        return 'Serviço em manutenção. Tente novamente em alguns minutos.';
      default:
        return 'Erro no servidor (status $status).';
    }
  }

  /// Retorna mensagem para erros desconhecidos.
  String _getUnknownErrorMessage(DioException err) {
    // Se tiver mensagem de erro original, usa ela
    if (err.message != null && err.message!.isNotEmpty) {
      return 'Erro de conexão: ${err.message}';
    }

    return 'Erro desconhecido. Verifique sua conexão e tente novamente.';
  }
}

