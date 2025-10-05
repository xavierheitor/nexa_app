import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_pergunta_table.dart';
import 'package:nexa_app/core/domain/dto/checklist_pergunta_table_dto.dart';

part 'checklist_pergunta_dao.g.dart';

/// DAO para operações com a tabela ChecklistPergunta.
@DriftAccessor(tables: [ChecklistPerguntaTable])
class ChecklistPerguntaDao extends DatabaseAccessor<AppDatabase> with _$ChecklistPerguntaDaoMixin {
  ChecklistPerguntaDao(super.db);

  /// Lista todas as perguntas de checklist.
  Future<List<ChecklistPerguntaTableDto>> listar() async {
    return await (select(db.checklistPerguntaTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistPerguntaTableDto.fromTable(row))
        .get();
  }

  /// Busca uma pergunta por ID.
  Future<ChecklistPerguntaTableDto?> buscarPorId(int id) async {
    final result = await (select(db.checklistPerguntaTable)
          ..where((t) => t.id.equals(id)))
        .map((row) => ChecklistPerguntaTableDto.fromTable(row))
        .getSingleOrNull();
    return result;
  }

  /// Busca uma pergunta por remote ID.
  Future<ChecklistPerguntaTableDto?> buscarPorRemoteId(int remoteId) async {
    final result = await (select(db.checklistPerguntaTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .map((row) => ChecklistPerguntaTableDto.fromTable(row))
        .getSingleOrNull();
    return result;
  }

  /// Busca perguntas por nome (busca parcial).
  Future<List<ChecklistPerguntaTableDto>> buscarPorNome(String nome) async {
    return await (select(db.checklistPerguntaTable)
          ..where((t) => t.nome.like('%$nome%'))
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .map((row) => ChecklistPerguntaTableDto.fromTable(row))
        .get();
  }

  /// Busca perguntas de um modelo de checklist.
  Future<List<ChecklistPerguntaTableDto>> buscarPorModelo(
      int checklistModeloRemoteId) async {
    // Implementação com JOIN manual usando remoteId
    final query = select(db.checklistPerguntaTable)
        .join([
          leftOuterJoin(
            db.checklistPerguntaRelacaoTable,
        db.checklistPerguntaRelacaoTable.checklistPerguntaId
            .equalsExp(db.checklistPerguntaTable.remoteId),
          )
        ])
      ..where(db.checklistPerguntaRelacaoTable.checklistModeloId
          .equals(checklistModeloRemoteId))
        ..orderBy([OrderingTerm.asc(db.checklistPerguntaTable.nome)]);
    
    final results = await query.get();
    return results.map((row) => ChecklistPerguntaTableDto.fromTable(row.readTable(db.checklistPerguntaTable))).toList();
  }

  /// Insere ou atualiza uma pergunta.
  Future<int> inserirOuAtualizar(ChecklistPerguntaTableDto pergunta) async {
    return await into(db.checklistPerguntaTable).insertOnConflictUpdate(
      pergunta.toCompanion(),
    );
  }

  /// Atualiza uma pergunta existente.
  Future<bool> atualizar(ChecklistPerguntaTableDto pergunta) async {
    final result = await (update(db.checklistPerguntaTable)
          ..where((t) => t.id.equals(pergunta.id)))
        .write(pergunta.toCompanion());
    return result > 0;
  }

  /// Deleta uma pergunta.
  Future<bool> deletar(int id) async {
    final result = await (delete(db.checklistPerguntaTable)
          ..where((t) => t.id.equals(id)))
        .go();
    return result > 0;
  }

  /// Deleta todas as perguntas.
  Future<int> deletarTodos() async {
    return await delete(db.checklistPerguntaTable).go();
  }

  /// Conta o total de perguntas.
  Future<int> contar() async {
    final lista = await listar();
    return lista.length;
  }
}
