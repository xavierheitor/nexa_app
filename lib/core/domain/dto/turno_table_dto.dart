import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/database/models/turno_table.dart';

/// DTO para a tabela TurnoTable.
///
/// Representa um turno de trabalho com todas as informações necessárias
/// para controle de início, fim, veículo, equipe e situação.
class TurnoTableDto {
  final int id;
  final int? remoteId;
  final int veiculoId;
  final int equipeId;
  final int kmInicial;
  final int? kmFinal;
  final DateTime horaInicio;
  final DateTime? horaFim;
  final String? latitude;
  final String? longitude;
  final SituacaoTurno situacaoTurno;

  TurnoTableDto({
    required this.id,
    this.remoteId,
    required this.veiculoId,
    required this.equipeId,
    required this.kmInicial,
    this.kmFinal,
    required this.horaInicio,
    this.horaFim,
    this.latitude,
    this.longitude,
    required this.situacaoTurno,
  });

  /// Cria DTO a partir de uma linha da tabela.
  factory TurnoTableDto.fromTable(TurnoTableData data) {
    return TurnoTableDto(
      id: data.id,
      remoteId: data.remoteId,
      veiculoId: data.veiculoId,
      equipeId: data.equipeId,
      kmInicial: data.kmInicial,
      kmFinal: data.kmFinal,
      horaInicio: data.horaInicio,
      horaFim: data.horaFim,
      latitude: data.latitude,
      longitude: data.longitude,
      situacaoTurno: data.situacaoTurno,
    );
  }

  /// Cria uma cópia do DTO com valores alterados.
  TurnoTableDto copyWith({
    int? id,
    int? remoteId,
    int? veiculoId,
    int? equipeId,
    int? kmInicial,
    int? kmFinal,
    DateTime? horaInicio,
    DateTime? horaFim,
    String? latitude,
    String? longitude,
    SituacaoTurno? situacaoTurno,
  }) {
    return TurnoTableDto(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      veiculoId: veiculoId ?? this.veiculoId,
      equipeId: equipeId ?? this.equipeId,
      kmInicial: kmInicial ?? this.kmInicial,
      kmFinal: kmFinal ?? this.kmFinal,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFim: horaFim ?? this.horaFim,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      situacaoTurno: situacaoTurno ?? this.situacaoTurno,
    );
  }

  /// Converte para Map para serialização.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'remoteId': remoteId,
      'veiculoId': veiculoId,
      'equipeId': equipeId,
      'kmInicial': kmInicial,
      'kmFinal': kmFinal,
      'horaInicio': horaInicio.toIso8601String(),
      'horaFim': horaFim?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'situacaoTurno': situacaoTurno.name,
    };
  }

  /// Cria DTO a partir de Map.
  factory TurnoTableDto.fromMap(Map<String, dynamic> map) {
    return TurnoTableDto(
      id: map['id']?.toInt() ?? 0,
      remoteId: map['remoteId']?.toInt(),
      veiculoId: map['veiculoId']?.toInt() ?? 0,
      equipeId: map['equipeId']?.toInt() ?? 0,
      kmInicial: map['kmInicial']?.toInt() ?? 0,
      kmFinal: map['kmFinal']?.toInt(),
      horaInicio: DateTime.parse(map['horaInicio']),
      horaFim: map['horaFim'] != null ? DateTime.parse(map['horaFim']) : null,
      latitude: map['latitude'],
      longitude: map['longitude'],
      situacaoTurno: SituacaoTurno.values.firstWhere(
        (e) => e.name == map['situacaoTurno'],
        orElse: () => SituacaoTurno.emAbertura,
      ),
    );
  }

  @override
  String toString() {
    return 'TurnoTableDto(id: $id, remoteId: $remoteId, veiculoId: $veiculoId, equipeId: $equipeId, kmInicial: $kmInicial, kmFinal: $kmFinal, horaInicio: $horaInicio, horaFim: $horaFim, latitude: $latitude, longitude: $longitude, situacaoTurno: $situacaoTurno)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TurnoTableDto &&
        other.id == id &&
        other.remoteId == remoteId &&
        other.veiculoId == veiculoId &&
        other.equipeId == equipeId &&
        other.kmInicial == kmInicial &&
        other.kmFinal == kmFinal &&
        other.horaInicio == horaInicio &&
        other.horaFim == horaFim &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.situacaoTurno == situacaoTurno;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        remoteId.hashCode ^
        veiculoId.hashCode ^
        equipeId.hashCode ^
        kmInicial.hashCode ^
        kmFinal.hashCode ^
        horaInicio.hashCode ^
        horaFim.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        situacaoTurno.hashCode;
  }
}
