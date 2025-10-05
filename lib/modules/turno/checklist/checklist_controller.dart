import 'package:get/get.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_service.dart';

/// Controller para gerenciar o checklist
class ChecklistController extends GetxController {
  final ChecklistService _checklistService;

  ChecklistController(this._checklistService);

  // Estado reativo
  final Rx<ChecklistCompletoModel?> checklist =
      Rx<ChecklistCompletoModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxInt perguntaAtual = 0.obs;
  final RxBool checklistCompleto = false.obs;

  @override
  void onInit() {
    super.onInit();
    _carregarChecklist();
  }

  /// Detecta o tipo de checklist baseado na rota atual
  bool get _isChecklistEPC {
    return Get.currentRoute == '/turno/checklist/epc';
  }

  bool get _isChecklistEPI {
    return Get.currentRoute == '/turno/checklist/epi';
  }

  /// Carrega o checklist do turno ativo
  Future<void> _carregarChecklist() async {
    try {
      isLoading.value = true;
      AppLogger.d('🔄 Carregando checklist...', tag: 'ChecklistController');

      ChecklistCompletoModel? checklistCompleto;
      if (_isChecklistEPC) {
        checklistCompleto =
            await _checklistService.buscarChecklistEPCDoTurnoAtivo();
      } else if (_isChecklistEPI) {
        // Para EPI, precisamos buscar o checklist do eletricista específico
        // Por enquanto, vamos usar o mesmo método do EPC
        checklistCompleto =
            await _checklistService.buscarChecklistEPCDoTurnoAtivo();
      } else {
        checklistCompleto =
            await _checklistService.buscarChecklistDoTurnoAtivo();
      }

      if (checklistCompleto != null) {
        checklist.value = checklistCompleto;
        AppLogger.i('✅ Checklist carregado: ${checklistCompleto.modelo.nome}',
            tag: 'ChecklistController');
        AppLogger.d(
            '📊 ${checklistCompleto.perguntas.length} perguntas no checklist',
            tag: 'ChecklistController');
      } else {
        AppLogger.w('⚠️ Nenhum checklist encontrado',
            tag: 'ChecklistController');
        Get.snackbar('Erro', 'Nenhum checklist encontrado para este veículo');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao carregar checklist: $e',
          tag: 'ChecklistController', error: e, stackTrace: stackTrace);
      Get.snackbar('Erro', 'Erro ao carregar checklist: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Seleciona uma resposta para uma pergunta
  void selecionarResposta(int perguntaId, int opcaoId) {
    AppLogger.d(
        '🎯 Selecionando resposta: pergunta=$perguntaId, opcao=$opcaoId',
        tag: 'ChecklistController');

    final checklistAtual = checklist.value;
    if (checklistAtual == null) return;

    // Encontrar a pergunta e atualizar a resposta
    for (int i = 0; i < checklistAtual.perguntas.length; i++) {
      if (checklistAtual.perguntas[i].id == perguntaId) {
        checklistAtual.perguntas[i].respostaSelecionada = opcaoId;
        AppLogger.d('✅ Resposta selecionada para pergunta $i',
            tag: 'ChecklistController');
        break;
      }
    }

    // Atualizar o estado
    checklist.value = checklistAtual;

    // Verificar se todas as perguntas foram respondidas
    _verificarCompletude();
  }

  /// Verifica se todas as perguntas foram respondidas
  void _verificarCompletude() {
    final checklistAtual = checklist.value;
    if (checklistAtual == null) {
      checklistCompleto.value = false;
      return;
    }

    final todasRespondidas = checklistAtual.perguntas
        .every((pergunta) => pergunta.respostaSelecionada != null);

    checklistCompleto.value = todasRespondidas;
    AppLogger.d('🔍 Checklist completo: $todasRespondidas',
        tag: 'ChecklistController');
  }

  /// Avança para a próxima pergunta
  void proximaPergunta() {
    final checklistAtual = checklist.value;
    if (checklistAtual == null) return;

    if (perguntaAtual.value < checklistAtual.perguntas.length - 1) {
      perguntaAtual.value++;
      AppLogger.d(
          '➡️ Próxima pergunta: ${perguntaAtual.value + 1}/${checklistAtual.perguntas.length}',
          tag: 'ChecklistController');
    }
  }

  /// Volta para a pergunta anterior
  void perguntaAnterior() {
    if (perguntaAtual.value > 0) {
      perguntaAtual.value--;
      AppLogger.d('⬅️ Pergunta anterior: ${perguntaAtual.value + 1}',
          tag: 'ChecklistController');
    }
  }

  /// Vai para uma pergunta específica
  void irParaPergunta(int indice) {
    final checklistAtual = checklist.value;
    if (checklistAtual == null) return;

    if (indice >= 0 && indice < checklistAtual.perguntas.length) {
      perguntaAtual.value = indice;
      AppLogger.d('🎯 Indo para pergunta: ${indice + 1}',
          tag: 'ChecklistController');
    }
  }

  /// Salva o checklist preenchido
  Future<void> salvarChecklist({double? latitude, double? longitude}) async {
    if (!checklistCompleto.value) {
      AppLogger.w('⚠️ Checklist não está completo', tag: 'ChecklistController');
      Get.snackbar('Atenção', 'Responda todas as perguntas antes de salvar');
      return;
    }

    try {
      isSaving.value = true;
      AppLogger.d('💾 Salvando checklist preenchido...',
          tag: 'ChecklistController');

      final checklistAtual = checklist.value;
      if (checklistAtual == null) {
        AppLogger.e('❌ Checklist não encontrado', tag: 'ChecklistController');
        return;
      }

      // Para EPI, precisamos passar o eletricistaRemoteId
      int? eletricistaRemoteId;
      if (_isChecklistEPI) {
        // TODO: Obter o eletricistaRemoteId do contexto atual
        // Por enquanto, vamos usar um valor padrão ou null
        eletricistaRemoteId =
            null; // Será implementado quando tivermos o contexto do eletricista
        AppLogger.d(
            '🔍 [EPI] Salvando checklist EPI com eletricistaRemoteId: $eletricistaRemoteId',
            tag: 'ChecklistController');
      }

      final sucesso = await _checklistService.salvarChecklistPreenchido(
        checklist: checklistAtual,
        perguntasRespondidas: checklistAtual.perguntas,
        latitude: latitude,
        longitude: longitude,
        eletricistaRemoteId: eletricistaRemoteId,
      );

      if (sucesso) {
        AppLogger.i('✅ Checklist salvo com sucesso',
            tag: 'ChecklistController');
        Get.snackbar('Sucesso', 'Checklist salvo com sucesso!');

        // Debug: verificar rota atual e tipo de checklist
        AppLogger.d('🔍 [NAVEGAÇÃO] Rota atual: ${Get.currentRoute}',
            tag: 'ChecklistController');
        AppLogger.d('🔍 [NAVEGAÇÃO] É EPC: $_isChecklistEPC',
            tag: 'ChecklistController');
        AppLogger.d('🔍 [NAVEGAÇÃO] É EPI: $_isChecklistEPI',
            tag: 'ChecklistController');

        // Pequeno delay para garantir que o snackbar seja exibido
        await Future.delayed(const Duration(milliseconds: 500));

        // Navegar para a próxima tela baseada no tipo de checklist
        if (_isChecklistEPC) {
          // Se é EPC, vai para lista de eletricistas (EPI)
          AppLogger.d(
              '🚀 [NAVEGAÇÃO] Navegando para lista de eletricistas (EPC → EPI)',
              tag: 'ChecklistController');
          Get.offAllNamed('/turno/checklist/eletricistas');
        } else if (_isChecklistEPI) {
          // Se é EPI, volta para lista de eletricistas
          AppLogger.d(
              '🚀 [NAVEGAÇÃO] Voltando para lista de eletricistas (EPI → Lista)',
              tag: 'ChecklistController');
          // Forçar navegação completa para evitar ficar na mesma rota
          Get.offAllNamed('/turno/checklist/eletricistas');
          // Fallback: se continuar na mesma rota, voltar
          await Future.delayed(const Duration(milliseconds: 200));
          if (Get.currentRoute == '/turno/checklist/epi') {
            AppLogger.w(
                '⚠️ [NAVEGAÇÃO] Ainda na rota EPI após navegação. Aplicando fallback Get.back()',
                tag: 'ChecklistController');
            Get.back();
          }
        } else {
          // Se é veicular, vai para EPC
          AppLogger.d('🚀 [NAVEGAÇÃO] Navegando para EPC (Veicular → EPC)',
              tag: 'ChecklistController');
          Get.offAllNamed('/turno/checklist/epc');
        }
      } else {
        AppLogger.e('❌ Erro ao salvar checklist', tag: 'ChecklistController');
        Get.snackbar('Erro', 'Erro ao salvar checklist');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao salvar checklist: $e',
          tag: 'ChecklistController', error: e, stackTrace: stackTrace);
      Get.snackbar('Erro', 'Erro ao salvar checklist: $e');
    } finally {
      isSaving.value = false;
    }
  }

  /// Recarrega o checklist
  Future<void> recarregar() async {
    AppLogger.d('🔄 Recarregando checklist...', tag: 'ChecklistController');
    await _carregarChecklist();
  }

  /// Getters para facilitar o acesso
  ChecklistCompletoModel? get checklistAtual => checklist.value;
  List<ChecklistPerguntaModel> get perguntas =>
      checklist.value?.perguntas ?? [];
  ChecklistPerguntaModel? get perguntaAtualModel {
    final perguntas = this.perguntas;
    if (perguntaAtual.value >= 0 && perguntaAtual.value < perguntas.length) {
      return perguntas[perguntaAtual.value];
    }
    return null;
  }

  int get totalPerguntas => perguntas.length;
  int get perguntaAtualIndex => perguntaAtual.value;
  bool get temPerguntaAnterior => perguntaAtual.value > 0;
  bool get temProximaPergunta => perguntaAtual.value < totalPerguntas - 1;
  bool get isUltimaPergunta => perguntaAtual.value == totalPerguntas - 1;
}
