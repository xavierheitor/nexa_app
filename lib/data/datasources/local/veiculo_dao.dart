import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';
import 'package:nexa_app/core/database/models/veiculo_table.dart';
import 'package:nexa_app/core/database/models/tipo_veiculo_table.dart';

part 'veiculo_dao.g.dart';

/// DAO para operações com a tabela de veículos.
///
/// Herda de [SyncableDao] que fornece automaticamente:
/// - `listar()`, `buscarPorId()`, `inserir()`, `atualizar()`, `deletar()`
/// - `buscarPorRemoteId()`, `inserirOuAtualizar()`, `sincronizar()`
/// - `deletarTodos()`, `contar()`, `existe()`, `estaVazia()`
/// - `buscarNaoSincronizados()`, `marcarComoSincronizado()`
///
/// Este DAO adiciona apenas métodos **específicos** de veículos.
@DriftAccessor(tables: [VeiculoTable, TipoVeiculoTable])
class VeiculoDao extends SyncableDao<VeiculoTable, VeiculoTableData>
    with _$VeiculoDaoMixin {
  VeiculoDao(super.db);

  /// Tabela gerenciada por este DAO.
  @override
  TableInfo<VeiculoTable, VeiculoTableData> get table => db.veiculoTable;

  // ==========================================================================
  // MÉTODOS ESPECÍFICOS DE VEÍCULO
  // ==========================================================================
  // Nota: Métodos genéricos foram removidos (herdados do SyncableDao)
  // ==========================================================================

  /// Busca um veículo por placa.
  ///
  /// Lança exceção se não encontrar.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorPlaca('ABC-1234');
  /// print('Veículo: ${veiculo.placa}');
  /// ```
  Future<VeiculoTableData> buscarPorPlaca(String placa) async {
    return await (select(table)..where((v) => v.placa.equals(placa)))
        .getSingle();
  }

  /// Busca um veículo por placa de forma segura.
  ///
  /// Retorna `null` se não encontrar.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculo = await veiculoDao.buscarPorPlacaOuNull('ABC-1234');
  /// if (veiculo != null) {
  ///   print('Encontrado: ${veiculo.placa}');
  /// }
  /// ```
  Future<VeiculoTableData?> buscarPorPlacaOuNull(String placa) async {
    try {
      return await (select(table)..where((v) => v.placa.equals(placa)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca veículos por tipo.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final caminhoes = await veiculoDao.buscarPorTipoVeiculo(1);
  /// print('${caminhoes.length} caminhões');
  /// ```
  Future<List<VeiculoTableData>> buscarPorTipoVeiculo(int tipoVeiculoId) async {
    return await (select(table)
          ..where((v) => v.tipoVeiculoId.equals(tipoVeiculoId)))
        .get();
  }

  /// Lista veículos com informações do tipo (JOIN).
  ///
  /// Retorna veículos com dados do tipo populados.
  ///
  /// ## Exemplo:
  /// ```dart
  /// final veiculosComTipo = await veiculoDao.listarComTipoVeiculo();
  /// ```
  Future<List<VeiculoTableData>> listarComTipoVeiculo() async {
    // Por enquanto retorna apenas veículos (JOIN pode ser adicionado depois)
    return await listar();
  }

  /// Alias para manter compatibilidade com código existente.
  ///
  /// Usa o método `buscarPorId()` herdado do BaseDao.
  Future<VeiculoTableData?> buscarPorIdOuNull(int id) async {
    return await buscarPorId(id);
  }

  /// Conta apenas os veículos ativos (sincronizados).
  ///
  /// ## Exemplo:
  /// ```dart
  /// final total = await veiculoDao.contarVeiculosAtivos();
  /// ```
  Future<int> contarVeiculosAtivos() async {
    // Por enquanto, conta todos (pode adicionar filtro de sincronizado depois)
    return await contar();
  }
}
