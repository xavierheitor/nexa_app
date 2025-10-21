import 'package:drift/drift.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';

/// Tabela para armazenar informações dos turnos de trabalho.
///
/// Cada turno representa um período de trabalho com:
/// - Veículo e equipe associados
/// - Quilometragem inicial e final
/// - Horários de início e fim
/// - Localização (latitude/longitude)
/// - Situação atual do turno
class TurnoTable extends Table {
  /// ID único local (chave primária).
  IntColumn get id => integer().autoIncrement()();

  /// ID remoto do servidor (pode ser nulo se ainda não sincronizado).
  IntColumn get remoteId => integer().named('remote_id').nullable()();

  /// ID do veículo utilizado no turno (FK para veiculo_table.id LOCAL).
  IntColumn get veiculoId => integer().customConstraint(
      'NOT NULL REFERENCES veiculo_table(id) ON DELETE RESTRICT')();

  /// ID da equipe responsável pelo turno (FK para equipe_table.id LOCAL).
  IntColumn get equipeId => integer().customConstraint(
      'NOT NULL REFERENCES equipe_table(id) ON DELETE RESTRICT')();

  /// Quilometragem inicial do veículo.
  IntColumn get kmInicial => integer()();

  /// Quilometragem final do veículo (nula até o fechamento do turno).
  IntColumn get kmFinal => integer().nullable()();

  /// Data e hora de início do turno.
  DateTimeColumn get horaInicio => dateTime()();

  /// Data e hora de fim do turno (nula até o fechamento).
  DateTimeColumn get horaFim => dateTime().nullable()();

  /// Latitude da localização de início do turno.
  TextColumn get latitude => text().nullable()();

  /// Longitude da localização de início do turno.
  TextColumn get longitude => text().nullable()();

  /// Situação atual do turno (usando converter personalizado).
  TextColumn get situacaoTurno => text().map(const SituacaoTurnoConverter())();

  List<Set<Column>> get customIndexes => [
        // Query mais frequente: buscar turno ativo
        {situacaoTurno},
        // Buscar turnos por veículo ativo
        {veiculoId, situacaoTurno},
        // Buscar turnos por equipe
        {equipeId},
        // Buscar turno por remote_id na sincronização
        {remoteId},
      ];
}
