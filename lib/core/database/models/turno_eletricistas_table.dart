import 'package:drift/drift.dart';

class TurnoEletricistasTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get turnoId => integer()();
  IntColumn get eletricistaId => integer()();
}