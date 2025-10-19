import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/usuario_table.dart';

part 'usuario_dao.g.dart';

@DriftAccessor(tables: [UsuarioTable])
class UsuarioDao extends DatabaseAccessor<AppDatabase> with _$UsuarioDaoMixin {
  UsuarioDao(super.db);

  Future<List<UsuarioTableData>> listar() async {
    return await select(usuarioTable).get();
  }

  Future<UsuarioTableData> buscarPorId(int id) async {
    return await (select(usuarioTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<UsuarioTableData> buscarPorMatricula(String matricula) async {
    return await (select(usuarioTable)
          ..where((t) => t.matricula.equals(matricula)))
        .getSingle();
  }

  Future<UsuarioTableData?> getUsuarioByMatricula(String matricula) async {
    try {
      return await (select(usuarioTable)
            ..where((t) => t.matricula.equals(matricula)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  Future<int> inserir(UsuarioTableCompanion usuario) async {
    final existente = await getUsuarioByMatricula(usuario.matricula.value);
    if (existente != null) {
      return await (update(usuarioTable)
            ..where((u) => u.matricula.equals(usuario.matricula.value)))
          .write(usuario);
    } else {
      return await into(usuarioTable).insert(usuario);
    }
  }

  Future<int> atualizar(UsuarioTableData usuario) async {
    return await (update(usuarioTable)
          ..where((t) => t.id.equals(usuario.id)))
        .write(UsuarioTableCompanion(
          nome: Value(usuario.nome),
          matricula: Value(usuario.matricula),
          token: Value(usuario.token),
          refreshToken: Value(usuario.refreshToken),
          ultimoLogin: Value(usuario.ultimoLogin),
        ));
  }

  Future<int> deletar(int id) async {
    return await (delete(usuarioTable)..where((t) => t.id.equals(id))).go();
  }

  /// Limpa todos os registros da tabela de usuários.
  Future<void> deletarTodos() async {
    await delete(usuarioTable).go();
  }
}
