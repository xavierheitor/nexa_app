import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_pergunta_table.dart';
import 'package:nexa_app/data/models/checklist_pergunta_table_dto.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_pergunta_dao.g.dart';

/// DAO para operações com a tabela ChecklistPergunta.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Mantém métodos específicos de busca por modelo e nome.
@DriftAccessor(tables: [ChecklistPerguntaTable])
class ChecklistPerguntaDao
    extends SyncableDao<ChecklistPerguntaTable, ChecklistPerguntaTableData>
    with _$ChecklistPerguntaDaoMixin {
  ChecklistPerguntaDao(super.db);

  @override
  TableInfo<ChecklistPerguntaTable, ChecklistPerguntaTableData> get table =>
      db.checklistPerguntaTable;

  // ============================================================================
  // WRAPPERS PARA DTO
  // ============================================================================

  /// Lista todas as perguntas ordenadas por nome (retorna DTOs).
  Future<List<ChecklistPerguntaTableDto>> listarDto() async {
    final results = await (select(db.checklistPerguntaTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .get();
    return results
        .map((row) => ChecklistPerguntaTableDto.fromTable(row))
        .toList();
  }

  /// Busca uma pergunta por ID (retorna DTO).
  Future<ChecklistPerguntaTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null ? ChecklistPerguntaTableDto.fromTable(result) : null;
  }

  /// Busca uma pergunta por remote ID (retorna DTO ou null).
  Future<ChecklistPerguntaTableDto?> buscarPorRemoteIdDto(int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    return result != null ? ChecklistPerguntaTableDto.fromTable(result) : null;
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS DE CHECKLIST PERGUNTA
  // ============================================================================

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
    final query = select(db.checklistPerguntaTable).join([
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
    return results
        .map((row) => ChecklistPerguntaTableDto.fromTable(
            row.readTable(db.checklistPerguntaTable)))
        .toList();
  }

  // ============================================================================
  // MÉTODOS CUSTOMIZADOS (para compatibilidade com DTOs)
  // ============================================================================

  /// Insere ou atualiza uma pergunta usando DTO.
  Future<int> inserirOuAtualizarDto(ChecklistPerguntaTableDto pergunta) async {
    return await inserirOuAtualizar(pergunta.toCompanion());
  }

  /// Atualiza uma pergunta existente usando DTO.
  Future<bool> atualizarDto(ChecklistPerguntaTableDto pergunta) async {
    final result = await (update(db.checklistPerguntaTable)
          ..where((t) => t.id.equals(pergunta.id)))
        .write(pergunta.toCompanion());
    return result > 0;
  }
}
