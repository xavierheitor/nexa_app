/// Model completo de um Checklist com suas perguntas e opções de resposta.
class ChecklistCompletoModel {
  final int id;
  final int remoteId;
  final String nome;
  final int tipoChecklistId;
  final List<ChecklistPerguntaModel> perguntas;

  ChecklistCompletoModel({
    required this.id,
    required this.remoteId,
    required this.nome,
    required this.tipoChecklistId,
    required this.perguntas,
  });

  ChecklistCompletoModel copyWith({
    int? id,
    int? remoteId,
    String? nome,
    int? tipoChecklistId,
    List<ChecklistPerguntaModel>? perguntas,
  }) {
    return ChecklistCompletoModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      tipoChecklistId: tipoChecklistId ?? this.tipoChecklistId,
      perguntas: perguntas ?? this.perguntas,
    );
  }
}

/// Model de uma pergunta do checklist.
class ChecklistPerguntaModel {
  final int id;
  final int remoteId;
  final String nome;
  final List<ChecklistOpcaoRespostaModel> opcoes;
  final int? respostaSelecionada; // ID da opção selecionada

  ChecklistPerguntaModel({
    required this.id,
    required this.remoteId,
    required this.nome,
    required this.opcoes,
    this.respostaSelecionada,
  });

  ChecklistPerguntaModel copyWith({
    int? id,
    int? remoteId,
    String? nome,
    List<ChecklistOpcaoRespostaModel>? opcoes,
    int? respostaSelecionada,
  }) {
    return ChecklistPerguntaModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      opcoes: opcoes ?? this.opcoes,
      respostaSelecionada: respostaSelecionada ?? this.respostaSelecionada,
    );
  }

  /// Verifica se a pergunta foi respondida.
  bool get foiRespondida => respostaSelecionada != null;

  /// Busca a opção selecionada.
  ChecklistOpcaoRespostaModel? get opcaoSelecionada {
    if (respostaSelecionada == null) return null;
    try {
      return opcoes.firstWhere((op) => op.id == respostaSelecionada);
    } catch (_) {
      return null;
    }
  }
}

/// Model de uma opção de resposta.
class ChecklistOpcaoRespostaModel {
  final int id;
  final int remoteId;
  final String nome;
  final bool geraPendencia;

  ChecklistOpcaoRespostaModel({
    required this.id,
    required this.remoteId,
    required this.nome,
    required this.geraPendencia,
  });

  ChecklistOpcaoRespostaModel copyWith({
    int? id,
    int? remoteId,
    String? nome,
    bool? geraPendencia,
  }) {
    return ChecklistOpcaoRespostaModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      nome: nome ?? this.nome,
      geraPendencia: geraPendencia ?? this.geraPendencia,
    );
  }
}

