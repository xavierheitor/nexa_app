import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/equipe_table.dart';
import 'package:nexa_app/core/database/models/tipo_equipe_table.dart';

part 'equipe_dao.g.dart';

@DriftAccessor(tables: [EquipeTable, TipoEquipeTable])
class EquipeDao extends DatabaseAccessor<AppDatabase> with _$EquipeDaoMixin {
  EquipeDao(super.db);

  /// Lista todas as equipes
  Future<List<EquipeTableData>> listar() async {
    return await select(equipeTable).get();
  }

  /// Busca uma equipe por ID
  Future<EquipeTableData> buscarPorId(int id) async {
    return await (select(equipeTable)..where((e) => e.id.equals(id)))
        .getSingle();
  }

  /// Busca uma equipe por ID (retorna null se não encontrar)
  Future<EquipeTableData?> buscarPorIdOuNull(int id) async {
    try {
      return await (select(equipeTable)..where((e) => e.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca uma equipe por remote ID
  Future<EquipeTableData> buscarPorRemoteId(int remoteId) async {
    return await (select(equipeTable)
          ..where((e) => e.remoteId.equals(remoteId)))
        .getSingle();
  }

  /// Busca uma equipe por remote ID (retorna null se não encontrar)
  Future<EquipeTableData?> buscarPorRemoteIdOuNull(int remoteId) async {
    try {
      return await (select(equipeTable)
            ..where((e) => e.remoteId.equals(remoteId)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca equipes por nome
  Future<List<EquipeTableData>> buscarPorNome(String nome) async {
    return await (select(equipeTable)
          ..where((e) => e.nome.contains(nome)))
        .get();
  }

  /// Busca equipes por tipo de equipe
  Future<List<EquipeTableData>> buscarPorTipoEquipe(int tipoEquipeId) async {
    return await (select(equipeTable)
          ..where((e) => e.tipoEquipeId.equals(tipoEquipeId)))
        .get();
  }

  /// Lista equipes com informações do tipo de equipe
  Future<List<EquipeTableData>> listarComTipoEquipe() async {
    return await (select(equipeTable)
          ..join([
            leftOuterJoin(tipoEquipeTable,
                tipoEquipeTable.id.equalsExp(equipeTable.tipoEquipeId))
          ]))
        .get();
  }

  /// Insere ou atualiza uma equipe baseado no remote ID
  Future<int> inserirOuAtualizar(EquipeTableCompanion equipe) async {
    final existente = await buscarPorRemoteIdOuNull(equipe.remoteId.value);
    if (existente != null) {
      return await (update(equipeTable)
            ..where((e) => e.remoteId.equals(equipe.remoteId.value)))
          .write(equipe);
    } else {
      return await into(equipeTable).insert(equipe);
    }
  }

  /// Atualiza uma equipe por ID
  Future<int> atualizar(EquipeTableData equipe) async {
    return await (update(equipeTable)
          ..where((e) => e.id.equals(equipe.id)))
        .write(EquipeTableCompanion(
      nome: Value(equipe.nome),
      descricao: Value(equipe.descricao),
      tipoEquipeId: Value(equipe.tipoEquipeId),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Deleta fisicamente uma equipe por ID
  Future<int> deletar(int id) async {
    return await (delete(equipeTable)..where((e) => e.id.equals(id))).go();
  }

  /// Limpa todos os registros da tabela de equipes
  Future<void> deletarTodos() async {
    await delete(equipeTable).go();
  }

  /// Sincroniza uma lista de equipes (insere ou atualiza)
  Future<void> sincronizar(List<EquipeTableCompanion> equipes) async {
    for (final equipe in equipes) {
      await inserirOuAtualizar(equipe);
    }
  }

  /// Conta o número de equipes
  Future<int> contar() async {
    final result = await (selectOnly(equipeTable)
          ..addColumns([equipeTable.id.count()]))
        .getSingle();
    return result.read(equipeTable.id.count()) ?? 0;
  }

  /// Marca equipes como sincronizadas
  Future<void> marcarComoSincronizadas(List<int> ids) async {
    await (update(equipeTable)
          ..where((e) => e.id.isIn(ids)))
        .write(EquipeTableCompanion(
      sincronizado: Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Lista equipes não sincronizadas
  Future<List<EquipeTableData>> listarNaoSincronizadas() async {
    return await (select(equipeTable)
          ..where((e) => e.sincronizado.equals(false)))
        .get();
  }
}
