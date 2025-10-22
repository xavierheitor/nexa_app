import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_opcao_resposta_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_opcao_resposta_relacao_table_dto.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_opcao_resposta_relacao_dao.g.dart';

/// DAO para gerenciar relações entre checklists e opções de resposta.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Esta é uma tabela de relação que usa DTOs.
@DriftAccessor(tables: [ChecklistOpcaoRespostaRelacaoTable])
class ChecklistOpcaoRespostaRelacaoDao extends SyncableDao<
        ChecklistOpcaoRespostaRelacaoTable,
        ChecklistOpcaoRespostaRelacaoTableData>
    with _$ChecklistOpcaoRespostaRelacaoDaoMixin {
  ChecklistOpcaoRespostaRelacaoDao(super.db);

  @override
  TableInfo<ChecklistOpcaoRespostaRelacaoTable,
          ChecklistOpcaoRespostaRelacaoTableData>
      get table => db.checklistOpcaoRespostaRelacaoTable;

  // ============================================================================
  // WRAPPERS PARA DTO
  // ============================================================================

  /// Wrapper para manter compatibilidade com DTOs.
  Future<List<ChecklistOpcaoRespostaRelacaoTableDto>> listarDto() async {
    final result = await listar();
    return result.map(ChecklistOpcaoRespostaRelacaoTableDto.fromTable).toList();
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistOpcaoRespostaRelacaoTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null
        ? ChecklistOpcaoRespostaRelacaoTableDto.fromTable(result)
        : null;
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistOpcaoRespostaRelacaoTableDto?> buscarPorRemoteIdDto(
      int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    if (result == null) return null;
    return ChecklistOpcaoRespostaRelacaoTableDto.fromTable(result);
  }

  /// Insere ou atualiza usando DTO.
  Future<int> inserirOuAtualizarDto(
      ChecklistOpcaoRespostaRelacaoTableDto dto) async {
    return await inserirOuAtualizar(dto.toCompanion());
  }

  /// Insere usando DTO.
  Future<int> inserirDto(ChecklistOpcaoRespostaRelacaoTableDto dto) async {
    return await into(db.checklistOpcaoRespostaRelacaoTable)
        .insert(dto.toCompanion());
  }

  /// Atualiza usando DTO.
  Future<bool> atualizarDto(ChecklistOpcaoRespostaRelacaoTableDto dto) async {
    return await update(db.checklistOpcaoRespostaRelacaoTable)
        .replace(dto.toCompanion());
  }
}
