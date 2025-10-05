import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/drift_dto_mixin.dart';
import 'package:nexa_app/core/domain/dto/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

/// DTO para ChecklistRespostaTable
class ChecklistRespostaTableDto extends BaseDto
    with DriftDtoMixin, TableValidationMixin {
  final int checklistPreenchidoId;
  final int perguntaId;
  final int opcaoRespostaId;
  final DateTime dataResposta;

  final String id;

  ChecklistRespostaTableDto({
    required this.id,
    required this.checklistPreenchidoId,
    required this.perguntaId,
    required this.opcaoRespostaId,
    required this.dataResposta,
  });

  factory ChecklistRespostaTableDto.fromEntity(ChecklistRespostaTableData entity) {
    return ChecklistRespostaTableDto(
      id: entity.id.toString(),
      checklistPreenchidoId: entity.checklistPreenchidoId,
      perguntaId: entity.perguntaId,
      opcaoRespostaId: entity.opcaoRespostaId,
      dataResposta: entity.dataResposta,
    );
  }

  @override
  ChecklistRespostaTableCompanion toCompanion() {
    return ChecklistRespostaTableCompanion(
      checklistPreenchidoId: Value(checklistPreenchidoId),
      perguntaId: Value(perguntaId),
      opcaoRespostaId: Value(opcaoRespostaId),
      dataResposta: Value(dataResposta),
    );
  }

  @override
  ChecklistRespostaTableData toEntity() {
    return ChecklistRespostaTableData(
      id: int.parse(id),
      checklistPreenchidoId: checklistPreenchidoId,
      perguntaId: perguntaId,
      opcaoRespostaId: opcaoRespostaId,
      dataResposta: dataResposta,
    );
  }

  factory ChecklistRespostaTableDto.fromJson(Map<String, dynamic> json) {
    try {
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      final checklistPreenchidoId = BaseDto.parseRequiredInt(json['checklistPreenchidoId'], 'checklistPreenchidoId');
      final perguntaId = BaseDto.parseRequiredInt(json['perguntaId'], 'perguntaId');
      final opcaoRespostaId = BaseDto.parseRequiredInt(json['opcaoRespostaId'], 'opcaoRespostaId');
      final dataResposta = DateTime.parse(json['dataResposta']);

      return ChecklistRespostaTableDto(
        id: id,
        checklistPreenchidoId: checklistPreenchidoId,
        perguntaId: perguntaId,
        opcaoRespostaId: opcaoRespostaId,
        dataResposta: dataResposta,
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
      'checklistPreenchidoId': checklistPreenchidoId,
      'perguntaId': perguntaId,
      'opcaoRespostaId': opcaoRespostaId,
      'dataResposta': dataResposta.toIso8601String(),
    };
  }

  void validateSpecific() {
    // Validação básica dos campos obrigatórios
    if (checklistPreenchidoId <= 0) {
      throw DtoError('checklistPreenchidoId deve ser maior que zero');
    }
    
    if (perguntaId <= 0) {
      throw DtoError('perguntaId deve ser maior que zero');
    }
    
    if (opcaoRespostaId <= 0) {
      throw DtoError('opcaoRespostaId deve ser maior que zero');
    }
  }
}
