import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_pergunta_relacao_table.dart';
import 'package:nexa_app/data/models/checklist_pergunta_relacao_table_dto.dart';

part 'checklist_pergunta_relacao_dao.g.dart';

@DriftAccessor(tables: [ChecklistPerguntaRelacaoTable])
class ChecklistPerguntaRelacaoDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistPerguntaRelacaoDaoMixin {
  ChecklistPerguntaRelacaoDao(super.db);

  // ============================================================================
  // LISTAR
  // ============================================================================

  Future<List<ChecklistPerguntaRelacaoTableDto>> listar() async {
    final result = await select(checklistPerguntaRelacaoTable).get();
    return result.map(ChecklistPerguntaRelacaoTableDto.fromTable).toList();
  }

  // ============================================================================
  // BUSCAR
  // ============================================================================

  Future<ChecklistPerguntaRelacaoTableDto?> buscarPorId(int id) async {
    final result = await (select(checklistPerguntaRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null
        ? ChecklistPerguntaRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<ChecklistPerguntaRelacaoTableDto?> buscarPorRemoteId(
      int remoteId) async {
    final result = await (select(checklistPerguntaRelacaoTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    return result != null
        ? ChecklistPerguntaRelacaoTableDto.fromTable(result)
        : null;
  }

  // ============================================================================
  // INSERIR / ATUALIZAR
  // ============================================================================

  Future<int> inserirOuAtualizar(ChecklistPerguntaRelacaoTableDto dto) async {
    if (dto.remoteId != null) {
      final existente = await buscarPorRemoteId(dto.remoteId!);
      if (existente != null) {
        await atualizar(dto.copyWith(id: existente.id));
        return existente.id;
      }
    }
    return await inserir(dto);
  }

  Future<int> inserir(ChecklistPerguntaRelacaoTableDto dto) async {
    return await into(checklistPerguntaRelacaoTable)
        .insert(dto.toCompanion());
  }

  Future<bool> atualizar(ChecklistPerguntaRelacaoTableDto dto) async {
    return await update(checklistPerguntaRelacaoTable)
        .replace(dto.toCompanion());
  }

  // ============================================================================
  // DELETAR
  // ============================================================================

  Future<int> deletar(int id) async {
    return await (delete(checklistPerguntaRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> deletarTodos() async {
    return await delete(checklistPerguntaRelacaoTable).go();
  }

  // ============================================================================
  // CONTAR
  // ============================================================================

  Future<int> contar() async {
    final result = await listar();
    return result.length;
  }
}

