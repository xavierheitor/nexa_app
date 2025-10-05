import 'package:drift/drift.dart';

/// Tabela para armazenar checklists preenchidos
class ChecklistPreenchidoTable extends Table {
  /// ID local (autoincrement)
  IntColumn get id => integer().autoIncrement()();

  /// ID local do turno
  IntColumn get turnoId => integer()();

  /// ID remoto do modelo de checklist
  IntColumn get checklistModeloId => integer()();

  /// Latitude do preenchimento (opcional)
  RealColumn get latitude => real().nullable()();

  /// Longitude do preenchimento (opcional)
  RealColumn get longitude => real().nullable()();

  /// Data e hora do preenchimento
  DateTimeColumn get dataPreenchimento => dateTime().withDefault(currentDateAndTime)();

  /// Relacionamento com turno
  // @override
  // Set<Column> get primaryKey => {id};

  /// Índices para melhor performance
  List<Set<Column>> get indexes => [
        {turnoId},
        {checklistModeloId},
        {dataPreenchimento},
      ];
}
