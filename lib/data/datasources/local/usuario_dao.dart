import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/usuario_table.dart';
import 'package:nexa_app/core/database/base_dao.dart';

part 'usuario_dao.g.dart';

/// DAO para gerenciar operações da tabela UsuarioTable.
///
/// Estende [BaseDao] para herdar operações CRUD genéricas.
/// Mantém apenas métodos específicos de negócio relacionados a usuários.
///
/// **Nota**: Esta tabela não tem remote_id (é apenas local), por isso usa BaseDao em vez de SyncableDao.
@DriftAccessor(tables: [UsuarioTable])
class UsuarioDao extends BaseDao<UsuarioTable, UsuarioTableData>
    with _$UsuarioDaoMixin {
  UsuarioDao(super.db);

  @override
  TableInfo<UsuarioTable, UsuarioTableData> get table => db.usuarioTable;

  // ============================================================================
  // MÉTODOS ESPECÍFICOS DE USUÁRIO
  // ============================================================================

  /// Busca um usuário por matrícula.
  Future<UsuarioTableData> buscarPorMatricula(String matricula) async {
    return await (select(db.usuarioTable)
          ..where((t) => t.matricula.equals(matricula)))
        .getSingle();
  }

  /// Busca um usuário por matrícula (retorna null se não encontrar).
  Future<UsuarioTableData?> getUsuarioByMatricula(String matricula) async {
    try {
      return await (select(db.usuarioTable)
            ..where((t) => t.matricula.equals(matricula)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Insere ou atualiza um usuário baseado na matrícula.
  ///
  /// Se um usuário com a mesma matrícula já existir, atualiza os dados.
  /// Caso contrário, insere um novo registro.
  Future<int> inserirOuAtualizarPorMatricula(
      UsuarioTableCompanion usuario) async {
    final existente = await getUsuarioByMatricula(usuario.matricula.value);
    if (existente != null) {
      return await (update(db.usuarioTable)
            ..where((u) => u.matricula.equals(usuario.matricula.value)))
          .write(usuario);
    } else {
      return await into(db.usuarioTable).insert(usuario);
    }
  }

  /// Atualiza token e refreshToken de um usuário.
  Future<int> atualizarTokens({
    required int id,
    required String token,
    required String refreshToken,
  }) async {
    return await (update(db.usuarioTable)..where((t) => t.id.equals(id)))
        .write(UsuarioTableCompanion(
      token: Value(token),
      refreshToken: Value(refreshToken),
    ));
  }

  /// Atualiza último login de um usuário.
  Future<int> atualizarUltimoLogin(int id) async {
    return await (update(db.usuarioTable)..where((t) => t.id.equals(id)))
        .write(UsuarioTableCompanion(
      ultimoLogin: Value(DateTime.now()),
    ));
  }
}
