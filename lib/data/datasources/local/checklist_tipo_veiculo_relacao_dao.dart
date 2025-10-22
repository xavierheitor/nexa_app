import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_tipo_veiculo_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_tipo_veiculo_relacao_table_dto.dart';
import 'package:nexa_app/core/database/syncable_dao.dart';

part 'checklist_tipo_veiculo_relacao_dao.g.dart';

/// DAO para gerenciar relações entre checklists e tipos de veículo.
///
/// Estende [SyncableDao] para herdar operações CRUD genéricas e métodos de sincronização.
/// Esta é uma tabela de relação que usa DTOs.
@DriftAccessor(tables: [ChecklistTipoVeiculoRelacaoTable])
class ChecklistTipoVeiculoRelacaoDao extends SyncableDao<
        ChecklistTipoVeiculoRelacaoTable, ChecklistTipoVeiculoRelacaoTableData>
    with _$ChecklistTipoVeiculoRelacaoDaoMixin {
  ChecklistTipoVeiculoRelacaoDao(super.db);

  @override
  TableInfo<ChecklistTipoVeiculoRelacaoTable,
          ChecklistTipoVeiculoRelacaoTableData>
      get table => db.checklistTipoVeiculoRelacaoTable;

  // ============================================================================
  // WRAPPERS PARA DTO
  // ============================================================================

  /// Wrapper para manter compatibilidade com DTOs.
  Future<List<ChecklistTipoVeiculoRelacaoTableDto>> listarDto() async {
    final result = await listar();
    return result.map(ChecklistTipoVeiculoRelacaoTableDto.fromTable).toList();
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistTipoVeiculoRelacaoTableDto?> buscarPorIdDto(int id) async {
    final result = await buscarPorId(id);
    return result != null
        ? ChecklistTipoVeiculoRelacaoTableDto.fromTable(result)
        : null;
  }

  /// Wrapper para manter compatibilidade com DTOs.
  Future<ChecklistTipoVeiculoRelacaoTableDto?> buscarPorRemoteIdDto(
      int remoteId) async {
    final result = await buscarPorRemoteId(remoteId);
    if (result == null) return null;
    return ChecklistTipoVeiculoRelacaoTableDto.fromTable(result);
  }

  /// Insere ou atualiza usando DTO.
  Future<int> inserirOuAtualizarDto(
      ChecklistTipoVeiculoRelacaoTableDto dto) async {
    return await inserirOuAtualizar(dto.toCompanion());
  }

  /// Insere usando DTO.
  Future<int> inserirDto(ChecklistTipoVeiculoRelacaoTableDto dto) async {
    return await into(db.checklistTipoVeiculoRelacaoTable)
        .insert(dto.toCompanion());
  }

  /// Atualiza usando DTO.
  Future<bool> atualizarDto(ChecklistTipoVeiculoRelacaoTableDto dto) async {
    return await update(db.checklistTipoVeiculoRelacaoTable)
        .replace(dto.toCompanion());
  }
}
