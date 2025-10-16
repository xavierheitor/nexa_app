import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_state.dart';
import 'package:nexa_app/routes/routes.dart';

/// Orquestrador inteligente de navegação no fluxo de turnos.
///
/// Este serviço centraliza toda a lógica de decisão de navegação
/// baseada no estado atual do turno, evitando múltiplas navegações
/// desnecessárias e proporcionando uma experiência fluida.
///
/// ## Responsabilidades:
///
/// 1. **Verificar Estado do Turno**: Determina em que ponto do fluxo está
/// 2. **Decidir Navegação**: Define para onde navegar baseado no estado
/// 3. **Validar Checklists**: Verifica quais checklists foram preenchidos
/// 4. **Otimizar Performance**: Evita verificações redundantes
///
/// ## Fluxo de Decisão:
///
/// ```
/// Verificar Turno Existe?
///   ├─ Não → [ABRIR TURNO]
///   └─ Sim → Verificar Situação
///        ├─ FECHADO → [ABRIR TURNO]
///        ├─ EM_ABERTURA → Verificar Checklists
///        │    ├─ Veicular pendente → [CHECKLIST VEICULAR]
///        │    ├─ EPC pendente → [CHECKLIST EPC]
///        │    ├─ EPI pendente → [CHECKLIST EPI]
///        │    └─ Todos OK → [ABRIR TURNO REMOTO]
///        └─ ABERTO → [SERVIÇOS]
/// ```
///
/// ## Uso:
///
/// ```dart
/// final orchestrator = TurnoNavigationOrchestrator(
///   turnoRepo: turnoRepo,
///   checklistService: checklistService,
/// );
///
/// final result = await orchestrator.determinarProximaRota();
/// if (result.route != null) {
///   Get.toNamed(result.route!, arguments: result.arguments);
/// }
/// ```
class TurnoNavigationOrchestrator {
  final TurnoRepo _turnoRepo;
  final ChecklistService _checklistService;

  TurnoNavigationOrchestrator({
    required TurnoRepo turnoRepo,
    required ChecklistService checklistService,
  })  : _turnoRepo = turnoRepo,
        _checklistService = checklistService;

  /// Determina a próxima rota baseada no estado atual do turno.
  ///
  /// Este é o método principal que orquestra toda a lógica de decisão.
  /// Realiza todas as verificações necessárias e retorna um resultado
  /// completo com a rota, argumentos e mensagens.
  ///
  /// ## Retorno:
  /// - [TurnoNavigationResult] com todas as informações de navegação
  ///
  /// ## Exceções:
  /// - Não lança exceções, retorna erro no resultado
  Future<TurnoNavigationResult> determinarProximaRota() async {
    try {
      AppLogger.d('🧭 [NAV] Iniciando determinação de rota',
          tag: 'TurnoNavigationOrchestrator');

      // 1. Verificar se existe turno ativo
      final turno = await _turnoRepo.buscarTurnoAtivo();

      if (turno == null) {
        AppLogger.d('🧭 [NAV] Nenhum turno ativo → Rota: ABRIR TURNO',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.naoExiste,
          route: Routes.turnoAbrir,
          message: 'Nenhum turno ativo. Abrir novo turno.',
        );
      }

      AppLogger.d(
          '🧭 [NAV] Turno encontrado: ID=${turno.id}, Situação=${turno.situacaoTurno.name}',
          tag: 'TurnoNavigationOrchestrator');

      // 2. Verificar situação do turno
      switch (turno.situacaoTurno) {
        case SituacaoTurno.fechado:
          AppLogger.d('🧭 [NAV] Turno fechado → Rota: ABRIR TURNO',
              tag: 'TurnoNavigationOrchestrator');
          return TurnoNavigationResult(
            state: TurnoNavigationState.fechado,
            route: Routes.turnoAbrir,
            message: 'Turno anterior fechado. Abrir novo turno.',
          );

        case SituacaoTurno.aberto:
          AppLogger.d('🧭 [NAV] Turno aberto → Rota: SERVIÇOS',
              tag: 'TurnoNavigationOrchestrator');
          return TurnoNavigationResult(
            state: TurnoNavigationState.aberto,
            route: Routes.turnoServicos,
            message: 'Turno em execução.',
            data: {'turnoId': turno.id},
          );

        case SituacaoTurno.emAbertura:
          // 3. Turno em abertura - verificar checklists pendentes
          return await _verificarChecklistsPendentes(turno.id);
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ [NAV] Erro ao determinar rota',
          tag: 'TurnoNavigationOrchestrator',
          error: e,
          stackTrace: stackTrace);
      return TurnoNavigationResult.erro(
          'Erro ao determinar próxima ação: ${e.toString()}');
    }
  }

  /// Verifica quais checklists ainda estão pendentes.
  ///
  /// Realiza verificações em ordem de precedência:
  /// 1. Checklist Veicular
  /// 2. Checklist EPC
  /// 3. Checklist EPI (para cada eletricista)
  ///
  /// ## Retorno:
  /// - Rota do primeiro checklist pendente encontrado
  /// - Se todos OK: rota para abrir turno remotamente
  Future<TurnoNavigationResult> _verificarChecklistsPendentes(
      int turnoId) async {
    try {
      AppLogger.d('🧭 [NAV] Verificando checklists pendentes para turno $turnoId',
          tag: 'TurnoNavigationOrchestrator');

      // 1. Verificar Checklist Veicular
      final checklistVeicularRemoteId = ApiConstants.tipoChecklistVeicularId;
      final checklistVeicularCompleto =
          await _checklistService.checklistJaPreenchido(
        checklistVeicularRemoteId,
      );

      if (!checklistVeicularCompleto) {
        AppLogger.d('🧭 [NAV] Checklist Veicular pendente → Rota: CHECKLIST',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.aguardandoChecklistVeicular,
          route: Routes.turnoChecklist,
          message: 'Checklist veicular pendente.',
        );
      }

      AppLogger.d('✅ [NAV] Checklist Veicular OK',
          tag: 'TurnoNavigationOrchestrator');

      // 2. Verificar Checklist EPC
      final checklistEPCRemoteId = ApiConstants.tipoChecklistEpcId;
      final checklistEPCCompleto =
          await _checklistService.checklistJaPreenchido(checklistEPCRemoteId);

      if (!checklistEPCCompleto) {
        AppLogger.d('🧭 [NAV] Checklist EPC pendente → Rota: CHECKLIST EPC',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.aguardandoChecklistEPC,
          route: Routes.turnoChecklistEPC,
          message: 'Checklist EPC pendente.',
        );
      }

      AppLogger.d('✅ [NAV] Checklist EPC OK',
          tag: 'TurnoNavigationOrchestrator');

      // 3. Verificar Checklist EPI (eletricistas)
      final eletricistas = await _turnoRepo.buscarEletricistasDoTurno(turnoId);

      if (eletricistas.isEmpty) {
        AppLogger.w('⚠️ [NAV] Nenhum eletricista vinculado ao turno',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.erro,
          route: Routes.home,
          message: 'Nenhum eletricista vinculado ao turno.',
          showSnackbar: true,
        );
      }

      // Verificar se todos os eletricistas preencheram EPI
      final checklistEpiRemoteId =
          _checklistService.checklistEpiModeloRemoteId;

      for (final eletricista in eletricistas) {
        final epiPreenchido = await _checklistService.checklistJaPreenchido(
          checklistEpiRemoteId,
          eletricistaRemoteId: eletricista.eletricistaId,
        );

        if (!epiPreenchido) {
          AppLogger.d(
              '🧭 [NAV] Checklist EPI pendente (há eletricistas sem checklist) → Rota: LISTA ELETRICISTAS',
              tag: 'TurnoNavigationOrchestrator');
          return TurnoNavigationResult(
            state: TurnoNavigationState.aguardandoChecklistEPI,
            route: Routes.turnoChecklistEletricistas,
            message: 'Checklist EPI pendente para alguns eletricistas.',
          );
        }
      }

      AppLogger.d('✅ [NAV] Todos os Checklists EPI OK',
          tag: 'TurnoNavigationOrchestrator');

      // 4. Todos os checklists OK - Abrir turno remotamente
      AppLogger.d(
          '🧭 [NAV] Todos os checklists concluídos → Rota: ABRIR TURNO REMOTO',
          tag: 'TurnoNavigationOrchestrator');
      return TurnoNavigationResult(
        state: TurnoNavigationState.checklistsConcluidos,
        route: Routes.turnoChecklistEletricistas,
        message: 'Todos os checklists concluídos. Pronto para abrir turno.',
        data: {'todosChecklistsConcluidos': true},
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ [NAV] Erro ao verificar checklists',
          tag: 'TurnoNavigationOrchestrator',
          error: e,
          stackTrace: stackTrace);
      return TurnoNavigationResult.erro(
          'Erro ao verificar checklists: ${e.toString()}');
    }
  }

  /// Verifica rapidamente o estado do turno (sem navegação).
  ///
  /// Útil para atualizações de UI sem navegar.
  ///
  /// ## Retorno:
  /// - Estado atual do turno
  Future<TurnoNavigationState> verificarEstadoAtual() async {
    final result = await determinarProximaRota();
    return result.state;
  }
}

