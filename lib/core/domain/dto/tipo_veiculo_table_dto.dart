import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/base_table_dto.dart';

class TipoVeiculoTableDto extends BaseTableDto {
  final String remoteId;
  final String nome;
  final String? descricao;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;

  TipoVeiculoTableDto({
    required super.id,
    required this.remoteId,
    required this.nome,
    this.descricao,
    required super.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory TipoVeiculoTableDto.fromEntity(TipoVeiculoTableData entity) {
    return TipoVeiculoTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      nome: entity.nome,
      descricao: entity.descricao,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      updatedAt: entity.updatedAt,
      updatedBy: entity.updatedBy,
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
    );
  }

  @override
  TipoVeiculoTableCompanion toCompanion() {
    return TipoVeiculoTableCompanion(
      remoteId: Value(remoteId),
      nome: Value(nome),
      descricao: Value(descricao),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: Value(deletedAt),
      deletedBy: Value(deletedBy),
    );
  }

  @override
  TipoVeiculoTableData toEntity() {
    return TipoVeiculoTableData(
      id: int.parse(id),
      remoteId: remoteId,
      nome: nome,
      descricao: descricao,
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }

  factory TipoVeiculoTableDto.fromJson(Map<String, dynamic> json) {
    return BaseTableDto.fromJson(json, (json) {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      final remoteId = BaseDto.validateRequiredString(
          BaseDto.getStringWithFallback(json, ['remoteId', 'remote_id']),
          'remoteId');
      final nome = BaseDto.validateRequiredString(json['nome'], 'nome');

      // Campos opcionais
      final descricao = json['descricao']?.toString();
      final createdBy = json['createdBy']?.toString();
      final updatedBy = json['updatedBy']?.toString();
      final deletedBy = json['deletedBy']?.toString();

      // Tratamento de datas
      final createdAt = BaseDto.parseRequiredDateTime(
          BaseDto.getValueWithFallback(json, ['createdAt', 'created_at']) ??
              DateTime.now(),
          'createdAt');

      final updatedAt = BaseDto.parseOptionalDateTime(
          BaseDto.getValueWithFallback(json, ['updatedAt', 'updated_at']),
          'updatedAt');

      final deletedAt = BaseDto.parseOptionalDateTime(
          BaseDto.getValueWithFallback(json, ['deletedAt', 'deleted_at']),
          'deletedAt');

      return TipoVeiculoTableDto(
        id: id,
        remoteId: remoteId,
        nome: nome,
        descricao: descricao?.isEmpty == true ? null : descricao,
        createdAt: createdAt,
        createdBy: createdBy?.isEmpty == true ? null : createdBy,
        updatedAt: updatedAt,
        updatedBy: updatedBy?.isEmpty == true ? null : updatedBy,
        deletedAt: deletedAt,
        deletedBy: deletedBy?.isEmpty == true ? null : deletedBy,
      );
    });
  }

  @override
  Map<String, dynamic> toSpecificJson() {
    return {
      'remoteId': remoteId,
      'nome': nome,
      'descricao': descricao,
      'createdBy': createdBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  @override
  void validateSpecific() {
    // Validação do remoteId
    BaseDto.validateStringLength(remoteId, 'remoteId', minLength: 1, maxLength: 100);
    
    // Validação do nome
    BaseDto.validateStringLength(nome, 'nome', minLength: 2, maxLength: 100);
    
    // Validação da descrição (opcional)
    if (descricao != null && descricao!.isNotEmpty) {
      BaseDto.validateStringLength(descricao!, 'descricao', maxLength: 255);
    }
    
    // Validação dos campos de auditoria
    if (createdBy != null && createdBy!.isNotEmpty) {
      BaseDto.validateStringLength(createdBy!, 'createdBy', maxLength: 100);
    }
    
    if (updatedBy != null && updatedBy!.isNotEmpty) {
      BaseDto.validateStringLength(updatedBy!, 'updatedBy', maxLength: 100);
    }
    
    if (deletedBy != null && deletedBy!.isNotEmpty) {
      BaseDto.validateStringLength(deletedBy!, 'deletedBy', maxLength: 100);
    }
  }
}
