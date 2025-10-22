import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';
import 'package:nexa_app/core/database/models/tipo_equipe_table.dart';

part 'tipo_equipe_dao.g.dart';

/// DAO para operações com a tabela de tipos de equipes.
///
/// Herda 17 métodos do [SyncableDao] automaticamente.
@DriftAccessor(tables: [TipoEquipeTable])
class TipoEquipeDao extends SyncableDao<TipoEquipeTable, TipoEquipeTableData>
    with _$TipoEquipeDaoMixin {
  TipoEquipeDao(super.db);

  @override
  TableInfo<TipoEquipeTable, TipoEquipeTableData> get table =>
      db.tipoEquipeTable;

  // ==========================================================================
  // MÉTODOS ESPECÍFICOS DE TIPO DE EQUIPE
  // ==========================================================================
  // Métodos genéricos herdados do SyncableDao (17 métodos)
  // ==========================================================================

  /// Alias para compatibilidade.
  Future<TipoEquipeTableData?> buscarPorIdOuNull(int id) async {
    return await buscarPorId(id);
  }

  /// Busca tipos de equipe por nome (busca parcial).
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipos = await tipoEquipeDao.buscarPorNome('Limpeza');
  /// ```
  Future<List<TipoEquipeTableData>> buscarPorNome(String nome) async {
    return await (select(table)..where((t) => t.nome.contains(nome))).get();
  }
}
