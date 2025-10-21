import 'package:drift/drift.dart';

/// Tabela para armazenar checklists preenchidos.
///
/// ⚠️ IMPORTANTE:
/// - turnoId: FK para turno_table.id (ID LOCAL)
/// - checklistModeloId: ID REMOTO do modelo (SEM FK!)
/// - eletricistaRemoteId: ID REMOTO do eletricista (SEM FK!)
class ChecklistPreenchidoTable extends Table {
  /// ID local (autoincrement)
  IntColumn get id => integer().autoIncrement()();

  /// FK para turno_table.id (ID LOCAL)
  IntColumn get turnoId => integer().customConstraint(
      'NOT NULL REFERENCES turno_table(id) ON DELETE CASCADE')();

  /// ID REMOTO do modelo de checklist (SEM FK!)
  IntColumn get checklistModeloId => integer()();

  /// ID REMOTO do eletricista (opcional) - usado para checklists por eletricista (EPI)
  IntColumn get eletricistaRemoteId => integer().nullable()();

  /// Latitude do preenchimento (opcional)
  RealColumn get latitude => real().nullable()();

  /// Longitude do preenchimento (opcional)
  RealColumn get longitude => real().nullable()();

  /// Data e hora do preenchimento
  DateTimeColumn get dataPreenchimento => dateTime().withDefault(currentDateAndTime)();

  List<Set<Column>> get customIndexes => [
        // Buscar checklists de um turno
        {turnoId},
        // Buscar por modelo de checklist
        {checklistModeloId},
        // Buscar checklists de um eletricista
        {eletricistaRemoteId},
        // Ordenar por data
        {dataPreenchimento},
        // Índice composto para evitar duplicatas
        {turnoId, checklistModeloId, eletricistaRemoteId},
      ];
}
