import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_tipo_equipe_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_tipo_equipe_relacao_table_dto.dart';

part 'checklist_tipo_equipe_relacao_dao.g.dart';

@DriftAccessor(tables: [ChecklistTipoEquipeRelacaoTable])
class ChecklistTipoEquipeRelacaoDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistTipoEquipeRelacaoDaoMixin {
  ChecklistTipoEquipeRelacaoDao(super.db);

  Future<List<ChecklistTipoEquipeRelacaoTableDto>> listar() async {
    final result = await select(checklistTipoEquipeRelacaoTable).get();
    return result.map(ChecklistTipoEquipeRelacaoTableDto.fromTable).toList();
  }

  Future<ChecklistTipoEquipeRelacaoTableDto?> buscarPorId(int id) async {
    final result = await (select(checklistTipoEquipeRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null
        ? ChecklistTipoEquipeRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<ChecklistTipoEquipeRelacaoTableDto?> buscarPorRemoteId(
      int remoteId) async {
    final result = await (select(checklistTipoEquipeRelacaoTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    return result != null
        ? ChecklistTipoEquipeRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<int> inserirOuAtualizar(
      ChecklistTipoEquipeRelacaoTableDto dto) async {
    if (dto.remoteId != null) {
      final existente = await buscarPorRemoteId(dto.remoteId!);
      if (existente != null) {
        await atualizar(dto.copyWith(id: existente.id));
        return existente.id;
      }
    }
    return await inserir(dto);
  }

  Future<int> inserir(ChecklistTipoEquipeRelacaoTableDto dto) async {
    return await into(checklistTipoEquipeRelacaoTable)
        .insert(dto.toCompanion());
  }

  Future<bool> atualizar(ChecklistTipoEquipeRelacaoTableDto dto) async {
    return await update(checklistTipoEquipeRelacaoTable)
        .replace(dto.toCompanion());
  }

  Future<int> deletar(int id) async {
    return await (delete(checklistTipoEquipeRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> deletarTodos() async {
    return await delete(checklistTipoEquipeRelacaoTable).go();
  }

  Future<int> contar() async {
    final result = await listar();
    return result.length;
  }
}

