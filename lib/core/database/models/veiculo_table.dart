import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/models/syncable_table.dart';

class VeiculoTable extends SyncableTable {
  TextColumn get placa => text().withLength(min: 7, max: 8)();

  /// Relacionamento com tipo de veículo (FK para ID LOCAL)
  IntColumn get tipoVeiculoId => integer().customConstraint(
      'NOT NULL REFERENCES tipo_veiculo_table(id) ON DELETE RESTRICT')();

  List<Set<Column>> get customIndexes => [
        // Índice para buscar veículos por tipo
        {tipoVeiculoId},
        // Índice único para placa
        {placa},
      ];
}
