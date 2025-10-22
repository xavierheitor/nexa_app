import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_tipo_equipe_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_tipo_equipe_relacao_table_dto.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_tipo_equipe_relacao_dao.g.dart';

/// DAO para gerenciar relações entre checklists e tipos de equipe.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Esta é uma tabela de relação que usa DTOs.
@DriftAccessor(tables: [ChecklistTipoEquipeRelacaoTable])
class ChecklistTipoEquipeRelacaoDao extends SyncableDao<
        ChecklistTipoEquipeRelacaoTable, ChecklistTipoEquipeRelacaoTableData>
    with _$ChecklistTipoEquipeRelacaoDaoMixin {
  ChecklistTipoEquipeRelacaoDao(super.db);

  @override
  TableInfo<ChecklistTipoEquipeRelacaoTable,
          ChecklistTipoEquipeRelacaoTableData>
      get table => db.checklistTipoEquipeRelacaoTable;

  // ============================================================================
  // WRAPPERS PARA DTO
  // ============================================================================

  /// Wrapper para manter compatibilidade com DTOs.
  Future<List<ChecklistTipoEquipeRelacaoTableDto>> listarDto() async {
    final result = await listar();
    return result.map(ChecklistTipoEquipeRelacaoTableDto.fromTable).toList();
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistTipoEquipeRelacaoTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null
        ? ChecklistTipoEquipeRelacaoTableDto.fromTable(result)
        : null;
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistTipoEquipeRelacaoTableDto?> buscarPorRemoteIdDto(
      int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    if (result == null) return null;
    return ChecklistTipoEquipeRelacaoTableDto.fromTable(result);
  }

  /// Insere ou atualiza usando DTO.
  Future<int> inserirOuAtualizarDto(
      ChecklistTipoEquipeRelacaoTableDto dto) async {
    return await inserirOuAtualizar(dto.toCompanion());
  }

  /// Insere usando DTO.
  Future<int> inserirDto(ChecklistTipoEquipeRelacaoTableDto dto) async {
    return await into(db.checklistTipoEquipeRelacaoTable)
        .insert(dto.toCompanion());
  }

  /// Atualiza usando DTO.
  Future<bool> atualizarDto(ChecklistTipoEquipeRelacaoTableDto dto) async {
    return await update(db.checklistTipoEquipeRelacaoTable)
        .replace(dto.toCompanion());
  }
}
