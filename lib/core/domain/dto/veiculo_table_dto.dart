import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/base_table_dto.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class VeiculoTableDto extends BaseTableDto {
  final String remoteId;
  final String placa;
  final String modelo;
  final int ano;
  final int tipoVeiculoId;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;

  VeiculoTableDto({
    required super.id,
    required this.remoteId,
    required this.placa,
    required this.modelo,
    required this.ano,
    required this.tipoVeiculoId,
    required super.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory VeiculoTableDto.fromEntity(VeiculoTableData entity) {
    return VeiculoTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      placa: entity.placa,
      modelo: entity.modelo,
      ano: entity.ano,
      tipoVeiculoId: entity.tipoVeiculoId,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      updatedAt: entity.updatedAt,
      updatedBy: entity.updatedBy,
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
    );
  }

  @override
  VeiculoTableCompanion toCompanion() {
    return VeiculoTableCompanion(
      remoteId: Value(remoteId),
      placa: Value(placa),
      modelo: Value(modelo),
      ano: Value(ano),
      tipoVeiculoId: Value(tipoVeiculoId),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: Value(deletedAt),
      deletedBy: Value(deletedBy),
    );
  }

  @override
  VeiculoTableData toEntity() {
    return VeiculoTableData(
      id: int.parse(id),
      remoteId: remoteId,
      placa: placa,
      modelo: modelo,
      ano: ano,
      tipoVeiculoId: tipoVeiculoId,
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }

  factory VeiculoTableDto.fromJson(Map<String, dynamic> json) {
    return BaseTableDto.fromJson(json, (json) {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      final remoteId = BaseDto.validateRequiredString(
          BaseDto.getStringWithFallback(json, ['remoteId', 'remote_id']),
          'remoteId');
      final placa = BaseDto.validateRequiredString(json['placa'], 'placa');
      final modelo = BaseDto.validateRequiredString(json['modelo'], 'modelo');
      final ano = BaseDto.parseRequiredInt(json['ano'], 'ano');
      final tipoVeiculoId = BaseDto.parseRequiredInt(
          BaseDto.getValueWithFallback(json, ['tipoVeiculoId', 'tipo_veiculo_id']),
          'tipoVeiculoId');

      // Campos opcionais
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

      return VeiculoTableDto(
        id: id,
        remoteId: remoteId,
        placa: placa,
        modelo: modelo,
        ano: ano,
        tipoVeiculoId: tipoVeiculoId,
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
      'placa': placa,
      'modelo': modelo,
      'ano': ano,
      'tipoVeiculoId': tipoVeiculoId,
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
    
    // Validação da placa
    BaseDto.validateStringLength(placa, 'placa', minLength: 7, maxLength: 8);
    
    // Validação do modelo
    BaseDto.validateStringLength(modelo, 'modelo', minLength: 2, maxLength: 100);
    
    // Validação do ano
    final currentYear = DateTime.now().year;
    if (ano < 1900 || ano > currentYear + 1) {
      throw DtoError('Ano deve estar entre 1900 e ${currentYear + 1}', 
          field: 'ano', value: ano);
    }
    
    // Validação do tipoVeiculoId
    if (tipoVeiculoId <= 0) {
      throw DtoError('ID do tipo de veículo deve ser maior que zero', 
          field: 'tipoVeiculoId', value: tipoVeiculoId);
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
