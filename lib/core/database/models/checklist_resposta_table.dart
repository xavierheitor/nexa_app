import 'package:drift/drift.dart';

/// Tabela para armazenar respostas individuais do checklist.
///
/// ⚠️ IMPORTANTE:
/// - checklistPreenchidoId: FK para checklist_preenchido_table.id (ID LOCAL)
/// - perguntaId: ID REMOTO da pergunta (SEM FK!)
/// - opcaoRespostaId: ID REMOTO da opção (SEM FK!)
class ChecklistRespostaTable extends Table {
  /// ID local (autoincrement)
  IntColumn get id => integer().autoIncrement()();

  /// FK para checklist_preenchido_table.id (ID LOCAL)
  IntColumn get checklistPreenchidoId => integer().customConstraint(
      'NOT NULL REFERENCES checklist_preenchido_table(id) ON DELETE CASCADE')();

  /// ID REMOTO da pergunta (SEM FK!)
  IntColumn get perguntaId => integer()();

  /// ID REMOTO da opção de resposta escolhida (SEM FK!)
  IntColumn get opcaoRespostaId => integer()();

  /// Data e hora da resposta
  DateTimeColumn get dataResposta => dateTime().withDefault(currentDateAndTime)();

  List<Set<Column>> get customIndexes => [
        // Buscar respostas de um checklist (query mais frequente)
        {checklistPreenchidoId},
        // Buscar por pergunta
        {perguntaId},
        // Buscar por opção de resposta
        {opcaoRespostaId},
        // Índice único composto: uma resposta por checklist+pergunta
        {checklistPreenchidoId, perguntaId},
      ];
}
