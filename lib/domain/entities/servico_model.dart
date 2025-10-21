/// Modelo para representação de um serviço executado no turno.
class ServicoModel {
  final String id;
  final String descricao;
  final DateTime horario;
  final TipoServico tipo;

  ServicoModel({
    required this.id,
    required this.descricao,
    required this.horario,
    required this.tipo,
  });

  /// Cria cópia com campos opcionais atualizados.
  ServicoModel copyWith({
    String? id,
    String? descricao,
    DateTime? horario,
    TipoServico? tipo,
  }) {
    return ServicoModel(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      horario: horario ?? this.horario,
      tipo: tipo ?? this.tipo,
    );
  }

  /// Converte para Map (para serialização).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'horario': horario.toIso8601String(),
      'tipo': tipo.name,
    };
  }

  /// Cria instância a partir de Map.
  factory ServicoModel.fromMap(Map<String, dynamic> map) {
    return ServicoModel(
      id: map['id'] as String,
      descricao: map['descricao'] as String,
      horario: DateTime.parse(map['horario'] as String),
      tipo: TipoServico.values.firstWhere(
        (t) => t.name == map['tipo'],
        orElse: () => TipoServico.outro,
      ),
    );
  }
}

/// Tipos de serviços disponíveis.
enum TipoServico {
  coleta,
  limpeza,
  manutencao,
  outro,
}

/// Extensão para obter nome legível do tipo de serviço.
extension TipoServicoExtension on TipoServico {
  String get nome {
    switch (this) {
      case TipoServico.coleta:
        return 'Coleta';
      case TipoServico.limpeza:
        return 'Limpeza';
      case TipoServico.manutencao:
        return 'Manutenção';
      case TipoServico.outro:
        return 'Outro';
    }
  }
}

