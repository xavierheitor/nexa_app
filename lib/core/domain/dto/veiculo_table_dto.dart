import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/drift_dto_mixin.dart';
import 'package:nexa_app/core/domain/dto/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class VeiculoTableDto extends BaseDto with DriftDtoMixin, TableValidationMixin {
  final String placa;
  final int tipoVeiculoId;

  final String id;
  final int remoteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;

  VeiculoTableDto({
    required this.id,
    required this.remoteId,
    required this.placa,
    required this.tipoVeiculoId,
    required this.createdAt,
    required this.updatedAt,
    required this.sincronizado,
  });

  factory VeiculoTableDto.fromEntity(VeiculoTableData entity) {
    return VeiculoTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      placa: entity.placa,
      tipoVeiculoId: entity.tipoVeiculoId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      sincronizado: entity.sincronizado,
    );
  }

  @override
  VeiculoTableCompanion toCompanion() {
    return VeiculoTableCompanion(
      remoteId: Value(remoteId),
      placa: Value(placa),
      tipoVeiculoId: Value(tipoVeiculoId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
    );
  }

  @override
  VeiculoTableData toEntity() {
    return VeiculoTableData(
      id: int.parse(id),
      remoteId: remoteId,
      placa: placa,
      tipoVeiculoId: tipoVeiculoId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sincronizado: sincronizado,
    );
  }

  factory VeiculoTableDto.fromJson(Map<String, dynamic> json) {
    try {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      // Mapeia o 'id' da API para 'remoteId' no DTO
      final remoteId = BaseDto.validateRequiredString(
          BaseDto.getStringWithFallback(json, ['id', 'remoteId', 'remote_id']),
          'remoteId');
      final placa = BaseDto.validateRequiredString(json['placa'], 'placa');
      final tipoVeiculoId = BaseDto.parseRequiredInt(
          BaseDto.getValueWithFallback(json, ['tipoVeiculoId', 'tipo_veiculo_id']),
          'tipoVeiculoId');

      return VeiculoTableDto(
        id: id,
        remoteId: int.parse(remoteId),
        placa: placa,
        tipoVeiculoId: tipoVeiculoId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
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
      'placa': placa,
      'tipoVeiculoId': tipoVeiculoId,
    };
  }

  void validateSpecific() {
    // Validação do remoteId
    BaseDto.validateStringLength(remoteId.toString(), 'remoteId',
        minLength: 1, maxLength: 100);
    
    // Validação da placa
    BaseDto.validateStringLength(placa, 'placa', minLength: 7, maxLength: 8);
    
    // Validação do tipoVeiculoId
    if (tipoVeiculoId <= 0) {
      throw DtoError('ID do tipo de veículo deve ser maior que zero', 
          field: 'tipoVeiculoId', value: tipoVeiculoId);
    }
  }
}
