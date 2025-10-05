import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/drift_dto_mixin.dart';
import 'package:nexa_app/core/domain/dto/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

/// DTO para ChecklistPreenchidoTable
class ChecklistPreenchidoTableDto extends BaseDto
    with DriftDtoMixin, TableValidationMixin {
  final int turnoId;
  final int checklistModeloId;
  final int? eletricistaRemoteId;
  final double? latitude;
  final double? longitude;
  final DateTime dataPreenchimento;

  final String id;

  ChecklistPreenchidoTableDto({
    required this.id,
    required this.turnoId,
    required this.checklistModeloId,
    this.eletricistaRemoteId,
    this.latitude,
    this.longitude,
    required this.dataPreenchimento,
  });

  factory ChecklistPreenchidoTableDto.fromEntity(
      ChecklistPreenchidoTableData entity) {
    return ChecklistPreenchidoTableDto(
      id: entity.id.toString(),
      turnoId: entity.turnoId,
      checklistModeloId: entity.checklistModeloId,
      eletricistaRemoteId: entity.eletricistaRemoteId,
      latitude: entity.latitude,
      longitude: entity.longitude,
      dataPreenchimento: entity.dataPreenchimento,
    );
  }

  @override
  ChecklistPreenchidoTableCompanion toCompanion() {
    return ChecklistPreenchidoTableCompanion(
      turnoId: Value(turnoId),
      checklistModeloId: Value(checklistModeloId),
      eletricistaRemoteId: Value(eletricistaRemoteId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      dataPreenchimento: Value(dataPreenchimento),
    );
  }

  @override
  ChecklistPreenchidoTableData toEntity() {
    return ChecklistPreenchidoTableData(
      id: int.parse(id),
      turnoId: turnoId,
      checklistModeloId: checklistModeloId,
      eletricistaRemoteId: eletricistaRemoteId,
      latitude: latitude,
      longitude: longitude,
      dataPreenchimento: dataPreenchimento,
    );
  }

  factory ChecklistPreenchidoTableDto.fromJson(Map<String, dynamic> json) {
    try {
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      final turnoId = BaseDto.parseRequiredInt(json['turnoId'], 'turnoId');
      final checklistModeloId = BaseDto.parseRequiredInt(
          json['checklistModeloId'], 'checklistModeloId');
      final eletricistaRemoteId = json['eletricistaRemoteId'] == null
          ? null
          : int.tryParse(json['eletricistaRemoteId'].toString());
      final latitude = json['latitude']?.toDouble();
      final longitude = json['longitude']?.toDouble();
      final dataPreenchimento = DateTime.parse(json['dataPreenchimento']);

      return ChecklistPreenchidoTableDto(
        id: id,
        turnoId: turnoId,
        checklistModeloId: checklistModeloId,
        eletricistaRemoteId: eletricistaRemoteId,
        latitude: latitude,
        longitude: longitude,
        dataPreenchimento: dataPreenchimento,
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

      json.addAll(toSpecificJson());

      return json;
    } catch (e) {
      throw DtoError('Erro ao converter DTO para JSON: $e', context: 'toJson');
    }
  }

  Map<String, dynamic> toSpecificJson() {
    return {
      'turnoId': turnoId,
      'checklistModeloId': checklistModeloId,
      'eletricistaRemoteId': eletricistaRemoteId,
      'latitude': latitude,
      'longitude': longitude,
      'dataPreenchimento': dataPreenchimento.toIso8601String(),
    };
  }

  void validateSpecific() {
    // Validação básica dos campos obrigatórios
    if (turnoId <= 0) {
      throw DtoError('turnoId deve ser maior que zero');
    }

    if (checklistModeloId <= 0) {
      throw DtoError('checklistModeloId deve ser maior que zero');
    }
  }
}
