import 'package:nexa_app/core/domain/dto/usuario_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/usuario_repo.dart';

class AuthService {
  final UsuarioRepo usuarioRepo;

  AuthService({required this.usuarioRepo});

  Future<UsuarioTableDto> login(String matricula, String senha) async {
    throw UnimplementedError();
  }

  Future<bool> logout() async {
    throw UnimplementedError();
  }

  Future<UsuarioTableDto> refreshToken(String refreshToken) async {
    throw UnimplementedError();
  }

  Future<List<UsuarioTableDto>> getUsuarios() async {
    throw UnimplementedError();
  }
}