import 'package:drift/drift.dart';

class VeiculoTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId =>
      text().named('remote_id').withLength(min: 1, max: 100)();

  TextColumn get placa => text().withLength(min: 7, max: 8)();


  // Relacionamento com tipo de veículo
  IntColumn get tipoVeiculoId => integer()();

}
