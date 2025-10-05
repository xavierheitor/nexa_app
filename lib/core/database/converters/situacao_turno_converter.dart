import 'package:drift/drift.dart';

/// Enum para representar as situações possíveis de um turno.
enum SituacaoTurno {
  /// Turno está aberto e ativo.
  aberto,

  /// Turno foi fechado/finalizado.
  fechado,

  /// Turno está em processo de abertura.
  emAbertura,
}

/// Converter para transformar enum SituacaoTurno em String para o banco de dados.
///
/// Este converter permite que o Drift armazene o enum SituacaoTurno
/// como String no banco de dados SQLite, facilitando a persistência
/// e recuperação dos dados.
///
/// ## Funcionalidades:
/// - Conversão de enum para String (toSql)
/// - Conversão de String para enum (fromSql)
/// - Fallback seguro para valores inválidos
/// - Tratamento de erros robusto
class SituacaoTurnoConverter extends TypeConverter<SituacaoTurno, String> {
  const SituacaoTurnoConverter();

  @override
  SituacaoTurno fromSql(String fromDb) {
    return SituacaoTurno.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => SituacaoTurno.emAbertura, // fallback seguro
    );
  }

  @override
  String toSql(SituacaoTurno value) => value.name;
}
