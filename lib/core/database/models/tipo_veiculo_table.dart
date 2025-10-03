import 'package:drift/drift.dart';

class TipoVeiculoTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId =>
      text().named('remote_id').withLength(min: 1, max: 100)();

  TextColumn get nome => text().withLength(min: 2, max: 100)();
  TextColumn get descricao => text().nullable().withLength(max: 255)();
}
