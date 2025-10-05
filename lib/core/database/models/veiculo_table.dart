import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class VeiculoTable extends SyncableTable {
  TextColumn get placa => text().withLength(min: 7, max: 8)();

  // Relacionamento com tipo de veículo
  IntColumn get tipoVeiculoId => integer()();
}
