import 'package:nexa_app/core/database/app_database.dart';

/// DTO para a tabela TurnoEletricistasTable.
///
/// Representa o relacionamento entre um turno e um eletricista,
/// permitindo que múltiplos eletricistas participem de um turno.
/// Inclui flag para identificar quem é o motorista.
class TurnoEletricistasTableDto {
  final int id;
  final int turnoId;
  final int eletricistaId;
  final bool motorista;

  TurnoEletricistasTableDto({
    required this.id,
    required this.turnoId,
    required this.eletricistaId,
    this.motorista = false,
  });

  /// Cria DTO a partir de uma linha da tabela.
  factory TurnoEletricistasTableDto.fromTable(TurnoEletricistasTableData data) {
    return TurnoEletricistasTableDto(
      id: data.id,
      turnoId: data.turnoId,
      eletricistaId: data.eletricistaId,
      motorista: data.motorista,
    );
  }

  /// Cria uma cópia do DTO com valores alterados.
  TurnoEletricistasTableDto copyWith({
    int? id,
    int? turnoId,
    int? eletricistaId,
    bool? motorista,
  }) {
    return TurnoEletricistasTableDto(
      id: id ?? this.id,
      turnoId: turnoId ?? this.turnoId,
      eletricistaId: eletricistaId ?? this.eletricistaId,
      motorista: motorista ?? this.motorista,
    );
  }

  /// Converte para Map para serialização.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'turnoId': turnoId,
      'eletricistaId': eletricistaId,
      'motorista': motorista,
    };
  }

  /// Cria DTO a partir de Map.
  factory TurnoEletricistasTableDto.fromMap(Map<String, dynamic> map) {
    return TurnoEletricistasTableDto(
      id: map['id']?.toInt() ?? 0,
      turnoId: map['turnoId']?.toInt() ?? 0,
      eletricistaId: map['eletricistaId']?.toInt() ?? 0,
      motorista: map['motorista'] == true || map['motorista'] == 1,
    );
  }

  @override
  String toString() {
    return 'TurnoEletricistasTableDto(id: $id, turnoId: $turnoId, eletricistaId: $eletricistaId, motorista: $motorista)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TurnoEletricistasTableDto &&
        other.id == id &&
        other.turnoId == turnoId &&
        other.eletricistaId == eletricistaId &&
        other.motorista == motorista;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        turnoId.hashCode ^
        eletricistaId.hashCode ^
        motorista.hashCode;
  }
}
