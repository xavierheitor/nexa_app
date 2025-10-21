import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_tipo_veiculo_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_tipo_veiculo_relacao_table_dto.dart';

part 'checklist_tipo_veiculo_relacao_dao.g.dart';

@DriftAccessor(tables: [ChecklistTipoVeiculoRelacaoTable])
class ChecklistTipoVeiculoRelacaoDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistTipoVeiculoRelacaoDaoMixin {
  ChecklistTipoVeiculoRelacaoDao(super.db);

  Future<List<ChecklistTipoVeiculoRelacaoTableDto>> listar() async {
    final result = await select(checklistTipoVeiculoRelacaoTable).get();
    return result.map(ChecklistTipoVeiculoRelacaoTableDto.fromTable).toList();
  }

  Future<ChecklistTipoVeiculoRelacaoTableDto?> buscarPorId(int id) async {
    final result = await (select(checklistTipoVeiculoRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null
        ? ChecklistTipoVeiculoRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<ChecklistTipoVeiculoRelacaoTableDto?> buscarPorRemoteId(
      int remoteId) async {
    final result = await (select(checklistTipoVeiculoRelacaoTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    return result != null
        ? ChecklistTipoVeiculoRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<int> inserirOuAtualizar(
      ChecklistTipoVeiculoRelacaoTableDto dto) async {
    final remoteId = dto.remoteId;
    if (remoteId != null) {
      final existente = await buscarPorRemoteId(remoteId);
      if (existente != null) {
        await atualizar(dto.copyWith(id: existente.id));
        return existente.id;
      }
    }
    return await inserir(dto);
  }

  Future<int> inserir(ChecklistTipoVeiculoRelacaoTableDto dto) async {
    return await into(checklistTipoVeiculoRelacaoTable)
        .insert(dto.toCompanion());
  }

  Future<bool> atualizar(ChecklistTipoVeiculoRelacaoTableDto dto) async {
    return await update(checklistTipoVeiculoRelacaoTable)
        .replace(dto.toCompanion());
  }

  Future<int> deletar(int id) async {
    return await (delete(checklistTipoVeiculoRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> deletarTodos() async {
    return await delete(checklistTipoVeiculoRelacaoTable).go();
  }

  Future<int> contar() async {
    final result = await listar();
    return result.length;
  }
}

