import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/core/database/converters/situacao_turno_converter.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/presentation/turno/navigation/turno_navigation_state.dart';
import 'package:nexa_app/app/routes/routes.dart';

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
      AppLogger.i(
          '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🧭 [ORCHESTRATOR] INICIANDO determinação de rota',
          tag: 'TurnoNavigationOrchestrator');

      // 1. Verificar se existe turno ativo
      AppLogger.d('🔍 [ORCHESTRATOR] Buscando turno ativo...',
          tag: 'TurnoNavigationOrchestrator');
      
      final turno = await _turnoRepo.buscarTurnoAtivo();

      if (turno == null) {
        AppLogger.i('🧭 [ORCHESTRATOR] ❌ Nenhum turno ativo encontrado',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i('🧭 [ORCHESTRATOR] AÇÃO: Navegando para ABRIR TURNO',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i(
            '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.naoExiste,
          route: Routes.turnoAbrir,
          message: 'Nenhum turno ativo. Abrir novo turno.',
        );
      }

      AppLogger.i(
          '✅ [ORCHESTRATOR] Turno encontrado: ID=${turno.id}, Situação=${turno.situacaoTurno.name}',
          tag: 'TurnoNavigationOrchestrator');

      // 2. Verificar situação do turno
      switch (turno.situacaoTurno) {
        case SituacaoTurno.fechado:
          AppLogger.i('🧭 [ORCHESTRATOR] Turno FECHADO → Rota: ABRIR TURNO',
              tag: 'TurnoNavigationOrchestrator');
          AppLogger.i(
              '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
              tag: 'TurnoNavigationOrchestrator');
          return TurnoNavigationResult(
            state: TurnoNavigationState.fechado,
            route: Routes.turnoAbrir,
            message: 'Turno anterior fechado. Abrir novo turno.',
          );

        case SituacaoTurno.aberto:
          AppLogger.i('🧭 [ORCHESTRATOR] Turno ABERTO → Rota: SERVIÇOS',
              tag: 'TurnoNavigationOrchestrator');
          AppLogger.i(
              '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
              tag: 'TurnoNavigationOrchestrator');
          return TurnoNavigationResult(
            state: TurnoNavigationState.aberto,
            route: Routes.turnoServicos,
            message: 'Turno em execução.',
            data: {'turnoId': turno.id},
          );

        case SituacaoTurno.emAbertura:
          AppLogger.i(
              '🧭 [ORCHESTRATOR] Turno EM_ABERTURA → Verificando checklists...',
              tag: 'TurnoNavigationOrchestrator');
          // 3. Turno em abertura - verificar checklists pendentes
          return await _verificarChecklistsPendentes(turno.id);
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ [ORCHESTRATOR] Erro ao determinar rota',
          tag: 'TurnoNavigationOrchestrator',
          error: e,
          stackTrace: stackTrace);
      AppLogger.i(
          '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
          tag: 'TurnoNavigationOrchestrator');
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
      AppLogger.i(
          '🔍 [ORCHESTRATOR] ==========================================',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i(
          '🔍 [ORCHESTRATOR] Verificando checklists pendentes para turno $turnoId',
          tag: 'TurnoNavigationOrchestrator');

      // 1. Verificar Checklist Veicular (por TIPO, não por modelo específico)
      AppLogger.i('🔍 [ORCHESTRATOR] ========================================',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🔍 [ORCHESTRATOR] ETAPA 1: Verificando CHECKLIST VEICULAR',
          tag: 'TurnoNavigationOrchestrator');

      final tipoChecklistVeicular = ApiConstants.tipoChecklistVeicularId;
      AppLogger.i(
          '🔍 [ORCHESTRATOR] 📌 Tipo Checklist Veicular ID: $tipoChecklistVeicular',
          tag: 'TurnoNavigationOrchestrator');

      AppLogger.i(
          '🔍 [ORCHESTRATOR] 🔄 Chamando checklistService.checklistPorTipoJaPreenchido($tipoChecklistVeicular)...',
          tag: 'TurnoNavigationOrchestrator');
      
      final checklistVeicularCompleto =
          await _checklistService.checklistPorTipoJaPreenchido(
        tipoChecklistVeicular,
      );

      AppLogger.i(
          '🔍 [ORCHESTRATOR] Resultado Veicular: ${checklistVeicularCompleto ? "✅ JÁ PREENCHIDO" : "❌ PENDENTE"}',
          tag: 'TurnoNavigationOrchestrator');

      if (!checklistVeicularCompleto) {
        AppLogger.i('🧭 [ORCHESTRATOR] DECISÃO: Checklist Veicular PENDENTE',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i(
            '🧭 [ORCHESTRATOR] AÇÃO: Navegando para → ${Routes.turnoChecklist}',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i(
            '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.aguardandoChecklistVeicular,
          route: Routes.turnoChecklist,
          message: 'Checklist veicular pendente.',
        );
      }

      AppLogger.i('✅ [ORCHESTRATOR] Checklist Veicular JÁ CONCLUÍDO',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🔍 [ORCHESTRATOR] Próxima verificação: EPC...',
          tag: 'TurnoNavigationOrchestrator');

      // 2. Verificar Checklist EPC (por TIPO, não por modelo específico)
      AppLogger.i('🔍 [ORCHESTRATOR] ========================================',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🔍 [ORCHESTRATOR] ETAPA 2: Verificando CHECKLIST EPC',
          tag: 'TurnoNavigationOrchestrator');

      final tipoChecklistEPC = ApiConstants.tipoChecklistEpcId;
      AppLogger.d('🔍 [ORCHESTRATOR] Tipo Checklist EPC ID: $tipoChecklistEPC',
          tag: 'TurnoNavigationOrchestrator');
      
      final checklistEPCCompleto =
          await _checklistService
          .checklistPorTipoJaPreenchido(tipoChecklistEPC);

      AppLogger.i(
          '🔍 [ORCHESTRATOR] Resultado EPC: ${checklistEPCCompleto ? "✅ JÁ PREENCHIDO" : "❌ PENDENTE"}',
          tag: 'TurnoNavigationOrchestrator');

      if (!checklistEPCCompleto) {
        AppLogger.i('🧭 [ORCHESTRATOR] DECISÃO: Checklist EPC PENDENTE',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i(
            '🧭 [ORCHESTRATOR] AÇÃO: Navegando para → ${Routes.turnoChecklistEPC}',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i(
            '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.aguardandoChecklistEPC,
          route: Routes.turnoChecklistEPC,
          message: 'Checklist EPC pendente.',
        );
      }

      AppLogger.i('✅ [ORCHESTRATOR] Checklist EPC JÁ CONCLUÍDO',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🔍 [ORCHESTRATOR] Próxima verificação: EPIs...',
          tag: 'TurnoNavigationOrchestrator');

      // 3. Verificar Checklist EPI (eletricistas)
      AppLogger.i('🔍 [ORCHESTRATOR] ========================================',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🔍 [ORCHESTRATOR] ETAPA 3: Verificando CHECKLIST EPI',
          tag: 'TurnoNavigationOrchestrator');
      
      final eletricistas = await _turnoRepo.buscarEletricistasDoTurno(turnoId);
      AppLogger.d(
          '🔍 [ORCHESTRATOR] Eletricistas no turno: ${eletricistas.length}',
          tag: 'TurnoNavigationOrchestrator');

      if (eletricistas.isEmpty) {
        AppLogger.w('⚠️ [ORCHESTRATOR] Nenhum eletricista vinculado ao turno',
            tag: 'TurnoNavigationOrchestrator');
        AppLogger.i(
            '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
            tag: 'TurnoNavigationOrchestrator');
        return TurnoNavigationResult(
          state: TurnoNavigationState.erro,
          route: Routes.home,
          message: 'Nenhum eletricista vinculado ao turno.',
          showSnackbar: true,
        );
      }

      // Verificar se todos os eletricistas preencheram EPI
      final tipoChecklistEPI = ApiConstants.tipoChecklistEpiId;
      AppLogger.d('🔍 [ORCHESTRATOR] Tipo Checklist EPI ID: $tipoChecklistEPI',
          tag: 'TurnoNavigationOrchestrator');

      for (final eletricista in eletricistas) {
        AppLogger.d(
            '🔍 [ORCHESTRATOR] Verificando EPI do eletricista: ${eletricista.eletricistaId}',
            tag: 'TurnoNavigationOrchestrator');

        final epiPreenchido =
            await _checklistService.checklistPorTipoJaPreenchido(
          tipoChecklistEPI,
          eletricistaRemoteId: eletricista.eletricistaId,
        );

        AppLogger.d(
            '🔍 [ORCHESTRATOR] Eletricista ${eletricista.eletricistaId}: EPI ${epiPreenchido ? "✅ OK" : "❌ PENDENTE"}',
            tag: 'TurnoNavigationOrchestrator');

        if (!epiPreenchido) {
          AppLogger.i(
              '🧭 [ORCHESTRATOR] DECISÃO: Checklist EPI pendente (há eletricistas sem checklist)',
              tag: 'TurnoNavigationOrchestrator');
          AppLogger.i(
              '🧭 [ORCHESTRATOR] AÇÃO: Navegando para → ${Routes.turnoChecklistEletricistas}',
              tag: 'TurnoNavigationOrchestrator');
          AppLogger.i(
              '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
              tag: 'TurnoNavigationOrchestrator');
          return TurnoNavigationResult(
            state: TurnoNavigationState.aguardandoChecklistEPI,
            route: Routes.turnoChecklistEletricistas,
            message: 'Checklist EPI pendente para alguns eletricistas.',
          );
        }
      }

      AppLogger.i('✅ [ORCHESTRATOR] Todos os Checklists EPI OK',
          tag: 'TurnoNavigationOrchestrator');

      // 4. Todos os checklists OK - Abrir turno remotamente
      AppLogger.i('🔍 [ORCHESTRATOR] ========================================',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i('🧭 [ORCHESTRATOR] ✅ TODOS OS CHECKLISTS CONCLUÍDOS!',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i(
          '🧭 [ORCHESTRATOR] AÇÃO: Navegando para → ${Routes.turnoChecklistEletricistas}',
          tag: 'TurnoNavigationOrchestrator');
      AppLogger.i(
          '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
          tag: 'TurnoNavigationOrchestrator');
      
      return TurnoNavigationResult(
        state: TurnoNavigationState.checklistsConcluidos,
        route: Routes.turnoChecklistEletricistas,
        message: 'Todos os checklists concluídos. Pronto para abrir turno.',
        data: {'todosChecklistsConcluidos': true},
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ [ORCHESTRATOR] Erro ao verificar checklists',
          tag: 'TurnoNavigationOrchestrator',
          error: e,
          stackTrace: stackTrace);
      AppLogger.i(
          '🧭🧭🧭 [ORCHESTRATOR] ==========================================',
          tag: 'TurnoNavigationOrchestrator');
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
