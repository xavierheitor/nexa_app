import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class EquipeTable extends SyncableTable {
  TextColumn get nome => text().withLength(min: 2, max: 100)();
  TextColumn get descricao => text().nullable().withLength(max: 255)();

  /// Relacionamento com tipo de equipe (FK para ID LOCAL)
  IntColumn get tipoEquipeId => integer().customConstraint(
      'NOT NULL REFERENCES tipo_equipe_table(id) ON DELETE RESTRICT')();

  List<Set<Column>> get customIndexes => [
        // Índice para buscar equipes por tipo
        {tipoEquipeId},
      ];
}
