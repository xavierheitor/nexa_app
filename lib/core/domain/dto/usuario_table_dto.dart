import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/base_table_dto.dart';

class UsuarioTableDto extends BaseTableDto {
  final String remoteId;
  final String nome;
  final String matricula;
  final String? token;
  final String? refreshToken;
  final DateTime? ultimoLogin;

  UsuarioTableDto({
    required super.id,
    required this.remoteId,
    required this.nome,
    required this.matricula,
    this.token,
    this.refreshToken,
    this.ultimoLogin,
    required super.createdAt,
  });

  factory UsuarioTableDto.fromEntity(UsuarioTableData entity) {
    return UsuarioTableDto(
      id: entity.id.toString(),
      remoteId: entity.remoteId,
      nome: entity.nome,
      matricula: entity.matricula,
      token: entity.token,
      refreshToken: entity.refreshToken,
      ultimoLogin: entity.ultimoLogin,
      createdAt: entity.createdAt,
    );
  }

  @override
  UsuarioTableCompanion toCompanion() {
    return UsuarioTableCompanion(
      remoteId: Value(remoteId),
      nome: Value(nome),
      matricula: Value(matricula),
      token: Value(token),
      refreshToken: Value(refreshToken),
      ultimoLogin: Value(ultimoLogin),
    );
  }

  @override
  UsuarioTableData toEntity() {
    return UsuarioTableData(
      id: int.parse(id),
      remoteId: remoteId,
      nome: nome,
      matricula: matricula,
      token: token,
      refreshToken: refreshToken,
      ultimoLogin: ultimoLogin,
      createdAt: createdAt,
    );
  }

  factory UsuarioTableDto.fromJson(Map<String, dynamic> json) {
    return BaseTableDto.fromJson(json, (json) {
      // Validação de campos obrigatórios
      final id = BaseDto.validateRequiredString(json['id'], 'id');
      final remoteId = BaseDto.validateRequiredString(
          BaseDto.getStringWithFallback(json, ['remoteId', 'remote_id']),
          'remoteId');
      final nome = BaseDto.validateRequiredString(json['nome'], 'nome');
      final matricula =
          BaseDto.validateRequiredString(json['matricula'], 'matricula');

      // Campos opcionais
      final token = json['token']?.toString();
      final refreshToken = BaseDto.getStringWithFallback(
          json, ['refreshToken', 'refresh_token']);

      // Tratamento de datas
      final ultimoLogin = BaseDto.parseOptionalDateTime(
          BaseDto.getValueWithFallback(json, ['ultimoLogin', 'ultimo_login']),
          'ultimoLogin');

      final createdAt = BaseDto.parseRequiredDateTime(
          BaseDto.getValueWithFallback(json, ['createdAt', 'created_at']) ??
              DateTime.now(),
          'createdAt');

      return UsuarioTableDto(
        id: id,
        remoteId: remoteId,
        nome: nome,
        matricula: matricula,
        token: token,
        refreshToken: refreshToken.isEmpty ? null : refreshToken,
        ultimoLogin: ultimoLogin,
        createdAt: createdAt,
      );
    });
  }

  @override
  Map<String, dynamic> toSpecificJson() {
    return {
      'remoteId': remoteId,
      'nome': nome,
      'matricula': matricula,
      'token': token,
      'refreshToken': refreshToken,
      'ultimoLogin': ultimoLogin?.toIso8601String(),
    };
  }

  @override
  void validateSpecific() {
    validateRemoteId(remoteId);
    validateNome(nome);
    validateMatricula(matricula);
    validateToken(token);

    if (refreshToken != null && refreshToken!.isNotEmpty) {
      validateToken(refreshToken);
    }
  }
}
