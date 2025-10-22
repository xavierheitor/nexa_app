import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';
import 'package:nexa_app/core/database/models/tipo_veiculo_table.dart';

part 'tipo_veiculo_dao.g.dart';

/// DAO para operações com a tabela de tipos de veículos.
///
/// Herda 17 métodos do [SyncableDao] automaticamente.
@DriftAccessor(tables: [TipoVeiculoTable])
class TipoVeiculoDao extends SyncableDao<TipoVeiculoTable, TipoVeiculoTableData>
    with _$TipoVeiculoDaoMixin {
  TipoVeiculoDao(super.db);

  @override
  TableInfo<TipoVeiculoTable, TipoVeiculoTableData> get table =>
      db.tipoVeiculoTable;

  // ==========================================================================
  // MÉTODOS ESPECÍFICOS DE TIPO DE VEÍCULO
  // ==========================================================================
  // Métodos genéricos herdados do SyncableDao (17 métodos)
  // ==========================================================================

  /// Alias para compatibilidade.
  Future<TipoVeiculoTableData?> buscarPorIdOuNull(int id) async {
    return await buscarPorId(id);
  }

  /// Busca tipos de veículos por nome (busca parcial).
  ///
  /// ## Exemplo:
  /// ```dart
  /// final tipos = await tipoVeiculoDao.buscarPorNome('Caminhão');
  /// ```
  Future<List<TipoVeiculoTableData>> buscarPorNome(String nome) async {
    return await (select(table)..where((t) => t.nome.contains(nome))).get();
  }
}
