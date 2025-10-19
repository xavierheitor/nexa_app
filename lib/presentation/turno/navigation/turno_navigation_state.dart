/// Estados possíveis de navegação do turno.
///
/// Define todos os estados que o fluxo de turno pode assumir,
/// permitindo decisões de navegação baseadas em estado.
enum TurnoNavigationState {
  /// Nenhum turno existe - deve abrir um novo.
  naoExiste,

  /// Turno em processo de abertura - aguardando checklists.
  emAbertura,

  /// Turno totalmente aberto - pode executar serviços.
  aberto,

  /// Turno fechado - não pode ser usado.
  fechado,

  /// Checklist veicular pendente.
  aguardandoChecklistVeicular,

  /// Checklist EPC pendente.
  aguardandoChecklistEPC,

  /// Checklist EPI pendente.
  aguardandoChecklistEPI,

  /// Todos os checklists concluídos - pronto para abrir turno remotamente.
  checklistsConcluidos,

  /// Erro ao determinar estado.
  erro,
}

/// Resultado da verificação de estado do turno.
///
/// Contém informações completas sobre o estado atual do turno
/// e qual deve ser a próxima ação/navegação.
class TurnoNavigationResult {
  /// Estado atual do turno.
  final TurnoNavigationState state;

  /// Rota para navegar (se aplicável).
  final String? route;

  /// Argumentos da rota (se aplicável).
  final Map<String, dynamic>? arguments;

  /// Mensagem descritiva do estado.
  final String message;

  /// Se deve mostrar snackbar.
  final bool showSnackbar;

  /// Dados adicionais (ex: turno, eletricistas).
  final Map<String, dynamic>? data;

  const TurnoNavigationResult({
    required this.state,
    this.route,
    this.arguments,
    required this.message,
    this.showSnackbar = false,
    this.data,
  });

  /// Cria resultado para quando não há turno.
  factory TurnoNavigationResult.naoExiste() {
    return const TurnoNavigationResult(
      state: TurnoNavigationState.naoExiste,
      message: 'Nenhum turno ativo encontrado',
    );
  }

  /// Cria resultado para erro.
  factory TurnoNavigationResult.erro(String mensagem) {
    return TurnoNavigationResult(
      state: TurnoNavigationState.erro,
      message: mensagem,
      showSnackbar: true,
    );
  }

  @override
  String toString() {
    return 'TurnoNavigationResult(state: $state, route: $route, message: $message)';
  }
}

