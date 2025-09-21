import 'package:drift/drift.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';

/// Mixin para DTOs que se integram com Drift
/// Fornece métodos para conversão entre DTO e entidades do Drift
mixin DriftDtoMixin<Entity, Companion> on BaseDto {
  /// Converte o DTO para Companion (para inserção/atualização)
  Companion toCompanion();

  /// Converte entidade do Drift para DTO
  static Entity fromEntity<Entity, Companion>(dynamic entity) {
    throw UnimplementedError('fromEntity deve ser implementado pela classe específica');
  }

  /// Converte o DTO para entidade do Drift
  Entity toEntity();

  /// Método helper para criar Value com tratamento de nulos
  static Value<T?> createValue<T>(T? value) {
    return Value<T?>(value);
  }

  /// Método helper para criar Value com valor padrão
  static Value<T> createValueWithDefault<T>(T? value, T defaultValue) {
    return Value(value ?? defaultValue);
  }
}
