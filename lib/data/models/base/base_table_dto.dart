import 'package:drift/drift.dart';
import 'package:nexa_app/data/models/base/base_dto.dart';
import 'package:nexa_app/data/models/base/drift_dto_mixin.dart';
import 'package:nexa_app/data/models/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

/// Classe base para DTOs de tabelas do Drift
/// Combina todas as funcionalidades necessárias
abstract class BaseTableDto extends BaseDto
    with DriftDtoMixin, TableValidationMixin {
  /// ID da entidade
  final String id;

  /// Data de criação
  final DateTime createdAt;

  BaseTableDto({
    required this.id,
    required this.createdAt,
  });

  /// Implementação padrão de validação para tabelas
  @override
  void validate() {
    validateRequiredId(id);
    validateNotFutureDate(createdAt, 'createdAt');
    validateNotTooOldDate(createdAt, 'createdAt');

    // Chama validação específica da subclasse
    validateSpecific();
  }

  /// Validações específicas que cada DTO deve implementar
  void validateSpecific();

  /// Converte para JSON com campos comuns de tabela
  @override
  Map<String, dynamic> toJson() {
    try {
      final json = <String, dynamic>{
        'id': id,
        'createdAt': createdAt.toIso8601String(),
      };

      // Adiciona campos específicos da subclasse
      json.addAll(toSpecificJson());

      return json;
    } catch (e) {
      throw DtoError('Erro ao converter DTO para JSON: $e', context: 'toJson');
    }
  }

  /// Método que cada DTO específico deve implementar para adicionar seus campos ao JSON
  Map<String, dynamic> toSpecificJson();

  /// Factory method para criar DTO a partir de JSON com tratamento de erro
  static T fromJson<T extends BaseTableDto>(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) constructor) {
    try {
      return constructor(json);
    } catch (e) {
      if (e is DtoError) rethrow;
      throw DtoError('Erro ao processar JSON do DTO: $e');
    }
  }

  /// Método helper para criar Value com tratamento de nulos
  Value<T?> createValue<T>(T? value) {
    return Value<T?>(value);
  }

  /// Método helper para criar Value com valor padrão
  Value<T> createValueWithDefault<T>(T? value, T defaultValue) {
    return Value(value ?? defaultValue);
  }
}
