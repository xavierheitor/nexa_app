/// Modelo de dados para representação de um turno.
///
/// Esta classe encapsula todas as informações relacionadas a um turno
/// de trabalho, incluindo horários, veículo associado e status.
///
/// ## Propriedades:
/// - `id`: Identificador único do turno
/// - `prefixo`: Prefixo do veículo (ex: "01", "A123")
/// - `veiculo`: Nome/modelo do veículo
/// - `placa`: Placa do veículo
/// - `horaInicio`: Horário de início do turno
/// - `horaFim`: Horário previsto de fim do turno (opcional)
/// - `status`: Status atual do turno (aberto, fechado, pausado)
class TurnoModel {
  /// Identificador único do turno.
  final String id;

  /// Prefixo do veículo.
  final String prefixo;

  /// Nome/modelo do veículo.
  final String veiculo;

  /// Placa do veículo.
  final String placa;

  /// Horário de início do turno.
  final DateTime horaInicio;

  /// Horário de fim do turno (opcional).
  final DateTime? horaFim;

  /// Status do turno.
  final StatusTurno status;

  /// Construtor do modelo de turno.
  TurnoModel({
    required this.id,
    required this.prefixo,
    required this.veiculo,
    required this.placa,
    required this.horaInicio,
    this.horaFim,
    this.status = StatusTurno.aberto,
  });

  /// Verifica se o turno está aberto.
  bool get estaAberto => status == StatusTurno.aberto;

  /// Verifica se o turno está fechado.
  bool get estaFechado => status == StatusTurno.fechado;

  /// Calcula duração do turno.
  Duration get duracao {
    final fim = horaFim ?? DateTime.now();
    return fim.difference(horaInicio);
  }

  /// Cria uma cópia do turno com campos atualizados.
  TurnoModel copyWith({
    String? id,
    String? prefixo,
    String? veiculo,
    String? placa,
    DateTime? horaInicio,
    DateTime? horaFim,
    StatusTurno? status,
  }) {
    return TurnoModel(
      id: id ?? this.id,
      prefixo: prefixo ?? this.prefixo,
      veiculo: veiculo ?? this.veiculo,
      placa: placa ?? this.placa,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFim: horaFim ?? this.horaFim,
      status: status ?? this.status,
    );
  }

  /// Converte o modelo para JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prefixo': prefixo,
      'veiculo': veiculo,
      'placa': placa,
      'horaInicio': horaInicio.toIso8601String(),
      'horaFim': horaFim?.toIso8601String(),
      'status': status.name,
    };
  }

  /// Cria um modelo a partir de JSON.
  factory TurnoModel.fromJson(Map<String, dynamic> json) {
    return TurnoModel(
      id: json['id'] as String,
      prefixo: json['prefixo'] as String,
      veiculo: json['veiculo'] as String,
      placa: json['placa'] as String,
      horaInicio: DateTime.parse(json['horaInicio'] as String),
      horaFim: json['horaFim'] != null
          ? DateTime.parse(json['horaFim'] as String)
          : null,
      status: StatusTurno.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StatusTurno.aberto,
      ),
    );
  }
}

/// Status possíveis de um turno.
enum StatusTurno {
  /// Turno está aberto e ativo.
  aberto,

  /// Turno foi fechado/finalizado.
  fechado,

  /// Turno está pausado.
  pausado,
}

