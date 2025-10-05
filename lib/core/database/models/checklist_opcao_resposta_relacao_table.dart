import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class ChecklistOpcaoRespostaRelacaoTable extends SyncableTable {
  IntColumn get checklistOpcaoRespostaId => integer()();
  IntColumn get checklistModeloId => integer()();
}