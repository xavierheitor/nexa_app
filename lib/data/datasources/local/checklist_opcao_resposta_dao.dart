import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_opcao_resposta_table.dart';
import 'package:nexa_app/data/models/checklist_opcao_resposta_table_dto.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_opcao_resposta_dao.g.dart';

/// DAO para operações com a tabela ChecklistOpcaoResposta.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Mantém métodos específicos de busca por modelo e geraPendencia.
@DriftAccessor(tables: [ChecklistOpcaoRespostaTable])
class ChecklistOpcaoRespostaDao extends SyncableDao<ChecklistOpcaoRespostaTable,
    ChecklistOpcaoRespostaTableData> with _$ChecklistOpcaoRespostaDaoMixin {
  ChecklistOpcaoRespostaDao(super.db);

  @override
  TableInfo<ChecklistOpcaoRespostaTable, ChecklistOpcaoRespostaTableData>
      get table => db.checklistOpcaoRespostaTable;

  // ============================================================================
  // WRAPPERS PARA DTO
  // ============================================================================

  /// Lista todas as opções ordenadas por nome (retorna DTOs).
  Future<List<ChecklistOpcaoRespostaTableDto>> listarDto() async {
    final results = await (select(db.checklistOpcaoRespostaTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nome)]))
        .get();
    return results
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(row))
        .toList();
  }

  /// Busca uma opção por ID (retorna DTO).
  Future<ChecklistOpcaoRespostaTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null
        ? ChecklistOpcaoRespostaTableDto.fromTable(result)
        : null;
  }

  /// Busca uma opção por remote ID (retorna DTO ou null).
  Future<ChecklistOpcaoRespostaTableDto?> buscarPorRemoteIdDto(
      int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    return result != null
        ? ChecklistOpcaoRespostaTableDto.fromTable(result)
        : null;
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS DE CHECKLIST OPÇÃO RESPOSTA
  // ============================================================================

  /// Busca opções por nome (busca parcial).
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorNome(
      String nome) async {
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
  Future<List<ChecklistOpcaoRespostaTableDto>> buscarPorModelo(
      int checklistModeloRemoteId) async {
    // Implementação com JOIN manual usando remoteId
    final query = select(db.checklistOpcaoRespostaTable).join([
      leftOuterJoin(
        db.checklistOpcaoRespostaRelacaoTable,
        db.checklistOpcaoRespostaRelacaoTable.checklistOpcaoRespostaId
            .equalsExp(db.checklistOpcaoRespostaTable.remoteId),
      )
    ])
      ..where(db.checklistOpcaoRespostaRelacaoTable.checklistModeloId
          .equals(checklistModeloRemoteId))
      ..orderBy([OrderingTerm.asc(db.checklistOpcaoRespostaTable.nome)]);

    final results = await query.get();
    return results
        .map((row) => ChecklistOpcaoRespostaTableDto.fromTable(
            row.readTable(db.checklistOpcaoRespostaTable)))
        .toList();
  }

  // ============================================================================
  // MÉTODOS CUSTOMIZADOS (para compatibilidade com DTOs)
  // ============================================================================

  /// Insere ou atualiza uma opção usando DTO.
  Future<int> inserirOuAtualizarDto(
      ChecklistOpcaoRespostaTableDto opcao) async {
    return await inserirOuAtualizar(opcao.toCompanion());
  }

  /// Atualiza uma opção existente usando DTO.
  Future<bool> atualizarDto(ChecklistOpcaoRespostaTableDto opcao) async {
    final result = await (update(db.checklistOpcaoRespostaTable)
          ..where((t) => t.id.equals(opcao.id)))
        .write(opcao.toCompanion());
    return result > 0;
  }

  /// Conta opções que geram pendência.
  Future<int> contarQueGeramPendencia() async {
    final lista = await buscarQueGeramPendencia();
    return lista.length;
  }
}
