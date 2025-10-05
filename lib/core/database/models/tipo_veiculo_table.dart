import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class TipoVeiculoTable extends SyncableTable {
  TextColumn get nome => text().withLength(min: 2, max: 100)();
  TextColumn get descricao => text().nullable().withLength(max: 255)();
}
