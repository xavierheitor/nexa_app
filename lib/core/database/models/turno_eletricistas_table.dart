import 'package:drift/drift.dart';

/// Tabela de junção entre Turno e Eletricistas.
///
/// ⚠️ IMPORTANTE:
/// - turnoId: FK para turno_table.id (ID LOCAL)
/// - eletricistaId: ID REMOTO do eletricista (SEM FK!)
///   Armazena o remote_id porque é enviado para API na abertura do turno.
class TurnoEletricistasTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK para turno_table.id (ID LOCAL)
  IntColumn get turnoId => integer().customConstraint(
      'NOT NULL REFERENCES turno_table(id) ON DELETE CASCADE')();

  /// ID REMOTO do eletricista (SEM FK!)
  /// Armazena o remote_id do eletricista para enviar para API.
  IntColumn get eletricistaId => integer()();

  BoolColumn get motorista => boolean().withDefault(const Constant(false))();

  List<Set<Column>> get customIndexes => [
        // Buscar eletricistas de um turno (query frequente)
        {turnoId},
        // Buscar turnos de um eletricista
        {eletricistaId},
        // Prevenir duplicatas: um eletricista só pode estar uma vez por turno
        {turnoId, eletricistaId},
      ];
}
