import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/models/base/base_dto.dart';
import 'package:nexa_app/data/models/base/drift_dto_mixin.dart';
import 'package:nexa_app/data/models/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class TipoEquipeTableDto extends BaseDto with DriftDtoMixin, TableValidationMixin {
  final String id;
  final int remoteId;
  final String nome;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;

  TipoEquipeTableDto({
    required this.id,
    required this.remoteId,
    required this.nome,
    required this.createdAt,
    required this.updatedAt,
    required this.sincronizado,
  });

  factory TipoEquipeTableDto.fromEntity(TipoEquipeTableData entity) {
    return TipoEquipeTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      nome: entity.nome,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      sincronizado: entity.sincronizado,
    );
  }

  @override
  TipoEquipeTableCompanion toCompanion() {
    return TipoEquipeTableCompanion(
      remoteId: Value(remoteId),
      nome: Value(nome),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
    );
  }

  @override
  TipoEquipeTableData toEntity() {
    return TipoEquipeTableData(
      id: int.parse(id),
      remoteId: remoteId,
      nome: nome,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sincronizado: sincronizado,
    );
  }

  factory TipoEquipeTableDto.fromJson(Map<String, dynamic> json) {
    try {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      // Mapeia o 'id' da API para 'remoteId' no DTO
      final remoteId = BaseDto.parseRequiredInt(
          BaseDto.getValueWithFallback(json, ['id', 'remoteId', 'remote_id']),
          'remoteId');
      final nome = BaseDto.validateRequiredString(json['nome'], 'nome');

      // Campos de auditoria
      final createdAt = BaseDto.parseRequiredDateTime(
          BaseDto.getValueWithFallback(json, ['createdAt', 'created_at']) ??
              DateTime.now(),
          'createdAt');

      final updatedAt = BaseDto.parseRequiredDateTime(
          BaseDto.getValueWithFallback(json, ['updatedAt', 'updated_at']) ??
              DateTime.now(),
          'updatedAt');

      final sincronizado = BaseDto.parseRequiredBool(
          BaseDto.getValueWithFallback(json, ['sincronizado', 'synchronized']) ??
              false,
          'sincronizado');

      return TipoEquipeTableDto(
        id: id,
        remoteId: remoteId,
        nome: nome,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sincronizado: sincronizado,
      );
    } catch (e) {
      if (e is DtoError) rethrow;
      throw DtoError('Erro ao processar JSON do DTO: $e');
    }
  }

  @override
  void validate() {
    validateRequiredId(id);
    validateSpecific();
  }

  @override
  Map<String, dynamic> toJson() {
    try {
      final json = <String, dynamic>{
        'id': id,
      };

      // Adiciona campos específicos da subclasse
      json.addAll(toSpecificJson());

      return json;
    } catch (e) {
      throw DtoError('Erro ao converter DTO para JSON: $e', context: 'toJson');
    }
  }

  Map<String, dynamic> toSpecificJson() {
    return {
      'remoteId': remoteId,
      'nome': nome,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sincronizado': sincronizado,
    };
  }

  void validateSpecific() {
    // Validação do remoteId
    if (remoteId <= 0) {
      throw DtoError('ID remoto deve ser maior que zero', 
          field: 'remoteId', value: remoteId);
    }
    
    // Validação do nome
    BaseDto.validateStringLength(nome, 'nome', minLength: 2, maxLength: 100);
  }

  TipoEquipeTableDto copyWith({
    String? id,
    int? remoteId,
    String? nome,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? sincronizado,
  }) {
    return TipoEquipeTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }
}
