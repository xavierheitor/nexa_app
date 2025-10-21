import 'package:get/get.dart';
import 'package:nexa_app/domain/entities/checklist_model.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/core/utils/snackbar_utils.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/app/routes/routes.dart';

/// Controller do checklist veicular.
class ChecklistController extends GetxController {
  final ChecklistService _checklistService = Get.find<ChecklistService>();

  // Flags para determinar tipo de checklist (baseado em argumentos, não em rota)
  bool _isChecklistEPC = false;
  bool _isChecklistEPI = false;

  int? get _eletricistaRemoteIdOrNull =>
      _isChecklistEPI ? _eletricistaRemoteId : null;

  int? _eletricistaRemoteId;
  String? _eletricistaNome;

  /// Checklist completo carregado.
  final Rxn<ChecklistCompletoModel> checklist = Rxn<ChecklistCompletoModel>();

  /// Estado de carregamento.
  final RxBool isLoading = false.obs;

  /// Indica se este checklist já foi preenchido anteriormente.
  final RxBool jaFoiPreenchido = false.obs;

  /// Indica se está finalizando o checklist (para desabilitar botão).
  final RxBool isFinalizando = false.obs;

  /// Flag para evitar navegação dupla
  bool _jaNavegou = false;

  /// Lista de perguntas (para facilitar o acesso reativo).
  final RxList<ChecklistPerguntaModel> perguntas =
      <ChecklistPerguntaModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Determina tipo de checklist baseado na ROTA ATUAL (mais confiável)
    final rota = Get.currentRoute;
    AppLogger.d('🔍 [INIT] Rota atual: $rota', tag: 'ChecklistController');

    if (rota == Routes.turnoChecklistEPC) {
      _isChecklistEPC = true;
      AppLogger.d('✅ [INIT] Tipo: EPC', tag: 'ChecklistController');
    } else if (rota == Routes.turnoChecklistEPI) {
      _isChecklistEPI = true;
      AppLogger.d('✅ [INIT] Tipo: EPI', tag: 'ChecklistController');
    } else {
      AppLogger.d('✅ [INIT] Tipo: Veicular (padrão)',
          tag: 'ChecklistController');
    }

    // Processa argumentos (para EPI)
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args.containsKey('eletricistaRemoteId')) {
        _isChecklistEPI = true;
        _eletricistaRemoteId = args['eletricistaRemoteId'] as int?;
        _eletricistaNome = args['eletricistaNome'] as String?;
        AppLogger.d(
            '✅ [INIT] EPI para eletricista: $_eletricistaNome (ID: $_eletricistaRemoteId)',
            tag: 'ChecklistController');
      }
    }

    _carregarChecklist();
  }

  /// Carrega o checklist do turno ativo.
  Future<void> _carregarChecklist() async {
    try {
      isLoading.value = true;
      checklist.value = null;
      perguntas.clear();
      jaFoiPreenchido.value = false;

      final tipoChecklistDescricao =
          _isChecklistEPI ? 'EPI' : (_isChecklistEPC ? 'EPC' : 'veicular');
      AppLogger.d('📋 Carregando checklist $tipoChecklistDescricao...',
          tag: 'ChecklistController');

      ChecklistCompletoModel? checklistCarregado;

      if (_isChecklistEPI) {
        final eletricistaRemoteId = _eletricistaRemoteId;
        if (eletricistaRemoteId == null) {
          AppLogger.e(
            '❌ Eletricista remoto não informado para checklist EPI',
            tag: 'ChecklistController',
          );
          SnackbarUtils.erro(
            titulo: 'Erro',
            mensagem: 'Eletricista não encontrado para o checklist de EPI',
          );
          Get.back();
          return;
        }

        checklistCarregado = await _checklistService
            .buscarChecklistEPIParaEletricista(eletricistaRemoteId);
      } else if (_isChecklistEPC) {
        checklistCarregado =
            await _checklistService.buscarChecklistEPCDoTurnoAtivo();
      } else {
        checklistCarregado =
            await _checklistService.buscarChecklistDoTurnoAtivo();
      }

      if (checklistCarregado == null) {
        AppLogger.w('⚠️ Nenhum checklist encontrado',
            tag: 'ChecklistController');

        // Define estado vazio ANTES do snackbar
        checklist.value = null;
        perguntas.clear();
        isLoading.value = false; // ← Importante! Seta false ANTES do return

        final mensagem = _isChecklistEPI
            ? 'Nenhum checklist de EPI encontrado para este eletricista'
            : _isChecklistEPC
                ? 'Nenhum checklist de EPC encontrado para esta equipe'
                : 'Nenhum checklist encontrado para este veículo';

        SnackbarUtils.validacao(mensagem);

        AppLogger.d('🔙 Estado vazio configurado - botão Voltar disponível',
            tag: 'ChecklistController');

        // NÃO navegar automaticamente - deixar a UI mostrar a mensagem
        // e o botão "Voltar" funcionar corretamente
        return;
      }

      final jaPreenchido = await _checklistService.checklistJaPreenchido(
        checklistCarregado.remoteId,
        eletricistaRemoteId: _eletricistaRemoteIdOrNull,
      );

      // Define se já foi preenchido
      jaFoiPreenchido.value = jaPreenchido;

      if (jaPreenchido) {
        AppLogger.i(
          '✅ Checklist ${checklistCarregado.nome} já preenchido anteriormente.',
          tag: 'ChecklistController',
        );

        // Mostra snackbar informativo
        final mensagemJaRealizado = _isChecklistEPI
            ? 'Checklist de EPI já registrado para ${_eletricistaNome ?? 'este eletricista'}.'
            : _isChecklistEPC
                ? 'Checklist de EPC já registrado para este turno.'
                : 'Checklist veicular já registrado para este turno.';

        SnackbarUtils.validacao(mensagemJaRealizado);

        // NÃO NAVEGAR MAIS AUTOMATICAMENTE!
        // Carrega o checklist mesmo assim para permitir visualização/edição
      }

      checklist.value = checklistCarregado;
      perguntas.value = checklistCarregado.perguntas;

      AppLogger.i('✅ Checklist carregado: ${checklistCarregado.nome}',
          tag: 'ChecklistController');
      AppLogger.d('📊 ${perguntas.length} perguntas no checklist',
          tag: 'ChecklistController');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao carregar checklist',
          tag: 'ChecklistController', error: e, stackTrace: stackTrace);
      SnackbarUtils.erroGenerico();
    } finally {
      isLoading.value = false;
    }
  }

  /// Seleciona uma resposta para uma pergunta.
  void selecionarResposta(int perguntaId, int opcaoId) {
    try {
      AppLogger.d(
          '📝 Selecionando resposta: pergunta=$perguntaId, opção=$opcaoId',
          tag: 'ChecklistController');

      // Encontrar a pergunta e atualizar
      final index = perguntas.indexWhere((p) => p.id == perguntaId);
      if (index != -1) {
        final perguntaAtualizada = perguntas[index].copyWith(
          respostaSelecionada: opcaoId,
        );
        perguntas[index] = perguntaAtualizada;

        // Verificar se a resposta gera pendência
        final opcaoSelecionada = perguntaAtualizada.opcaoSelecionada;
        if (opcaoSelecionada != null && opcaoSelecionada.geraPendencia) {
          AppLogger.w(
              '⚠️ Resposta selecionada gera pendência: ${opcaoSelecionada.nome}',
              tag: 'ChecklistController');
        }

        AppLogger.d('✅ Resposta selecionada com sucesso',
            tag: 'ChecklistController');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao selecionar resposta',
          tag: 'ChecklistController', error: e, stackTrace: stackTrace);
    }
  }

  /// Valida se todas as perguntas foram respondidas.
  bool validarRespostas() {
    AppLogger.d('🔍 [VALIDAÇÃO] Validando ${perguntas.length} perguntas...',
        tag: 'ChecklistController');

    final naoRespondidas = perguntas.where((p) => !p.foiRespondida).toList();

    AppLogger.d('🔍 [VALIDAÇÃO] Não respondidas: ${naoRespondidas.length}',
        tag: 'ChecklistController');

    if (naoRespondidas.isNotEmpty) {
      AppLogger.w(
          '❌ [VALIDAÇÃO] ${naoRespondidas.length} perguntas não respondidas',
          tag: 'ChecklistController');

      // Log das perguntas não respondidas
      for (final p in naoRespondidas) {
        AppLogger.d('  - Pergunta não respondida: ${p.nome}',
            tag: 'ChecklistController');
      }

      SnackbarUtils.validacao(
          'Por favor, responda todas as perguntas antes de continuar');
      return false;
    }

    AppLogger.i('✅ [VALIDAÇÃO] Todas as perguntas foram respondidas!',
        tag: 'ChecklistController');
    return true;
  }

  /// Verifica se há pendências nas respostas.
  bool hasPendencias() {
    return perguntas.any((p) {
      final opcao = p.opcaoSelecionada;
      return opcao != null && opcao.geraPendencia;
    });
  }

  /// Finaliza o checklist e avança para a próxima etapa.
  Future<void> finalizarChecklist() async {
    // Evita cliques duplos
    if (isFinalizando.value) {
      AppLogger.w('⚠️ [FINALIZAR] Já está finalizando - ignorando clique',
          tag: 'ChecklistController');
      return;
    }

    AppLogger.d('🎬 [FINALIZAR] Método finalizarChecklist() INICIADO',
        tag: 'ChecklistController');

    try {
      isFinalizando.value = true;

      AppLogger.d('🔍 [FINALIZAR] Validando respostas...',
          tag: 'ChecklistController');

      if (!validarRespostas()) {
        AppLogger.w('❌ [FINALIZAR] Validação falhou - abortando',
            tag: 'ChecklistController');
        return;
      }

      AppLogger.i('✅ [FINALIZAR] Validação OK - prosseguindo',
          tag: 'ChecklistController');
      AppLogger.d('💾 Finalizando checklist...', tag: 'ChecklistController');

      final temPendencias = hasPendencias();
      if (temPendencias) {
        AppLogger.w('⚠️ Checklist possui pendências',
            tag: 'ChecklistController');
        // Aqui você pode salvar as pendências no banco
      }

      final checklistAtual = checklist.value;
      if (checklistAtual == null) {
        AppLogger.e('❌ Checklist atual não encontrado ao finalizar',
            tag: 'ChecklistController');
        SnackbarUtils.erro(
          titulo: 'Erro ao Finalizar',
          mensagem: 'Não foi possível finalizar o checklist atual',
        );
        return;
      }

      final perguntasRespondidas = perguntas.toList();

      AppLogger.d('💾 [FINALIZAR] Salvando checklist no banco...',
          tag: 'ChecklistController');
      AppLogger.d(
          '💾 [FINALIZAR] ChecklistAtual: id=${checklistAtual.id}, remoteId=${checklistAtual.remoteId}, nome=${checklistAtual.nome}',
          tag: 'ChecklistController');

      final sucesso = await _checklistService.salvarChecklistPreenchido(
        checklist: checklistAtual,
        perguntasRespondidas: perguntasRespondidas,
        eletricistaRemoteId: _eletricistaRemoteIdOrNull,
      );

      AppLogger.d('💾 [FINALIZAR] Resultado do salvamento: $sucesso',
          tag: 'ChecklistController');

      if (!sucesso) {
        AppLogger.e('❌ [FINALIZAR] Falha ao salvar - abortando',
            tag: 'ChecklistController');
        SnackbarUtils.erro(
          titulo: 'Erro ao Salvar',
          mensagem: 'Não foi possível salvar o checklist. Tente novamente.',
        );
        return;
      }

      AppLogger.i('✅ [FINALIZAR] Checklist finalizado e salvo com sucesso',
          tag: 'ChecklistController');
      
      // Sucesso: apenas navega sem mostrar snackbar

      AppLogger.d(
          '🔍 [FINALIZAR] Tipo checklist: EPC=$_isChecklistEPC, EPI=$_isChecklistEPI, Veicular=${!_isChecklistEPC && !_isChecklistEPI}',
          tag: 'ChecklistController');

      _navegarParaProximaEtapa();
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao finalizar checklist',
          tag: 'ChecklistController', error: e, stackTrace: stackTrace);
      SnackbarUtils.erroGenerico();
    } finally {
      isFinalizando.value = false;
    }
  }

  /// Retorna o progresso do checklist (quantidade de perguntas respondidas).
  double get progresso {
    if (perguntas.isEmpty) return 0.0;
    final respondidas = perguntas.where((p) => p.foiRespondida).length;
    return respondidas / perguntas.length;
  }

  /// Retorna texto do progresso.
  String get progressoTexto {
    final respondidas = perguntas.where((p) => p.foiRespondida).length;
    return '$respondidas/${perguntas.length}';
  }

  void _navegarParaProximaEtapa() {
    // Evita navegação dupla
    if (_jaNavegou) {
      AppLogger.w(
          '⚠️ [NAVEGAÇÃO] Navegação já realizada - bloqueando chamada duplicada',
          tag: 'ChecklistController');
      return;
    }

    AppLogger.i('🧭 [NAVEGAÇÃO] ========================================',
        tag: 'ChecklistController');
    AppLogger.i('🧭 [NAVEGAÇÃO] Método _navegarParaProximaEtapa() INICIADO',
        tag: 'ChecklistController');
    AppLogger.i(
        '🧭 [NAVEGAÇÃO] Flags: EPC=$_isChecklistEPC, EPI=$_isChecklistEPI',
        tag: 'ChecklistController');

    _jaNavegou = true; // Marca que já navegou

    if (_isChecklistEPI) {
      AppLogger.i('🚀 [NAVEGAÇÃO] → TIPO: EPI concluído',
          tag: 'ChecklistController');
      AppLogger.i(
          '🚀 [NAVEGAÇÃO] → AÇÃO: VOLTANDO para lista de eletricistas (Get.back)',
          tag: 'ChecklistController');
      AppLogger.i(
          '🔍 [NAVEGAÇÃO] → Rota atual antes do back: ${Get.currentRoute}',
          tag: 'ChecklistController');
      AppLogger.i(
          '🔍 [NAVEGAÇÃO] → Pode voltar? ${Get.key.currentState?.canPop()}',
          tag: 'ChecklistController');

      // Usa Get.back com closeOverlays para garantir que fecha tudo
      Get.back(result: true, closeOverlays: true);

      AppLogger.i('✅ [NAVEGAÇÃO] Get.back() executado',
          tag: 'ChecklistController');
      AppLogger.i(
          '🔍 [NAVEGAÇÃO] → Rota atual depois do back: ${Get.currentRoute}',
          tag: 'ChecklistController');
    } else if (_isChecklistEPC) {
      AppLogger.i('🚀 [NAVEGAÇÃO] → TIPO: EPC concluído',
          tag: 'ChecklistController');
      AppLogger.i(
          '🚀 [NAVEGAÇÃO] → AÇÃO: Deixando orchestrator decidir próximo passo',
          tag: 'ChecklistController');
      AppLogger.d(
          '🧭 [NAVEGAÇÃO] → Executando: Get.offNamed(turnoNavigationLoading)',
          tag: 'ChecklistController');
      Get.offNamed(Routes.turnoNavigationLoading);
      AppLogger.i('✅ [NAVEGAÇÃO] Get.offNamed() executado',
          tag: 'ChecklistController');
    } else {
      AppLogger.i('🚀 [NAVEGAÇÃO] → TIPO: Veicular concluído',
          tag: 'ChecklistController');
      AppLogger.i(
          '🚀 [NAVEGAÇÃO] → AÇÃO: Deixando orchestrator decidir próximo passo',
          tag: 'ChecklistController');
      AppLogger.i(
          '🔍 [NAVEGAÇÃO] → Rota atual antes da navegação: ${Get.currentRoute}',
          tag: 'ChecklistController');
      AppLogger.d(
          '🧭 [NAVEGAÇÃO] → Executando: Get.offNamed(turnoNavigationLoading) - ORCHESTRADOR DECIDE',
          tag: 'ChecklistController');

      // Usa o orchestrator para decidir automaticamente qual o próximo checklist
      Get.offNamed(Routes.turnoNavigationLoading);

      AppLogger.i('✅ [NAVEGAÇÃO] Get.offNamed() executado',
          tag: 'ChecklistController');
    }

    AppLogger.i('🧭 [NAVEGAÇÃO] ========================================',
        tag: 'ChecklistController');
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
  /// - Listas observáveis (perguntas)
  /// - Estados reativos (isLoading, checklist)
  /// - Referências a objetos pesados
  @override
  void onClose() {
    /// Limpa listas observáveis.
    perguntas.clear();

    /// Reseta estados reativos.
    isLoading.value = false;
    checklist.value = null;
    jaFoiPreenchido.value = false;

    /// Registra finalização do controlador.
    AppLogger.d('ChecklistController finalizado e recursos liberados',
        tag: 'ChecklistController');

    super.onClose();
  }
}
