import 'package:nexa_app/core/domain/dto/base/base_dto.dart';
import 'package:nexa_app/core/domain/dto/base/base_table_dto.dart';

class LoginResponseDto extends BaseTableDto {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
  final DateTime refreshTokenExpiresAt;
  final String uuid;
  final String nome;
  final String matricula;

  LoginResponseDto({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.refreshTokenExpiresAt,
    required this.uuid,
    required this.nome,
    required this.matricula,
    required super.id,
    required super.createdAt,
  });

  @override
  toCompanion() {
    throw UnimplementedError();
  }

  @override
  toEntity() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toSpecificJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'refreshTokenExpiresAt': refreshTokenExpiresAt.toIso8601String(),
      'uuid': uuid,
      'nome': nome,
      'matricula': matricula,
    };
  }

  @override
  void validateSpecific() {
    BaseDto.validateRequiredString(token, 'token');
    BaseDto.validateRequiredString(refreshToken, 'refreshToken');
    BaseDto.validateRequiredString(uuid, 'uuid');
    BaseDto.validateRequiredString(nome, 'nome');
    BaseDto.validateRequiredString(matricula, 'matricula');
    validateNotFutureDate(expiresAt, 'expiresAt');
    validateNotFutureDate(refreshTokenExpiresAt, 'refreshTokenExpiresAt');
  }

  static Future<LoginResponseDto> fromJson(data) {
    return BaseTableDto.fromJson(data, (json) {
      return LoginResponseDto(
        token: json['token'],
        refreshToken: json['refreshToken'],
        expiresAt: json['expiresAt'],
        refreshTokenExpiresAt: json['refreshTokenExpiresAt'],
        uuid: json['uuid'],
        nome: json['nome'],
        matricula: json['matricula'],
        id: BaseDto.validateRequiredString(json['id'], 'id'),
        createdAt: json['createdAt'],
      );
    });
  }
}
