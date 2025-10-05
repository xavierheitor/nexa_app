import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/veiculo_table.dart';
import 'package:nexa_app/core/database/models/tipo_veiculo_table.dart';

part 'veiculo_dao.g.dart';

@DriftAccessor(tables: [VeiculoTable, TipoVeiculoTable])
class VeiculoDao extends DatabaseAccessor<AppDatabase> with _$VeiculoDaoMixin {
  VeiculoDao(super.db);

  /// Lista todos os veículos ativos (não deletados)
  Future<List<VeiculoTableData>> listar() async {
    return await (select(veiculoTable)).get();
  }

  /// Lista todos os veículos, incluindo os deletados
  Future<List<VeiculoTableData>> listarTodos() async {
    return await select(veiculoTable).get();
  }

  /// Lista veículos com informações do tipo de veículo
  Future<List<VeiculoTableData>> listarComTipoVeiculo() async {
    return await (select(veiculoTable)).get();
  }

  /// Busca um veículo por ID
  Future<VeiculoTableData> buscarPorId(int id) async {
    return await (select(veiculoTable)..where((v) => v.id.equals(id)))
        .getSingle();
  }

  /// Busca um veículo por ID (retorna null se não encontrar)
  Future<VeiculoTableData?> buscarPorIdOuNull(int id) async {
    try {
      return await (select(veiculoTable)..where((v) => v.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca um veículo por remote ID
  Future<VeiculoTableData> buscarPorRemoteId(int remoteId) async {
    return await (select(veiculoTable)
          ..where((v) => v.remoteId.equals(remoteId)))
        .getSingle();
  }

  /// Busca um veículo por remote ID (retorna null se não encontrar)
  Future<VeiculoTableData?> buscarPorRemoteIdOuNull(int remoteId) async {
    try {
      return await (select(veiculoTable)
            ..where((v) => v.remoteId.equals(remoteId)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca um veículo por placa
  Future<VeiculoTableData> buscarPorPlaca(String placa) async {
    return await (select(veiculoTable)..where((v) => v.placa.equals(placa)))
        .getSingle();
  }

  /// Busca um veículo por placa (retorna null se não encontrar)
  Future<VeiculoTableData?> buscarPorPlacaOuNull(String placa) async {
    try {
      return await (select(veiculoTable)..where((v) => v.placa.equals(placa)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca veículos por tipo de veículo
  Future<List<VeiculoTableData>> buscarPorTipoVeiculo(int tipoVeiculoId) async {
    return await (select(veiculoTable)
          ..where((v) => v.tipoVeiculoId.equals(tipoVeiculoId)))
        .get();
  }

  /// Insere ou atualiza um veículo baseado no remote ID
  Future<int> inserirOuAtualizar(VeiculoTableCompanion veiculo) async {
    final existente = await buscarPorRemoteIdOuNull(veiculo.remoteId.value);
    if (existente != null) {
      return await (update(veiculoTable)
            ..where((v) => v.remoteId.equals(veiculo.remoteId.value)))
          .write(veiculo);
    } else {
      return await into(veiculoTable).insert(veiculo);
    }
  }

  /// Atualiza um veículo por ID
  Future<int> atualizar(VeiculoTableData veiculo) async {
    return await (update(veiculoTable)..where((v) => v.id.equals(veiculo.id)))
        .write(VeiculoTableCompanion(
      placa: Value(veiculo.placa),
      tipoVeiculoId: Value(veiculo.tipoVeiculoId),
    ));
  }

  /// Deleta fisicamente um veículo por ID
  Future<int> deletar(int id) async {
    return await (delete(veiculoTable)..where((v) => v.id.equals(id))).go();
  }

  /// Limpa todos os registros da tabela de veículos
  Future<void> deletarTodos() async {
    await delete(veiculoTable).go();
  }

  /// Sincroniza uma lista de veículos (insere ou atualiza)
  Future<void> sincronizar(List<VeiculoTableCompanion> veiculos) async {
    for (final veiculo in veiculos) {
      await inserirOuAtualizar(veiculo);
    }
  }

  /// Conta o número de veículos ativos
  Future<int> contarVeiculosAtivos() async {
    final query = selectOnly(veiculoTable)
      ..addColumns([veiculoTable.id.count()]);

    final result = await query.getSingle();
    return result.read(veiculoTable.id.count()) ?? 0;
  }
}
