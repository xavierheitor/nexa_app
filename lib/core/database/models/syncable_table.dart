import 'package:drift/drift.dart';

abstract class SyncableTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get remoteId => integer().named('remote_id')();

  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  BoolColumn get sincronizado => boolean().withDefault(const Constant(false))();
}
