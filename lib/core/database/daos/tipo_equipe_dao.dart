import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/tipo_equipe_table.dart';

part 'tipo_equipe_dao.g.dart';

@DriftAccessor(tables: [TipoEquipeTable])
class TipoEquipeDao extends DatabaseAccessor<AppDatabase>
    with _$TipoEquipeDaoMixin {
  TipoEquipeDao(super.db);

  /// Lista todos os tipos de equipe
  Future<List<TipoEquipeTableData>> listar() async {
    return await select(tipoEquipeTable).get();
  }

  /// Busca um tipo de equipe por ID
  Future<TipoEquipeTableData> buscarPorId(int id) async {
    return await (select(tipoEquipeTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// Busca um tipo de equipe por ID (retorna null se não encontrar)
  Future<TipoEquipeTableData?> buscarPorIdOuNull(int id) async {
    try {
      return await (select(tipoEquipeTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca um tipo de equipe por remote ID
  Future<TipoEquipeTableData> buscarPorRemoteId(int remoteId) async {
    return await (select(tipoEquipeTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingle();
  }

  /// Busca um tipo de equipe por remote ID (retorna null se não encontrar)
  Future<TipoEquipeTableData?> buscarPorRemoteIdOuNull(int remoteId) async {
    try {
      return await (select(tipoEquipeTable)
            ..where((t) => t.remoteId.equals(remoteId)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca tipos de equipe por nome
  Future<List<TipoEquipeTableData>> buscarPorNome(String nome) async {
    return await (select(tipoEquipeTable)
          ..where((t) => t.nome.contains(nome)))
        .get();
  }

  /// Insere ou atualiza um tipo de equipe baseado no remote ID
  Future<int> inserirOuAtualizar(TipoEquipeTableCompanion tipoEquipe) async {
    final existente = await buscarPorRemoteIdOuNull(tipoEquipe.remoteId.value);
    if (existente != null) {
      return await (update(tipoEquipeTable)
            ..where((t) => t.remoteId.equals(tipoEquipe.remoteId.value)))
          .write(tipoEquipe);
    } else {
      return await into(tipoEquipeTable).insert(tipoEquipe);
    }
  }

  /// Atualiza um tipo de equipe por ID
  Future<int> atualizar(TipoEquipeTableData tipoEquipe) async {
    return await (update(tipoEquipeTable)
          ..where((t) => t.id.equals(tipoEquipe.id)))
        .write(TipoEquipeTableCompanion(
      nome: Value(tipoEquipe.nome),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Deleta fisicamente um tipo de equipe por ID
  Future<int> deletar(int id) async {
    return await (delete(tipoEquipeTable)..where((t) => t.id.equals(id))).go();
  }

  /// Limpa todos os registros da tabela de tipos de equipe
  Future<void> deletarTodos() async {
    await delete(tipoEquipeTable).go();
  }

  /// Sincroniza uma lista de tipos de equipe (insere ou atualiza)
  Future<void> sincronizar(List<TipoEquipeTableCompanion> tiposEquipe) async {
    for (final tipoEquipe in tiposEquipe) {
      await inserirOuAtualizar(tipoEquipe);
    }
  }

  /// Conta o número de tipos de equipe
  Future<int> contar() async {
    final result = await (selectOnly(tipoEquipeTable)
          ..addColumns([tipoEquipeTable.id.count()]))
        .getSingle();
    return result.read(tipoEquipeTable.id.count()) ?? 0;
  }
}
