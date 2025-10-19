import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/models/base/base_dto.dart';
import 'package:nexa_app/data/models/base/drift_dto_mixin.dart';
import 'package:nexa_app/data/models/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class EquipeTableDto extends BaseDto with DriftDtoMixin, TableValidationMixin {
  final String id;
  final int remoteId;
  final String nome;
  final String? descricao;
  final int tipoEquipeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;

  EquipeTableDto({
    required this.id,
    required this.remoteId,
    required this.nome,
    this.descricao,
    required this.tipoEquipeId,
    required this.createdAt,
    required this.updatedAt,
    required this.sincronizado,
  });

  factory EquipeTableDto.fromEntity(EquipeTableData entity) {
    return EquipeTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      nome: entity.nome,
      descricao: entity.descricao,
      tipoEquipeId: entity.tipoEquipeId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      sincronizado: entity.sincronizado,
    );
  }

  @override
  EquipeTableCompanion toCompanion() {
    return EquipeTableCompanion(
      remoteId: Value(remoteId),
      nome: Value(nome),
      descricao: Value(descricao),
      tipoEquipeId: Value(tipoEquipeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
    );
  }

  @override
  EquipeTableData toEntity() {
    return EquipeTableData(
      id: int.parse(id),
      remoteId: remoteId,
      nome: nome,
      descricao: descricao,
      tipoEquipeId: tipoEquipeId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sincronizado: sincronizado,
    );
  }

  factory EquipeTableDto.fromJson(Map<String, dynamic> json) {
    try {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      // Mapeia o 'id' da API para 'remoteId' no DTO
      final remoteId = BaseDto.parseRequiredInt(
          BaseDto.getValueWithFallback(json, ['id', 'remoteId', 'remote_id']),
          'remoteId');
      final nome = BaseDto.validateRequiredString(json['nome'], 'nome');
      final tipoEquipeId = BaseDto.parseRequiredInt(
          BaseDto.getValueWithFallback(json, ['tipoEquipeId', 'tipo_equipe_id']),
          'tipoEquipeId');

      // Campos opcionais
      final descricao = json['descricao']?.toString();

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

      return EquipeTableDto(
        id: id,
        remoteId: remoteId,
        nome: nome,
        descricao: descricao?.isEmpty == true ? null : descricao,
        tipoEquipeId: tipoEquipeId,
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
      'descricao': descricao,
      'tipoEquipeId': tipoEquipeId,
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
    
    // Validação da descrição (se fornecida)
    final desc = descricao;
    if (desc != null && desc.isNotEmpty) {
      BaseDto.validateStringLength(desc, 'descricao', maxLength: 255);
    }
    
    // Validação do tipoEquipeId
    if (tipoEquipeId <= 0) {
      throw DtoError('ID do tipo de equipe deve ser maior que zero', 
          field: 'tipoEquipeId', value: tipoEquipeId);
    }
  }

  EquipeTableDto copyWith({
    String? id,
    int? remoteId,
    String? nome,
    String? descricao,
    int? tipoEquipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? sincronizado,
  }) {
    return EquipeTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipoEquipeId: tipoEquipeId ?? this.tipoEquipeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }
}
