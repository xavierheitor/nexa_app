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

  /// Carrega o checklist do turno ativo
  Future<void> _carregarChecklist() async {
    try {
      isLoading.value = true;
      AppLogger.d('🔄 Carregando checklist...', tag: 'ChecklistController');

      final checklistCompleto =
          await _checklistService.buscarChecklistDoTurnoAtivo();
      
      if (checklistCompleto != null) {
        this.checklist.value = checklistCompleto;
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

      final sucesso = await _checklistService.salvarChecklistPreenchido(
        checklist: checklistAtual,
        perguntasRespondidas: checklistAtual.perguntas,
        latitude: latitude,
        longitude: longitude,
      );

      if (sucesso) {
        AppLogger.i('✅ Checklist salvo com sucesso',
            tag: 'ChecklistController');
        Get.snackbar('Sucesso', 'Checklist salvo com sucesso!');

        // Navegar para a próxima tela ou voltar
        Get.back();
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
