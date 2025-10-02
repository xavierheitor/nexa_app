import 'package:drift/drift.dart';

class TipoVeiculoTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().named('remote_id').withLength(min: 1, max: 100)();
  
  TextColumn get nome => text().withLength(min: 2, max: 100)();
  TextColumn get descricao => text().nullable().withLength(max: 255)();
  
  // Campos de auditoria
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get createdBy => text().nullable().withLength(max: 100)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get updatedBy => text().nullable().withLength(max: 100)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get deletedBy => text().nullable().withLength(max: 100)();
}