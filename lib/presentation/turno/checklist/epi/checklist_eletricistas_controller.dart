import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/core_app/services/error_message_service.dart';
import 'package:nexa_app/data/models/eletricista_table_dto.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/snackbar_utils.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/presentation/turno/checklist/services/turno_abertura_orchestrator_service.dart';
import 'package:nexa_app/core/constants/api_constants.dart';
import 'package:nexa_app/app/routes/routes.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';

class ChecklistEletricistasController extends GetxController {
  final TurnoRepo _turnoRepo = Get.find<TurnoRepo>();
  final EletricistaRepo _eletricistaRepo = Get.find<EletricistaRepo>();
  final ChecklistService _checklistService = Get.find<ChecklistService>();
  final ChecklistModeloRepo _checklistModeloRepo =
      Get.find<ChecklistModeloRepo>();
  final EquipeRepo _equipeRepo = Get.find<EquipeRepo>();
  final TurnoAberturaOrchestratorService _turnoAberturaService =
      Get.find<TurnoAberturaOrchestratorService>();
  final ErrorMessageService _errorMessageService =
      Get.find<ErrorMessageService>();
  final TurnoController _turnoController = Get.find<TurnoController>();

  final RxBool isLoading = false.obs;
  final RxList<EletricistaChecklistStatus> eletricistas =
      <EletricistaChecklistStatus>[].obs;
  final RxnString erro = RxnString();
  final RxBool isAbrindoTurno = false.obs;

  // Para EPI, precisamos buscar o modelo específico vinculado à equipe
  Future<int?> _getChecklistEpiModeloId() async {
    try {
      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();
      if (turnoAtivo == null) return null;

      final equipe =
          await _equipeRepo.buscarPorId(turnoAtivo.equipeId.toString());
      if (equipe == null) return null;

      // Busca o modelo EPI vinculado à equipe
      final modelos =
          await _checklistModeloRepo.buscarPorTipoChecklistETipoEquipe(
              ApiConstants.tipoChecklistEpiId, equipe.tipoEquipeId);

      return modelos.isNotEmpty ? modelos.first.remoteId : null;
    } catch (e) {
      AppLogger.e('Erro ao buscar modelo EPI: $e',
          tag: 'ChecklistEletricistasController');
      return null;
    }
  }

  bool get todosConcluidos =>
      eletricistas.isNotEmpty && eletricistas.every((item) => item.concluido);

  @override
  void onInit() {
    super.onInit();
    carregarEletricistas();
  }

  Future<void> carregarEletricistas() async {
    AppLogger.d('🔍 [CARREGAMENTO ELETRICISTAS] Iniciando carregamento de eletricistas', tag: 'ChecklistEletricistasController');
    try {
      isLoading.value = true;
      erro.value = null;
      
      // Força invalidação de cache antes de carregar
      await _invalidarCacheChecklists();

      final turnoAtivo = await _turnoRepo.buscarTurnoAtivo();
      if (turnoAtivo == null) {
        erro.value = 'Nenhum turno em abertura encontrado';
        AppLogger.w('⚠️ Nenhum turno ativo ao carregar eletricistas',
            tag: 'ChecklistEletricistasController');
        return;
      }

      final relacionamentos =
          await _turnoRepo.buscarEletricistasDoTurno(turnoAtivo.id);

      if (relacionamentos.isEmpty) {
        erro.value = 'Nenhum eletricista vinculado ao turno atual';
        eletricistas.clear();
        return;
      }

      final List<EletricistaChecklistStatus> itens = [];

      for (final rel in relacionamentos) {
        try {
          final eletricista =
              await _eletricistaRepo.buscarPorRemoteId(rel.eletricistaId);
          final remoteId = int.tryParse(eletricista.remoteId);

          if (remoteId == null) {
            AppLogger.w(
              '⚠️ Eletricista ${eletricista.nome} sem remoteId válido',
              tag: 'ChecklistEletricistasController',
            );
            itens.add(EletricistaChecklistStatus(
              eletricista: eletricista,
              remoteId: null,
              concluido: false,
              motorista: rel.motorista,
            ));
            continue;
          }

          // Busca o modelo EPI específico vinculado à equipe
          final modeloEpiId = await _getChecklistEpiModeloId();
          if (modeloEpiId == null) {
            AppLogger.w('⚠️ Modelo EPI não encontrado para a equipe',
                tag: 'ChecklistEletricistasController');
            itens.add(EletricistaChecklistStatus(
              eletricista: eletricista,
              remoteId: remoteId,
              concluido: false,
              motorista: rel.motorista,
            ));
            continue;
          }

          AppLogger.d(
              '🔍 [EPI] Verificando checklist para eletricista ${eletricista.nome} (remoteId: $remoteId, modeloId: $modeloEpiId)',
              tag: 'ChecklistEletricistasController');
          
          final concluido = await _checklistService.checklistJaPreenchido(
            modeloEpiId,
            eletricistaRemoteId: remoteId,
          );
          
          AppLogger.d(
              '📌 [EPI] Resultado da verificação para ${eletricista.nome}: $concluido',
              tag: 'ChecklistEletricistasController');

          itens.add(EletricistaChecklistStatus(
            eletricista: eletricista,
            remoteId: remoteId,
            concluido: concluido,
            motorista: rel.motorista,
          ));
        } catch (e, stackTrace) {
          AppLogger.e('❌ Erro ao carregar eletricista do turno',
              tag: 'ChecklistEletricistasController',
              error: e,
              stackTrace: stackTrace);
        }
      }

      eletricistas.assignAll(itens);
    } catch (e, stackTrace) {
      erro.value = 'Erro ao carregar eletricistas';
      AppLogger.e('❌ Erro geral ao carregar eletricistas',
          tag: 'ChecklistEletricistasController',
          error: e,
          stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> abrirChecklist(EletricistaChecklistStatus item) async {
    if (item.remoteId == null) {
      SnackbarUtils.erro(
        titulo: 'Dados Incompletos',
        mensagem:
            'Eletricista sem identificador remoto. Sincronize os dados antes de continuar.',
      );
      return;
    }

    AppLogger.d(
        '🔄 [EPI] Abrindo checklist para ${item.eletricista.nome} (ID: ${item.remoteId})',
        tag: 'ChecklistEletricistasController');

    final result = await Get.toNamed(Routes.turnoChecklistEPI, arguments: {
      'eletricistaRemoteId': item.remoteId,
      'eletricistaNome': item.eletricista.nome,
    });

    AppLogger.d('🔄 [EPI] Resultado do checklist: $result',
        tag: 'ChecklistEletricistasController');

    // SEMPRE recarrega a lista ao voltar, independente do resultado
    // Isso garante que o status seja atualizado na UI
    AppLogger.d('🔄 [EPI] Recarregando lista de eletricistas...',
        tag: 'ChecklistEletricistasController');
    
    // Força invalidação de cache antes de recarregar
    await _invalidarCacheChecklists();
    
    await carregarEletricistas();
    AppLogger.d('✅ [EPI] Lista recarregada',
        tag: 'ChecklistEletricistasController');
  }

  /// Invalida cache relacionado aos checklists para forçar recarregamento
  Future<void> _invalidarCacheChecklists() async {
    try {
      AppLogger.d('🔄 [CACHE] Invalidando cache de checklists preenchidos...',
          tag: 'ChecklistEletricistasController');

      // Força limpeza de qualquer cache implícito
      // Limpa a lista de eletricistas para forçar recarregamento completo
      eletricistas.clear();

      // Adiciona um pequeno delay para garantir que qualquer cache seja limpo
      await Future.delayed(const Duration(milliseconds: 100));

      AppLogger.d('✅ [CACHE] Cache invalidado com sucesso',
          tag: 'ChecklistEletricistasController');
    } catch (e) {
      AppLogger.w('⚠️ [CACHE] Erro ao invalidar cache (não crítico)',
          tag: 'ChecklistEletricistasController');
    }
  }

  Future<void> abrirTurno() async {
    if (!todosConcluidos) {
      SnackbarUtils.validacao(
        'Finalize o checklist de EPI de todos os eletricistas antes de abrir o turno.',
      );
      return;
    }

    if (isAbrindoTurno.value) return;

    try {
      isAbrindoTurno.value = true;

      AppLogger.d('🚀 [ABERTURA TURNO] Iniciando processo de abertura',
          tag: 'ChecklistEletricistasController');

      // Enviar dados completos para API (viatura, equipe, eletricistas, checklists)
      final resultado = await _turnoAberturaService.enviarAberturaDoTurno();

      final sucesso = resultado['success'] as bool;
      final mensagem = resultado['message'] as String;

      if (!sucesso) {
        AppLogger.e('❌ [ABERTURA TURNO] Falha: $mensagem',
            tag: 'ChecklistEletricistasController');

        // Extrai informações específicas do erro
        final statusCode = resultado['statusCode'] as int?;
        final isConflictError = resultado['isConflictError'] as bool? ?? false;
        final isValidationError =
            resultado['isValidationError'] as bool? ?? false;
        final isServerError = resultado['isServerError'] as bool? ?? false;

        // Define tipo de erro específico no serviço
        if (isConflictError) {
          _errorMessageService.definirErroConflito(mensagem);
        } else if (isValidationError) {
          _errorMessageService.definirErroValidacao(mensagem);
        } else if (isServerError) {
          _errorMessageService.definirErroServidor(mensagem);
        } else {
          _errorMessageService.definirErroAberturaTurno(
            mensagem: mensagem,
            statusCode: statusCode,
          );
        }

        // Em caso de erro, volta para home onde o erro será exibido
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(Routes.home);
        return;
      }

      // Sucesso - turno aberto
      final remoteId = resultado['remoteId'];
      AppLogger.i('✅ [ABERTURA TURNO] Sucesso! RemoteID: $remoteId',
          tag: 'ChecklistEletricistasController');

      // Recarrega o turno ativo para atualizar o estado no TurnoController
      AppLogger.d('🔄 [ABERTURA TURNO] Recarregando turno no TurnoController',
          tag: 'ChecklistEletricistasController');
      await _turnoController.carregarTurnoAtivo();

      // Limpa qualquer erro anterior
      _errorMessageService.limparErro();

      // Sucesso: apenas navega sem mostrar snackbar
      AppLogger.i('✅ Turno aberto com sucesso! Navegando para serviços...',
          tag: 'ChecklistEletricistasController');

      // Navegar para tela de serviços do turno
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(Routes.turnoServicos);
      
    } catch (e, stackTrace) {
      AppLogger.e('❌ [ABERTURA TURNO] Erro inesperado',
          tag: 'ChecklistEletricistasController',
          error: e,
          stackTrace: stackTrace);
      
      // Define erro genérico no serviço
      _errorMessageService.definirErroAberturaTurno(
        mensagem: 'Erro inesperado ao abrir turno. Tente novamente.',
        statusCode: 0,
        tipo: 'unexpected',
      );
      
      // Em caso de erro inesperado, volta para home
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(Routes.home);
    } finally {
      isAbrindoTurno.value = false;
    }
  }

  // ============================================================================
  // CICLO DE VIDA
  // ============================================================================

  /// Limpeza do controlador.
  ///
  /// Executado quando controlador é removido da memória,
  /// liberando recursos e fazendo limpeza necessária para evitar memory leaks.
  ///
  /// ## Recursos Liberados:
  /// - Listas observáveis (eletricistas)
  /// - Estados reativos (isLoading, erro, isAbrindoTurno)
  @override
  void onClose() {
    /// Limpa listas observáveis.
    eletricistas.clear();

    /// Reseta estados reativos.
    isLoading.value = false;
    erro.value = null;
    isAbrindoTurno.value = false;

    /// Registra finalização do controlador.
    AppLogger.d(
        'ChecklistEletricistasController finalizado e recursos liberados',
        tag: 'ChecklistEletricistasController');

    super.onClose();
  }
}

class EletricistaChecklistStatus {
  final EletricistaTableDto eletricista;
  final int? remoteId;
  final bool concluido;
  final bool motorista;

  EletricistaChecklistStatus({
    required this.eletricista,
    required this.remoteId,
    required this.concluido,
    required this.motorista,
  });
}
