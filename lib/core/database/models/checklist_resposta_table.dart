import 'package:drift/drift.dart';

/// Tabela para armazenar respostas individuais do checklist
class ChecklistRespostaTable extends Table {
  /// ID local (autoincrement)
  IntColumn get id => integer().autoIncrement()();

  /// ID do checklist preenchido (FK)
  IntColumn get checklistPreenchidoId => integer()();

  /// ID remoto da pergunta
  IntColumn get perguntaId => integer()();

  /// ID remoto da opção de resposta escolhida
  IntColumn get opcaoRespostaId => integer()();

  /// Data e hora da resposta
  DateTimeColumn get dataResposta => dateTime().withDefault(currentDateAndTime)();

  /// Relacionamento com checklist preenchido
  // @override
  // Set<Column> get primaryKey => {id};

  /// Índices para melhor performance
  List<Set<Column>> get indexes => [
        {checklistPreenchidoId},
        {perguntaId},
        {opcaoRespostaId},
      ];
}
