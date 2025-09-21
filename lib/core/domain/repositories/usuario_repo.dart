import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/daos/usuario_dao.dart';
import 'package:nexa_app/core/domain/dto/usuario_table_dto.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

class UsuarioRepo {
  final DioClient dio;
  final AppDatabase db;
  final UsuarioDao usuarioDao;

  UsuarioRepo({required this.dio, required this.db})
      : usuarioDao = db.usuarioDao;

  Future<List<UsuarioTableDto>> listar() async {
    final usuarios = await usuarioDao.listar();
    return usuarios
        .map((usuario) => UsuarioTableDto.fromEntity(usuario))
        .toList();
  }

  Future<UsuarioTableDto> buscarPorId(int id) async {
    final usuario = await usuarioDao.buscarPorId(id);
    return UsuarioTableDto.fromEntity(usuario);
  }

  Future<UsuarioTableDto> buscarPorMatricula(String matricula) async {
    final usuario = await usuarioDao.buscarPorMatricula(matricula);
    return UsuarioTableDto.fromEntity(usuario);
  }

  Future<UsuarioTableDto> inserir(UsuarioTableDto usuario) async {
    final id = await usuarioDao.inserir(usuario.toCompanion());
    final usuarioInserido = await usuarioDao.buscarPorId(id);
    return UsuarioTableDto.fromEntity(usuarioInserido);
  }

  Future<UsuarioTableDto> atualizar(UsuarioTableDto usuario) async {
    await usuarioDao.atualizar(usuario.toEntity());
    final usuarioAtualizado = await usuarioDao.buscarPorId(int.parse(usuario.id));
    return UsuarioTableDto.fromEntity(usuarioAtualizado);
  }

  Future<void> deletar(int id) async {
    await usuarioDao.deletar(id);
  }
}
