import 'package:nexa_app/core/utils/errors/app_exception.dart';

/// Classe base abstrata para todos os DTOs
/// Fornece funcionalidades comuns de validação e serialização
abstract class BaseDto {
  /// Converte o DTO para JSON
  Map<String, dynamic> toJson();

  /// Valida se o DTO está em estado válido
  /// Deve ser implementado por cada DTO específico
  void validate();

  /// Valida e converte string obrigatória
  static String validateRequiredString(dynamic value, String fieldName) {
    if (value == null) {
      throw RequiredFieldError(fieldName, value);
    }

    final stringValue = value.toString().trim();
    if (stringValue.isEmpty) {
      throw RequiredFieldError(fieldName, value);
    }

    return stringValue;
  }

  /// Converte data opcional com tratamento de erro
  static DateTime? parseOptionalDateTime(dynamic value,
      [String fieldName = 'dateTime']) {
    if (value == null) return null;

    try {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);

      throw TypeConversionError(fieldName, value, 'DateTime ou String');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw InvalidDateFormatError(fieldName, value);
    }
  }

  /// Converte data obrigatória com tratamento de erro
  static DateTime parseRequiredDateTime(dynamic value,
      [String fieldName = 'dateTime']) {
    if (value == null) {
      throw RequiredFieldError(fieldName, value);
    }

    try {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);

      throw TypeConversionError(fieldName, value, 'DateTime ou String');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw InvalidDateFormatError(fieldName, value);
    }
  }

  /// Valida string com tamanho mínimo e máximo
  static String validateStringLength(String value, String fieldName,
      {int minLength = 0, int? maxLength}) {
    final trimmedValue = value.trim();

    if (trimmedValue.length < minLength) {
      throw DtoError('$fieldName deve ter pelo menos $minLength caracteres',
          field: fieldName, value: value);
    }

    if (maxLength != null && trimmedValue.length > maxLength) {
      throw DtoError('$fieldName deve ter no máximo $maxLength caracteres',
          field: fieldName, value: value);
    }

    return trimmedValue;
  }

  /// Converte número opcional
  static int? parseOptionalInt(dynamic value, [String fieldName = 'int']) {
    if (value == null) return null;

    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.parse(value);

      throw TypeConversionError(fieldName, value, 'int, double ou String');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw TypeConversionError(fieldName, value, 'número');
    }
  }

  /// Converte número obrigatório
  static int parseRequiredInt(dynamic value, [String fieldName = 'int']) {
    if (value == null) {
      throw RequiredFieldError(fieldName, value);
    }

    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.parse(value);

      throw TypeConversionError(fieldName, value, 'int, double ou String');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw TypeConversionError(fieldName, value, 'número');
    }
  }

  /// Converte boolean opcional
  static bool? parseOptionalBool(dynamic value, [String fieldName = 'bool']) {
    if (value == null) return null;

    try {
      if (value is bool) return value;
      if (value is String) {
        final lowerValue = value.toLowerCase();
        if (lowerValue == 'true' || lowerValue == '1') return true;
        if (lowerValue == 'false' || lowerValue == '0') return false;
      }
      if (value is int) return value != 0;

      throw TypeConversionError(fieldName, value, 'bool, String ou int');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw TypeConversionError(fieldName, value, 'boolean');
    }
  }

  /// Converte boolean obrigatório
  static bool parseRequiredBool(dynamic value, [String fieldName = 'bool']) {
    if (value == null) {
      throw RequiredFieldError(fieldName, value);
    }

    try {
      if (value is bool) return value;
      if (value is String) {
        final lowerValue = value.toLowerCase();
        if (lowerValue == 'true' || lowerValue == '1') return true;
        if (lowerValue == 'false' || lowerValue == '0') return false;
      }
      if (value is int) return value != 0;

      throw TypeConversionError(fieldName, value, 'bool, String ou int');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw TypeConversionError(fieldName, value, 'boolean');
    }
  }

  /// Converte double opcional
  static double? parseOptionalDouble(dynamic value,
      [String fieldName = 'double']) {
    if (value == null) return null;

    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);

      throw TypeConversionError(fieldName, value, 'double, int ou String');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw TypeConversionError(fieldName, value, 'número');
    }
  }

  /// Converte double obrigatório
  static double parseRequiredDouble(dynamic value,
      [String fieldName = 'double']) {
    if (value == null) {
      throw RequiredFieldError(fieldName, value);
    }

    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);

      throw TypeConversionError(fieldName, value, 'double, int ou String');
    } catch (e) {
      if (e is DtoError) rethrow;
      throw TypeConversionError(fieldName, value, 'número');
    }
  }

  /// Obtém valor com fallback para diferentes chaves
  static T? getValueWithFallback<T>(
      Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key] as T?;
      }
    }
    return null;
  }

  /// Obtém string com fallback para diferentes chaves
  static String getStringWithFallback(
      Map<String, dynamic> json, List<String> keys,
      {String defaultValue = ''}) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key].toString();
      }
    }
    return defaultValue;
  }
}
