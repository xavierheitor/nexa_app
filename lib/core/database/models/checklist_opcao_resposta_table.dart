import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class ChecklistOpcaoRespostaTable extends SyncableTable {
  TextColumn get nome => text().withLength(min: 2, max: 100)();
  BoolColumn get geraPendencia => boolean()();
}