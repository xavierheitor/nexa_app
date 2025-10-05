import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_opcao_resposta_relacao_table.dart';
import 'package:nexa_app/core/domain/dto/checklist_opcao_resposta_relacao_table_dto.dart';

part 'checklist_opcao_resposta_relacao_dao.g.dart';

@DriftAccessor(tables: [ChecklistOpcaoRespostaRelacaoTable])
class ChecklistOpcaoRespostaRelacaoDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistOpcaoRespostaRelacaoDaoMixin {
  ChecklistOpcaoRespostaRelacaoDao(AppDatabase db) : super(db);

  Future<List<ChecklistOpcaoRespostaRelacaoTableDto>> listar() async {
    final result = await select(checklistOpcaoRespostaRelacaoTable).get();
    return result
        .map(ChecklistOpcaoRespostaRelacaoTableDto.fromTable)
        .toList();
  }

  Future<ChecklistOpcaoRespostaRelacaoTableDto?> buscarPorId(int id) async {
    final result = await (select(checklistOpcaoRespostaRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null
        ? ChecklistOpcaoRespostaRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<ChecklistOpcaoRespostaRelacaoTableDto?> buscarPorRemoteId(
      int remoteId) async {
    final result = await (select(checklistOpcaoRespostaRelacaoTable)
          ..where((t) => t.remoteId.equals(remoteId)))
        .getSingleOrNull();
    return result != null
        ? ChecklistOpcaoRespostaRelacaoTableDto.fromTable(result)
        : null;
  }

  Future<int> inserirOuAtualizar(
      ChecklistOpcaoRespostaRelacaoTableDto dto) async {
    if (dto.remoteId != null) {
      final existente = await buscarPorRemoteId(dto.remoteId!);
      if (existente != null) {
        await atualizar(dto.copyWith(id: existente.id));
        return existente.id;
      }
    }
    return await inserir(dto);
  }

  Future<int> inserir(ChecklistOpcaoRespostaRelacaoTableDto dto) async {
    return await into(checklistOpcaoRespostaRelacaoTable)
        .insert(dto.toCompanion());
  }

  Future<bool> atualizar(ChecklistOpcaoRespostaRelacaoTableDto dto) async {
    return await update(checklistOpcaoRespostaRelacaoTable)
        .replace(dto.toCompanion());
  }

  Future<int> deletar(int id) async {
    return await (delete(checklistOpcaoRespostaRelacaoTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> deletarTodos() async {
    return await delete(checklistOpcaoRespostaRelacaoTable).go();
  }

  Future<int> contar() async {
    final result = await listar();
    return result.length;
  }
}

