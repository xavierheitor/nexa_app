import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/drift_dto_mixin.dart';
import 'package:nexa_app/core/domain/dto/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class VeiculoTableDto extends BaseDto with DriftDtoMixin, TableValidationMixin {
  final String id;
  final String remoteId;
  final String placa;
  final int tipoVeiculoId;

  VeiculoTableDto({
    required this.id,
    required this.remoteId,
    required this.placa,
    required this.tipoVeiculoId,
  });

  factory VeiculoTableDto.fromEntity(VeiculoTableData entity) {
    return VeiculoTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      placa: entity.placa,
      tipoVeiculoId: entity.tipoVeiculoId,
    );
  }

  @override
  VeiculoTableCompanion toCompanion() {
    return VeiculoTableCompanion(
      remoteId: Value(remoteId),
      placa: Value(placa),
      tipoVeiculoId: Value(tipoVeiculoId),
    );
  }

  @override
  VeiculoTableData toEntity() {
    return VeiculoTableData(
      id: int.parse(id),
      remoteId: remoteId,
      placa: placa,
      tipoVeiculoId: tipoVeiculoId,
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
        remoteId: remoteId,
        placa: placa,
        tipoVeiculoId: tipoVeiculoId,
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
    BaseDto.validateStringLength(remoteId, 'remoteId', minLength: 1, maxLength: 100);
    
    // Validação da placa
    BaseDto.validateStringLength(placa, 'placa', minLength: 7, maxLength: 8);
    
    // Validação do tipoVeiculoId
    if (tipoVeiculoId <= 0) {
      throw DtoError('ID do tipo de veículo deve ser maior que zero', 
          field: 'tipoVeiculoId', value: tipoVeiculoId);
    }
  }
}
