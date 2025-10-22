import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';
import 'package:nexa_app/core/database/models/equipe_table.dart';
import 'package:nexa_app/core/database/models/tipo_equipe_table.dart';

part 'equipe_dao.g.dart';

/// DAO para operações com a tabela de equipes.
///
/// Herda de [SyncableDao] que fornece automaticamente:
/// - `listar()`, `buscarPorId()`, `inserir()`, `atualizar()`, `deletar()`
/// - `buscarPorRemoteId()`, `inserirOuAtualizar()`, `sincronizar()`
/// - `deletarTodos()`, `contar()`, `existe()`, `estaVazia()`
/// - `buscarNaoSincronizados()`, `marcarComoSincronizado()`
///
/// Este DAO adiciona apenas métodos **específicos** de equipes.
@DriftAccessor(tables: [EquipeTable, TipoEquipeTable])
class EquipeDao extends SyncableDao<EquipeTable, EquipeTableData>
    with _$EquipeDaoMixin {
  EquipeDao(super.db);

  /// Tabela gerenciada por este DAO.
  @override
  TableInfo<EquipeTable, EquipeTableData> get table => db.equipeTable;

  // ==========================================================================
  // MÉTODOS ESPECÍFICOS DE EQUIPE
  // ==========================================================================
  // Nota: Métodos genéricos foram removidos (herdados do SyncableDao)
  // ==========================================================================

  /// Alias para compatibilidade com código existente.
  Future<EquipeTableData?> buscarPorIdOuNull(int id) async {
    return await buscarPorId(id);
  }

  /// Busca equipes por nome (busca parcial).
  ///
  /// ## Exemplo:
  /// ```dart
  /// final equipes = await equipeDao.buscarPorNome('Limpeza');
  /// print('${equipes.length} equipes encontradas');
  /// ```
  Future<List<EquipeTableData>> buscarPorNome(String nome) async {
    return await (select(table)..where((e) => e.nome.contains(nome))).get();
  }

  /// Busca equipes por tipo.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final equipesLimpeza = await equipeDao.buscarPorTipoEquipe(1);
  /// ```
  Future<List<EquipeTableData>> buscarPorTipoEquipe(int tipoEquipeId) async {
    return await (select(table)
          ..where((e) => e.tipoEquipeId.equals(tipoEquipeId)))
        .get();
  }

  /// Lista equipes com informações do tipo (JOIN).
  ///
  /// Retorna equipes com dados do tipo populados.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final equipesComTipo = await equipeDao.listarComTipoEquipe();
  /// ```
  Future<List<EquipeTableData>> listarComTipoEquipe() async {
    return await (select(db.equipeTable)
          ..join([
            leftOuterJoin(db.tipoEquipeTable,
                db.tipoEquipeTable.id.equalsExp(db.equipeTable.tipoEquipeId))
          ]))
        .get();
  }

  /// Marca múltiplas equipes como sincronizadas.
  ///
  /// ## Exemplo:
  /// ```dart
  /// await equipeDao.marcarComoSincronizadas([1, 2, 3]);
  /// ```
  Future<void> marcarComoSincronizadas(List<int> ids) async {
    await (update(table)..where((e) => e.id.isIn(ids))).write(
      EquipeTableCompanion(
        sincronizado: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Alias para `buscarNaoSincronizados()` herdado (compatibilidade).
  Future<List<EquipeTableData>> listarNaoSincronizadas() async {
    return await buscarNaoSincronizados();
  }
}
