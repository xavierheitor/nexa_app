import 'package:dio/dio.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';
import 'package:nexa_app/core/utils/errors/mensagem_erro.dart';
import 'package:nexa_app/core/utils/errors/tipo_erro.dart';


/// Tratador central de erros.
///
/// Converte erros de baixo nível (Dio, etc.) em exceções da camada de domínio
/// (`AppException`) e expõe mensagens amigáveis ao usuário via `MensagemErro`.
class ErrorHandler {
  static AppException tratar(dynamic error, [StackTrace? stack]) {
    if (error is AppException) return error;

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.unknown) {
        return NetworkException(
          _mensagemParaCodigo(error.response?.statusCode),
          uri: error.requestOptions.uri,
          statusCode: error.response?.statusCode,
          response: error.response?.data,
          stack: stack,
        );
      }

      final statusCode = error.response?.statusCode;
      final message = error.response?.data?['message'] ?? 'Erro desconhecido';

      return ApiException(message, statusCode: statusCode, stack: stack);
    }

    return LocalException('Erro inesperado', stack: stack);
  }

  static MensagemErro mensagemUsuario(Object error) {
    if (error is AppException) {
      switch (error.tipo) {
        case TipoErro.api:
          return MensagemErro(
            titulo: 'Erro de conexão',
            descricao:
                'Não foi possível acessar os servidores. Tente novamente mais tarde.',
          );
        case TipoErro.dados:
          return MensagemErro(
            titulo: 'Erro nos dados',
            descricao: 'Ocorreu um problema ao processar as informações.',
          );
        case TipoErro.credenciais:
          return MensagemErro(
            titulo: 'Credenciais inválidas',
            descricao: 'Matricula ou senha incorretos.',
          );
        case TipoErro.validacao:
          return MensagemErro(
            titulo: 'Erro de validação',
            descricao: _getValidationMessage(error),
          );
        case TipoErro.banco:
          return MensagemErro(
            titulo: 'Erro no banco de dados',
            descricao: 'Ocorreu um problema ao acessar os dados locais.',
          );
        default:
          return MensagemErro(
            titulo: 'Erro inesperado',
            descricao: 'Algo deu errado. Tente novamente.',
          );
      }
    }

    return MensagemErro(
      titulo: 'Erro desconhecido',
      descricao: 'Ocorreu um erro inesperado.',
    );
  }

  /// Gera mensagem amigável para erros de validação de DTO
  static String _getValidationMessage(AppException error) {
    if (error is RequiredFieldError) {
      return 'O campo "${error.field}" é obrigatório.';
    }
    
    if (error is InvalidDateFormatError) {
      return 'O campo "${error.field}" possui um formato de data inválido.';
    }
    
    if (error is TypeConversionError) {
      return 'O campo "${error.field}" possui um formato inválido.';
    }
    
    if (error is InvalidJsonError) {
      return 'Dados recebidos em formato inválido.';
    }
    
    if (error is DtoError) {
      return error.mensagem;
    }
    
    return 'Erro de validação nos dados.';
  }

  static String _mensagemParaCodigo(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida';
      case 401:
        return 'Não autorizado';
      case 404:
        return 'Recurso não encontrado';
      case 500:
        return 'Erro interno no servidor';
      default:
        return 'Erro de conexão';
    }
  }
}
