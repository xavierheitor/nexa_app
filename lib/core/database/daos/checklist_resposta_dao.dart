import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/database/models/checklist_resposta_table.dart';
import 'package:nexa_app/core/domain/dto/checklist_resposta_table_dto.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';

part 'checklist_resposta_dao.g.dart';

@DriftAccessor(tables: [ChecklistRespostaTable])
class ChecklistRespostaDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistRespostaDaoMixin {
  ChecklistRespostaDao(super.db);

  /// Lista todas as respostas
  Future<List<ChecklistRespostaTableDto>> listar() async {
    AppLogger.d('Listando todas as respostas', tag: 'ChecklistRespostaDao');

    final results = await select(checklistRespostaTable).get();
    return results
        .map((row) => ChecklistRespostaTableDto.fromEntity(row))
        .toList();
  }

  /// Busca resposta por ID
  Future<ChecklistRespostaTableDto?> buscarPorId(int id) async {
    AppLogger.d('Buscando resposta por ID: $id', tag: 'ChecklistRespostaDao');

    try {
      final result = await (select(checklistRespostaTable)
            ..where((r) => r.id.equals(id)))
          .getSingleOrNull();

      if (result == null) {
        AppLogger.w('Resposta não encontrada para ID: $id',
            tag: 'ChecklistRespostaDao');
        return null;
      }

      return ChecklistRespostaTableDto.fromEntity(result);
    } catch (e) {
      AppLogger.e('Erro ao buscar resposta por ID: $e',
          tag: 'ChecklistRespostaDao');
      return null;
    }
  }

  /// Busca respostas por checklist preenchido
  Future<List<ChecklistRespostaTableDto>> buscarPorChecklistPreenchido(
      int checklistPreenchidoId) async {
    AppLogger.d(
        'Buscando respostas por checklist preenchido: $checklistPreenchidoId',
        tag: 'ChecklistRespostaDao');

    final results = await (select(checklistRespostaTable)
          ..where((r) => r.checklistPreenchidoId.equals(checklistPreenchidoId))
          ..orderBy([(r) => OrderingTerm.asc(r.perguntaId)]))
        .get();

    return results
        .map((row) => ChecklistRespostaTableDto.fromEntity(row))
        .toList();
  }

  /// Busca resposta por pergunta
  Future<ChecklistRespostaTableDto?> buscarPorPergunta(
      int checklistPreenchidoId, int perguntaId) async {
    AppLogger.d('Buscando resposta por pergunta: $perguntaId',
        tag: 'ChecklistRespostaDao');

    try {
      final result = await (select(checklistRespostaTable)
            ..where((r) =>
                r.checklistPreenchidoId.equals(checklistPreenchidoId) &
                r.perguntaId.equals(perguntaId)))
          .getSingleOrNull();

      if (result == null) {
        AppLogger.w('Resposta não encontrada para pergunta: $perguntaId',
            tag: 'ChecklistRespostaDao');
        return null;
      }

      return ChecklistRespostaTableDto.fromEntity(result);
    } catch (e) {
      AppLogger.e('Erro ao buscar resposta por pergunta: $e',
          tag: 'ChecklistRespostaDao');
      return null;
    }
  }

  /// Insere uma nova resposta
  Future<int> inserir(ChecklistRespostaTableDto dto) async {
    AppLogger.d('Inserindo resposta para pergunta: ${dto.perguntaId}',
        tag: 'ChecklistRespostaDao');

    try {
      final companion = dto.toCompanion();
      final id = await into(checklistRespostaTable).insert(companion);

      AppLogger.i('Resposta inserida com ID: $id', tag: 'ChecklistRespostaDao');
      return id;
    } catch (e) {
      AppLogger.e('Erro ao inserir resposta: $e', tag: 'ChecklistRespostaDao');
      rethrow;
    }
  }

  /// Insere múltiplas respostas
  Future<List<int>> inserirMultiplos(
      List<ChecklistRespostaTableDto> dtos) async {
    AppLogger.d('Inserindo ${dtos.length} respostas',
        tag: 'ChecklistRespostaDao');

    try {
      final companions = dtos.map((dto) => dto.toCompanion()).toList();
      final ids = <int>[];

      for (final companion in companions) {
        final id = await into(checklistRespostaTable).insert(companion);
        ids.add(id);
      }

      AppLogger.i('${ids.length} respostas inseridas',
          tag: 'ChecklistRespostaDao');
      return ids;
    } catch (e) {
      AppLogger.e('Erro ao inserir múltiplas respostas: $e',
          tag: 'ChecklistRespostaDao');
      rethrow;
    }
  }

  /// Atualiza uma resposta
  Future<bool> atualizar(ChecklistRespostaTableDto dto) async {
    AppLogger.d('Atualizando resposta ID: ${dto.id}',
        tag: 'ChecklistRespostaDao');

    try {
      final companion = dto.toCompanion();
      final updated = await update(checklistRespostaTable).replace(companion);

      AppLogger.i('Resposta atualizada: $updated', tag: 'ChecklistRespostaDao');
      return updated;
    } catch (e) {
      AppLogger.e('Erro ao atualizar resposta: $e',
          tag: 'ChecklistRespostaDao');
      return false;
    }
  }

  /// Remove uma resposta
  Future<bool> remover(int id) async {
    AppLogger.d('Removendo resposta ID: $id', tag: 'ChecklistRespostaDao');

    try {
      final deleted = await (delete(checklistRespostaTable)
            ..where((r) => r.id.equals(id)))
          .go();

      AppLogger.i('Resposta removida: $deleted', tag: 'ChecklistRespostaDao');
      return deleted > 0;
    } catch (e) {
      AppLogger.e('Erro ao remover resposta: $e', tag: 'ChecklistRespostaDao');
      return false;
    }
  }

  /// Remove todas as respostas de um checklist preenchido
  Future<bool> removerPorChecklistPreenchido(int checklistPreenchidoId) async {
    AppLogger.d(
        'Removendo respostas do checklist preenchido: $checklistPreenchidoId',
        tag: 'ChecklistRespostaDao');

    try {
      final deleted = await (delete(checklistRespostaTable)
            ..where(
                (r) => r.checklistPreenchidoId.equals(checklistPreenchidoId)))
          .go();

      AppLogger.i('$deleted respostas removidas', tag: 'ChecklistRespostaDao');
      return deleted > 0;
    } catch (e) {
      AppLogger.e('Erro ao remover respostas do checklist: $e',
          tag: 'ChecklistRespostaDao');
      return false;
    }
  }

  /// Conta respostas por checklist preenchido
  Future<int> contarPorChecklistPreenchido(int checklistPreenchidoId) async {
    AppLogger.d(
        'Contando respostas por checklist preenchido: $checklistPreenchidoId',
        tag: 'ChecklistRespostaDao');

    final result = await (selectOnly(checklistRespostaTable)
          ..addColumns([checklistRespostaTable.id.count()])
          ..where(checklistRespostaTable.checklistPreenchidoId
              .equals(checklistPreenchidoId)))
        .getSingle();

    return result.read(checklistRespostaTable.id.count()) ?? 0;
  }

  /// Verifica se existe resposta para uma pergunta
  Future<bool> existeRespostaParaPergunta(
      int checklistPreenchidoId, int perguntaId) async {
    AppLogger.d('Verificando se existe resposta para pergunta: $perguntaId',
        tag: 'ChecklistRespostaDao');

    final result = await (selectOnly(checklistRespostaTable)
          ..addColumns([checklistRespostaTable.id.count()])
          ..where(checklistRespostaTable.checklistPreenchidoId
                  .equals(checklistPreenchidoId) &
              checklistRespostaTable.perguntaId.equals(perguntaId)))
        .getSingle();

    final count = result.read(checklistRespostaTable.id.count()) ?? 0;
    return count > 0;
  }
}
