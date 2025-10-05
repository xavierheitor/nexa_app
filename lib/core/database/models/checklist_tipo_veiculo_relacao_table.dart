import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class ChecklistTipoVeiculoRelacaoTable extends SyncableTable {
  IntColumn get checklistModeloId => integer()();
  IntColumn get tipoVeiculoId => integer()();
}