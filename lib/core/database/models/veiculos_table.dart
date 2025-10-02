import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class VeiculosTable extends SyncableTable {
  TextColumn get placa => text().named('placa')();
  IntColumn get tipoVeiculoId => integer().named('tipo_veiculo_id')();
}
