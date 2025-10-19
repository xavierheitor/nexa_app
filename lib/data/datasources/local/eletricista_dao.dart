import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/eletricista_table.dart';

part 'eletricista_dao.g.dart';

@DriftAccessor(tables: [EletricistaTable])
class EletricistaDao extends DatabaseAccessor<AppDatabase> with _$EletricistaDaoMixin {
  EletricistaDao(super.db);

  /// Lista todos os eletricistas ativos (não deletados)
  Future<List<EletricistaTableData>> listar() async {
    return await (select(eletricistaTable)).get();
  }

  /// Lista todos os eletricistas, incluindo os deletados
  Future<List<EletricistaTableData>> listarTodos() async {
    return await select(eletricistaTable).get();
  }

  /// Busca um eletricista por ID
  Future<EletricistaTableData> buscarPorId(int id) async {
    return await (select(eletricistaTable)..where((e) => e.id.equals(id)))
        .getSingle();
  }

  /// Busca um eletricista por ID (retorna null se não encontrar)
  Future<EletricistaTableData?> buscarPorIdOuNull(int id) async {
    try {
      return await (select(eletricistaTable)..where((e) => e.id.equals(id)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca um eletricista por remote ID
  Future<EletricistaTableData> buscarPorRemoteId(int remoteId) async {
    return await (select(eletricistaTable)
          ..where((e) => e.remoteId.equals(remoteId)))
        .getSingle();
  }

  /// Busca um eletricista por remote ID (retorna null se não encontrar)
  Future<EletricistaTableData?> buscarPorRemoteIdOuNull(int remoteId) async {
    try {
      return await (select(eletricistaTable)
            ..where((e) => e.remoteId.equals(remoteId)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca um eletricista por matrícula
  Future<EletricistaTableData> buscarPorMatricula(String matricula) async {
    return await (select(eletricistaTable)..where((e) => e.matricula.equals(matricula)))
        .getSingle();
  }

  /// Busca um eletricista por matrícula (retorna null se não encontrar)
  Future<EletricistaTableData?> buscarPorMatriculaOuNull(String matricula) async {
    try {
      return await (select(eletricistaTable)..where((e) => e.matricula.equals(matricula)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Busca eletricistas por nome (busca parcial)
  Future<List<EletricistaTableData>> buscarPorNome(String nome) async {
    return await (select(eletricistaTable)
          ..where((e) => e.nome.contains(nome)))
        .get();
  }

  /// Insere ou atualiza um eletricista baseado no remote ID
  Future<int> inserirOuAtualizar(EletricistaTableCompanion eletricista) async {
    final existente = await buscarPorRemoteIdOuNull(eletricista.remoteId.value);
    if (existente != null) {
      return await (update(eletricistaTable)
            ..where((e) => e.remoteId.equals(eletricista.remoteId.value)))
          .write(eletricista);
    } else {
      return await into(eletricistaTable).insert(eletricista);
    }
  }

  /// Atualiza um eletricista por ID
  Future<int> atualizar(EletricistaTableData eletricista) async {
    return await (update(eletricistaTable)..where((e) => e.id.equals(eletricista.id)))
        .write(EletricistaTableCompanion(
      nome: Value(eletricista.nome),
      matricula: Value(eletricista.matricula),
    ));
  }

  /// Deleta fisicamente um eletricista por ID
  Future<int> deletar(int id) async {
    return await (delete(eletricistaTable)..where((e) => e.id.equals(id))).go();
  }

  /// Limpa todos os registros da tabela de eletricistas
  Future<void> deletarTodos() async {
    await delete(eletricistaTable).go();
  }

  /// Sincroniza uma lista de eletricistas (insere ou atualiza)
  Future<void> sincronizar(List<EletricistaTableCompanion> eletricistas) async {
    for (final eletricista in eletricistas) {
      await inserirOuAtualizar(eletricista);
    }
  }

  /// Conta o número de eletricistas ativos
  Future<int> contar() async {
    final query = selectOnly(eletricistaTable)
      ..addColumns([eletricistaTable.id.count()]);

    final result = await query.getSingle();
    return result.read(eletricistaTable.id.count()) ?? 0;
  }
}
