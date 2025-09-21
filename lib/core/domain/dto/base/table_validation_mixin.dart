import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

/// Mixin para validações específicas de tabelas de banco de dados
mixin TableValidationMixin on BaseDto {
  /// Valida ID obrigatório
  void validateRequiredId(String id, [String fieldName = 'id']) {
    if (id.trim().isEmpty) {
      throw RequiredFieldError(fieldName, id);
    }
  }

  /// Valida string com tamanhos específicos de tabela
  void validateTableString(
    String value, 
    String fieldName, 
    {int minLength = 1, 
    int? maxLength}
  ) {
    if (value.trim().isEmpty) {
      throw RequiredFieldError(fieldName, value);
    }
    
    BaseDto.validateStringLength(value, fieldName, 
        minLength: minLength, maxLength: maxLength);
  }

  /// Valida matrícula (formato específico)
  void validateMatricula(String matricula) {
    validateTableString(matricula, 'matricula', minLength: 1);
    
    // Adicionar validações específicas de matrícula se necessário
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(matricula)) {
      throw DtoError('Matrícula deve conter apenas letras e números', 
                    field: 'matricula', value: matricula);
    }
  }

  /// Valida token (se presente)
  void validateToken(String? token) {
    if (token != null && token.isNotEmpty) {
      if (token.length < 10) {
        throw DtoError('Token deve ter pelo menos 10 caracteres', 
                      field: 'token', value: token);
      }
    }
  }

  /// Valida UUID/RemoteId
  void validateRemoteId(String remoteId) {
    validateTableString(remoteId, 'remoteId', minLength: 1, maxLength: 100);
  }

  /// Valida nome de usuário
  void validateNome(String nome) {
    validateTableString(nome, 'nome', minLength: 2, maxLength: 100);
  }

  /// Valida data não pode ser futura (para created/updated)
  void validateNotFutureDate(DateTime date, String fieldName) {
    final now = DateTime.now();
    if (date.isAfter(now)) {
      throw DtoError('$fieldName não pode ser uma data futura', 
                    field: fieldName, value: date.toIso8601String());
    }
  }

  /// Valida data não pode ser muito antiga (mais de 100 anos)
  void validateNotTooOldDate(DateTime date, String fieldName) {
    final hundredYearsAgo = DateTime.now().subtract(const Duration(days: 36525));
    if (date.isBefore(hundredYearsAgo)) {
      throw DtoError('$fieldName não pode ser anterior a 100 anos', 
                    field: fieldName, value: date.toIso8601String());
    }
  }
}
