import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_opcao_resposta_table.dart';
import 'package:nexa_app/core/domain/dto/checklist_opcao_resposta_table_dto.dart';

part 'checklist_opcao_resposta_dao.g.dart';

/// DAO para operações com a tabela ChecklistOpcaoResposta.
@DriftAccessor(tables: [ChecklistOpcaoRespostaTable])
class ChecklistOpcaoRespostaDao extends DatabaseAccessor<AppDatabase> with _$ChecklistOpcaoRespostaDaoMixin {
  ChecklistOpcaoRespostaDao(super.db);

  /// Lista todas as opções de resposta.
  Future<List<ChecklistOpcaoRespostaTableDto>> listar() async {
    return await (select(db.checklistOpcaoRespostaTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row))
        .get();
  }

  /// Busca uma opção por ID.
  Future<ChecklistOpcaoRespostaTableDto?> buscarPorId(int id) async {
    final result = await (select(db.checklistOpcaoRespostaTable)
          ..where((t) => t.id.equals(id)))
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row))
        .getSingleOrNull();
    return result;
  }

  /// Busca uma opção por remote ID.
  Future<ChecklistOpcaoRespostaTableDto?> buscarPorRemoteId(int remoteId) async {
    final result = await (select(db.checklistOpcaoRespostaTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row))
        .getSingleOrNull();
    return result;
  }

  /// Busca opções por nome (busca parcial).
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorNome(String nome) async {
    return await (select(db.checklistOpcaoRespostaTable)
          ..where((t) => t.nome.like('%$nome%'))
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row))
        .get();
  }

  /// Busca opções que geram pendência.
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarQueGeramPendencia() async {
    return await (select(db.checklistOpcaoRespostaTable)
          ..where((t) => t.geraPendencia.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row))
        .get();
  }

  /// Busca opções de resposta de um modelo de checklist.
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorModelo(int checklistModeloId) async {
    // Implementação com JOIN manual
    final query = select(db.checklistOpcaoRespostaTable)
        .join([
          leftOuterJoin(
            db.checklistOpcaoRespostaRelacaoTable,
            db.checklistOpcaoRespostaRelacaoTable.checklistOpcaoRespostaId.equalsExp(db.checklistOpcaoRespostaTable.id),
          )
        ])
        ..where(db.checklistOpcaoRespostaRelacaoTable.checklistModeloId.equals(checklistModeloId))
        ..orderBy([OrderingTerm.asc(db.checklistOpcaoRespostaTable.nome)]);
    
    final results = await query.get();
    return results.map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row.readTable(db.checklistOpcaoRespostaTable))).toList();
  }

  /// Insere ou atualiza uma opção.
  Future<int> inserirOuAtualizar(ChecklistOpcaoRespostaTableDto opcao) async {
    return await into(db.checklistOpcaoRespostaTable).insertOnConflictUpdate(
      opcao.toCompanion(),
    );
  }

  /// Atualiza uma opção existente.
  Future<bool> atualizar(ChecklistOpcaoRespostaTableDto opcao) async {
    final result = await (update(db.checklistOpcaoRespostaTable)
          ..where((t) => t.id.equals(opcao.id)))
        .write(opcao.toCompanion());
    return result > 0;
  }

  /// Deleta uma opção.
  Future<bool> deletar(int id) async {
    final result = await (delete(db.checklistOpcaoRespostaTable)
          ..where((t) => t.id.equals(id)))
        .go();
    return result > 0;
  }

  /// Deleta todas as opções.
  Future<int> deletarTodos() async {
    return await delete(db.checklistOpcaoRespostaTable).go();
  }

  /// Conta o total de opções.
  Future<int> contar() async {
    final lista = await listar();
    return lista.length;
  }

  /// Conta opções que geram pendência.
  Future<int> contarQueGeramPendencia() async {
    final lista = await buscarQueGeramPendencia();
    return lista.length;
  }
}
