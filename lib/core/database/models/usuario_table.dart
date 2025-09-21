import 'package:drift/drift.dart';

class UsuarioTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().named('remote_id').withLength(min: 1, max: 100)();

  TextColumn get nome => text().withLength(min: 2, max: 100)();
  TextColumn get matricula => text().unique()();
  TextColumn get token => text().nullable()();
  TextColumn get refreshToken => text().nullable()();
  DateTimeColumn get ultimoLogin => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
