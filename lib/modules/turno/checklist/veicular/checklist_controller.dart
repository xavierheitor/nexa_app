import 'package:get/get.dart';
import 'package:nexa_app/core/domain/models/checklist_model.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/routes/routes.dart';

/// Controller do checklist veicular.
class ChecklistController extends GetxController {
  final ChecklistService _checklistService = Get.find<ChecklistService>();

  bool get _isChecklistEPC => Get.currentRoute == Routes.turnoChecklistEPC;

  /// Checklist completo carregado.
  final Rxn<ChecklistCompletoModel> checklist = Rxn<ChecklistCompletoModel>();

  /// Estado de carregamento.
  final RxBool isLoading = false.obs;

  /// Lista de perguntas (para facilitar o acesso reativo).
  final RxList<ChecklistPerguntaModel> perguntas =
      <ChecklistPerguntaModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _carregarChecklist();
  }

  /// Carrega o checklist do turno ativo.
  Future<void> _carregarChecklist() async {
    try {
      isLoading.value = true;
      checklist.value = null;
      perguntas.clear();

      final tipoChecklistDescricao = _isChecklistEPC ? 'EPC' : 'veicular';
      AppLogger.d('📋 Carregando checklist $tipoChecklistDescricao...',
          tag: 'ChecklistController');

      final checklistCarregado = _isChecklistEPC
          ? await _checklistService.buscarChecklistEPCDoTurnoAtivo()
          : await _checklistService.buscarChecklistDoTurnoAtivo();

      if (checklistCarregado == null) {
        AppLogger.w('⚠️ Nenhum checklist encontrado',
            tag: 'ChecklistController');
        final mensagem = _isChecklistEPC
            ? 'Nenhum checklist de EPC encontrado para esta equipe'
            : 'Nenhum checklist encontrado para este veículo';
        Get.snackbar(
          'Atenção',
          mensagem,
          snackPosition: SnackPosition.BOTTOM,
        );

        if (_isChecklistEPC) {
          Get.offAllNamed(Routes.turnoServicos);
        } else {
          // Volta para a home se não encontrar checklist veicular
          Get.offAllNamed(Routes.home);
        }
        return;
      }

      final jaPreenchido = await _checklistService
          .checklistJaPreenchido(checklistCarregado.remoteId);

      if (jaPreenchido) {
        AppLogger.i(
          '✅ Checklist ${checklistCarregado.nome} já preenchido anteriormente. Pulando etapa.',
          tag: 'ChecklistController',
        );

        Get.snackbar(
          'Checklist já realizado',
          _isChecklistEPC
              ? 'Checklist de EPC já registrado para este turno'
              : 'Checklist veicular já registrado para este turno',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );

        _navegarParaProximaEtapa();
        return;
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
      Get.snackbar(
        'Erro',
        'Erro ao carregar checklist',
        snackPosition: SnackPosition.BOTTOM,
      );
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
    final naoRespondidas = perguntas.where((p) => !p.foiRespondida).toList();

    if (naoRespondidas.isNotEmpty) {
      AppLogger.w('⚠️ ${naoRespondidas.length} perguntas não respondidas',
          tag: 'ChecklistController');
      Get.snackbar(
        'Atenção',
        'Por favor, responda todas as perguntas antes de continuar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  /// Verifica se há pendências nas respostas.
  bool hasPendencias() {
    return perguntas.any(
        (p) => p.opcaoSelecionada != null && p.opcaoSelecionada!.geraPendencia);
  }

  /// Finaliza o checklist e avança para a próxima etapa.
  Future<void> finalizarChecklist() async {
    try {
      if (!validarRespostas()) {
        return;
      }

      AppLogger.d('💾 Finalizando checklist...', tag: 'ChecklistController');

      final temPendencias = hasPendencias();
      if (temPendencias) {
        AppLogger.w('⚠️ Checklist possui pendências',
            tag: 'ChecklistController');
        // TODO: Aqui você pode salvar as pendências no banco
      }

      final checklistAtual = checklist.value;
      if (checklistAtual == null) {
        AppLogger.e('❌ Checklist atual não encontrado ao finalizar',
            tag: 'ChecklistController');
        Get.snackbar(
          'Erro',
          'Não foi possível finalizar o checklist atual',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final perguntasRespondidas = perguntas.toList();

      final sucesso = await _checklistService.salvarChecklistPreenchido(
        checklist: checklistAtual,
        perguntasRespondidas: perguntasRespondidas,
      );

      if (!sucesso) {
        Get.snackbar(
          'Erro',
          'Não foi possível salvar o checklist. Tente novamente.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      AppLogger.i('✅ Checklist finalizado e salvo com sucesso',
          tag: 'ChecklistController');

      Get.snackbar(
        'Sucesso',
        temPendencias
            ? 'Checklist concluído com pendências'
            : 'Checklist concluído com sucesso',
        snackPosition: SnackPosition.BOTTOM,
      );

      _navegarParaProximaEtapa();
    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao finalizar checklist',
          tag: 'ChecklistController', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Erro',
        'Erro ao finalizar checklist',
        snackPosition: SnackPosition.BOTTOM,
      );
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
    if (_isChecklistEPC) {
      Get.offAllNamed(Routes.turnoServicos);
    } else {
      Get.offAllNamed(Routes.turnoChecklistEPC);
    }
  }
}
