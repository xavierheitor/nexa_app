import 'package:nexa_app/core/utils/errors/tipo_erro.dart';

sealed class AppException implements Exception {
  final String mensagem;
  final TipoErro tipo;
  final StackTrace? stack;

  AppException(this.mensagem, {this.tipo = TipoErro.desconhecido, this.stack});
}

class ApiException extends AppException {
  final int? statusCode;
  ApiException(super.mensagem, {this.statusCode, super.stack})
      : super(tipo: TipoErro.api);
}

class NetworkException extends AppException {
  final Uri? uri;
  final int? statusCode;
  final dynamic response;

  NetworkException(
    super.mensagem, {
    this.uri,
    this.statusCode,
    this.response,
    super.stack,
  }) : super(tipo: TipoErro.api);

  @override
  String toString() {
    return 'NetworkException: $mensagem\n→ URL: $uri\n→ Status: $statusCode\n→ Response: $response';
  }
}

class AuthException extends AppException {
  AuthException(super.mensagem, {super.stack})
      : super(tipo: TipoErro.credenciais);
}

class LocalException extends AppException {
  LocalException(super.mensagem, {super.stack}) : super(tipo: TipoErro.banco);
}

/// Erros específicos para DTOs - integrado com o sistema principal
class DtoError extends AppException {
  final String? field;
  final dynamic value;
  final String? context;

  DtoError(super.mensagem, {this.field, this.value, this.context})
      : super(tipo: TipoErro.validacao);

  @override
  String toString() {
    final buffer = StringBuffer('DtoError: $mensagem');

    if (field != null) {
      buffer.write(' (campo: $field');
      if (value != null) {
        buffer.write(', valor: $value');
      }
      buffer.write(')');
    }

    if (context != null) {
      buffer.write(' [contexto: $context]');
    }

    return buffer.toString();
  }
}

/// Erro de validação de campo obrigatório
class RequiredFieldError extends DtoError {
  RequiredFieldError(String field, [dynamic value])
      : super('Campo obrigatório não informado', field: field, value: value);
}

/// Erro de formato de data inválido
class InvalidDateFormatError extends DtoError {
  InvalidDateFormatError(String field, dynamic value)
      : super('Formato de data inválido', field: field, value: value);
}

/// Erro de conversão de tipo
class TypeConversionError extends DtoError {
  TypeConversionError(String field, dynamic value, String expectedType)
      : super('Erro na conversão de tipo: esperado $expectedType',
            field: field, value: value);
}

/// Erro de JSON malformado ou inválido
class InvalidJsonError extends DtoError {
  InvalidJsonError(String message, [String? context])
      : super('JSON inválido: $message', context: context);
}
