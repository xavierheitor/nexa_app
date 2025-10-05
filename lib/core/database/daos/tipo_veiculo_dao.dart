import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/tipo_veiculo_table.dart';

part 'tipo_veiculo_dao.g.dart';

@DriftAccessor(tables: [TipoVeiculoTable])
class TipoVeiculoDao extends DatabaseAccessor<AppDatabase>
    with _$TipoVeiculoDaoMixin {
  TipoVeiculoDao(super.db);

  /// Lista todos os tipos de veículos ativos (não deletados)
  Future<List<TipoVeiculoTableData>> listar() async {
    return await (select(tipoVeiculoTable)).get();
  }

  /// Lista todos os tipos de veículos, incluindo os deletados
  Future<List<TipoVeiculoTableData>> listarTodos() async {
    return await select(tipoVeiculoTable).get();
  }

  /// Busca um tipo de veículo por ID
  Future<TipoVeiculoTableData> buscarPorId(int id) async {
    return await (select(tipoVeiculoTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// Busca um tipo de veículo por ID (retorna null se não encontrar)
  Future<TipoVeiculoTableData?> buscarPorIdOuNull(int id) async {
    try {
      return await (select(tipoVeiculoTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca um tipo de veículo por remote ID
  Future<TipoVeiculoTableData> buscarPorRemoteId(int remoteId) async {
    return await (select(tipoVeiculoTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingle();
  }

  /// Busca um tipo de veículo por remote ID (retorna null se não encontrar)
  Future<TipoVeiculoTableData?> buscarPorRemoteIdOuNull(int remoteId) async {
    try {
      return await (select(tipoVeiculoTable)
            ..where((t) => t.remoteId.equals(remoteId)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca tipos de veículos por nome
  Future<List<TipoVeiculoTableData>> buscarPorNome(String nome) async {
    return await (select(tipoVeiculoTable)
          ..where((t) => t.nome.contains(nome)))
        .get();
  }

  /// Insere ou atualiza um tipo de veículo baseado no remote ID
  Future<int> inserirOuAtualizar(TipoVeiculoTableCompanion tipoVeiculo) async {
    final existente = await buscarPorRemoteIdOuNull(tipoVeiculo.remoteId.value);
    if (existente != null) {
      return await (update(tipoVeiculoTable)
            ..where((t) => t.remoteId.equals(tipoVeiculo.remoteId.value)))
          .write(tipoVeiculo);
    } else {
      return await into(tipoVeiculoTable).insert(tipoVeiculo);
    }
  }

  /// Atualiza um tipo de veículo por ID
  Future<int> atualizar(TipoVeiculoTableData tipoVeiculo) async {
    return await (update(tipoVeiculoTable)
          ..where((t) => t.id.equals(tipoVeiculo.id)))
        .write(TipoVeiculoTableCompanion(
      nome: Value(tipoVeiculo.nome),
      descricao: Value(tipoVeiculo.descricao),
    ));
  }

  /// Deleta fisicamente um tipo de veículo por ID
  Future<int> deletar(int id) async {
    return await (delete(tipoVeiculoTable)..where((t) => t.id.equals(id))).go();
  }

  /// Deleta logicamente um tipo de veículo por ID (soft delete)
  Future<int> deletarLogicamente(int id, String deletedBy) async {
    return await (update(tipoVeiculoTable)..where((t) => t.id.equals(id)))
        .write(TipoVeiculoTableCompanion(
    ));
  }

  /// Limpa todos os registros da tabela de tipos de veículos
  Future<void> deletarTodos() async {
    await delete(tipoVeiculoTable).go();
  }

  /// Sincroniza uma lista de tipos de veículos (insere ou atualiza)
  Future<void> sincronizar(List<TipoVeiculoTableCompanion> tiposVeiculo) async {
    for (final tipoVeiculo in tiposVeiculo) {
      await inserirOuAtualizar(tipoVeiculo);
    }
  }
}
