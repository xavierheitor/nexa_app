import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/drift_dto_mixin.dart';
import 'package:nexa_app/core/domain/dto/base/table_validation_mixin.dart';
import 'package:nexa_app/core/utils/errors/app_exception.dart';

class TipoVeiculoTableDto extends BaseDto
    with DriftDtoMixin, TableValidationMixin {
  final String id;
  final String remoteId;
  final String nome;
  final String? descricao;

  TipoVeiculoTableDto({
    required this.id,
    required this.remoteId,
    required this.nome,
    this.descricao,
  });

  factory TipoVeiculoTableDto.fromEntity(TipoVeiculoTableData entity) {
    return TipoVeiculoTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      nome: entity.nome,
      descricao: entity.descricao,
    );
  }

  @override
  TipoVeiculoTableCompanion toCompanion() {
    return TipoVeiculoTableCompanion(
      remoteId: Value(remoteId),
      nome: Value(nome),
      descricao: Value(descricao),
    );
  }

  @override
  TipoVeiculoTableData toEntity() {
    return TipoVeiculoTableData(
      id: int.parse(id),
      remoteId: remoteId,
      nome: nome,
      descricao: descricao,
    );
  }

  factory TipoVeiculoTableDto.fromJson(Map<String, dynamic> json) {
    try {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      final remoteId = BaseDto.validateRequiredString(
          BaseDto.getStringWithFallback(json, ['remoteId', 'remote_id']),
          'remoteId');
      final nome = BaseDto.validateRequiredString(json['nome'], 'nome');

      // Campos opcionais
      final descricao = json['descricao']?.toString();

      return TipoVeiculoTableDto(
        id: id,
        remoteId: remoteId,
        nome: nome,
        descricao: descricao?.isEmpty == true ? null : descricao,
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
    };
  }

  void validateSpecific() {
    // Validação do remoteId
    BaseDto.validateStringLength(remoteId, 'remoteId',
        minLength: 1, maxLength: 100);

    // Validação do nome
    BaseDto.validateStringLength(nome, 'nome', minLength: 2, maxLength: 100);

    // Validação da descrição (opcional)
    if (descricao != null && descricao!.isNotEmpty) {
      BaseDto.validateStringLength(descricao!, 'descricao', maxLength: 255);
    }
  }
}
