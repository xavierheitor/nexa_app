import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_pergunta_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_pergunta_relacao_table_dto.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_pergunta_relacao_dao.g.dart';

/// DAO para gerenciar relações entre checklists e perguntas.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Esta é uma tabela de relação que usa DTOs.
@DriftAccessor(tables: [ChecklistPerguntaRelacaoTable])
class ChecklistPerguntaRelacaoDao extends SyncableDao<
    ChecklistPerguntaRelacaoTable,
    ChecklistPerguntaRelacaoTableData> with _$ChecklistPerguntaRelacaoDaoMixin {
  ChecklistPerguntaRelacaoDao(super.db);

  @override
  TableInfo<ChecklistPerguntaRelacaoTable, ChecklistPerguntaRelacaoTableData>
      get table => db.checklistPerguntaRelacaoTable;

  // ============================================================================
  // WRAPPERS PARA DTO
  // ============================================================================

  /// Sobrescreve listar para retornar DTOs.
  @override
  Future<List<ChecklistPerguntaRelacaoTableData>> listar() async {
    return await super.listar();
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<List<ChecklistPerguntaRelacaoTableDto>> listarDto() async {
    final result = await listar();
    return result.map(ChecklistPerguntaRelacaoTableDto.fromTable).toList();
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistPerguntaRelacaoTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null
        ? ChecklistPerguntaRelacaoTableDto.fromTable(result)
        : null;
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistPerguntaRelacaoTableDto?> buscarPorRemoteIdDto(
      int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    if (result == null) return null;
    return ChecklistPerguntaRelacaoTableDto.fromTable(result);
  }

  /// Insere ou atualiza usando DTO.
  Future<int> inserirOuAtualizarDto(
      ChecklistPerguntaRelacaoTableDto dto) async {
    return await inserirOuAtualizar(dto.toCompanion());
  }

  /// Insere usando DTO.
  Future<int> inserirDto(ChecklistPerguntaRelacaoTableDto dto) async {
    return await into(db.checklistPerguntaRelacaoTable)
        .insert(dto.toCompanion());
  }

  /// Atualiza usando DTO.
  Future<bool> atualizarDto(ChecklistPerguntaRelacaoTableDto dto) async {
    return await update(db.checklistPerguntaRelacaoTable)
        .replace(dto.toCompanion());
  }
}
