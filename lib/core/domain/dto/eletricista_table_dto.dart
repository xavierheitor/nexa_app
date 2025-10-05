import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/drift_dto_mixin.dart';
import 'package:nexa_app/core/domain/dto/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class EletricistaTableDto extends BaseDto with DriftDtoMixin, TableValidationMixin {
  final String id;
  final String remoteId;
  final String nome;
  final String matricula;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool sincronizado;

  EletricistaTableDto({
    required this.id,
    required this.remoteId,
    required this.nome,
    required this.matricula,
    required this.createdAt,
    required this.updatedAt,
    required this.sincronizado,
  });

  factory EletricistaTableDto.fromEntity(EletricistaTableData entity) {
    return EletricistaTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId.toString(),
      nome: entity.nome,
      matricula: entity.matricula,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      sincronizado: entity.sincronizado,
    );
  }

  @override
  EletricistaTableCompanion toCompanion() {
    return EletricistaTableCompanion(
      remoteId: Value(int.parse(remoteId)),
      nome: Value(nome),
      matricula: Value(matricula),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sincronizado: Value(sincronizado),
    );
  }

  @override
  EletricistaTableData toEntity() {
    return EletricistaTableData(
      id: int.parse(id),
      remoteId: int.parse(remoteId),
      nome: nome,
      matricula: matricula,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sincronizado: sincronizado,
    );
  }

  factory EletricistaTableDto.fromJson(Map<String, dynamic> json) {
    try {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      // Mapeia o 'id' da API para 'remoteId' no DTO
      final remoteId = BaseDto.validateRequiredString(
          BaseDto.getStringWithFallback(json, ['id', 'remoteId', 'remote_id']),
          'remoteId');
      final nome = BaseDto.validateRequiredString(json['nome'], 'nome');
      final matricula = BaseDto.validateRequiredString(json['matricula'], 'matricula');

      return EletricistaTableDto(
        id: id,
        remoteId: remoteId,
        nome: nome,
        matricula: matricula,
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
      'nome': nome,
      'matricula': matricula,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sincronizado': sincronizado,
    };
  }

  void validateSpecific() {
    // Validação do remoteId
    BaseDto.validateStringLength(remoteId, 'remoteId', minLength: 1, maxLength: 100);
    
    // Validação do nome
    BaseDto.validateStringLength(nome, 'nome', minLength: 2, maxLength: 100);
    
    // Validação da matrícula
    BaseDto.validateStringLength(matricula, 'matricula', minLength: 1, maxLength: 50);
  }
}
