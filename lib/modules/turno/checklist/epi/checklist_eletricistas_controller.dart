import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/error_message_service.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/modules/turno/checklist/services/turno_abertura_orchestrator_service.dart';
import 'package:nexa_app/routes/routes.dart';

class ChecklistEletricistasController extends GetxController {
  final TurnoRepo _turnoRepo = Get.find<TurnoRepo>();
  final EletricistaRepo _eletricistaRepo = Get.find<EletricistaRepo>();
  final ChecklistService _checklistService = Get.find<ChecklistService>();
  final TurnoAberturaOrchestratorService _turnoAberturaService =
      Get.find<TurnoAberturaOrchestratorService>();
  final ErrorMessageService _errorMessageService =
      Get.find<ErrorMessageService>();

  final RxBool isLoading = false.obs;
  final RxList<EletricistaChecklistStatus> eletricistas =
      <EletricistaChecklistStatus>[].obs;
  final RxnString erro = RxnString();
  final RxBool isAbrindoTurno = false.obs;

  int get _checklistEpiRemoteId => _checklistService.checklistEpiModeloRemoteId;

  bool get todosConcluidos =>
      eletricistas.isNotEmpty && eletricistas.every((item) => item.concluido);

  @override
  void onInit() {
    super.onInit();
    carregarEletricistas();
  }

  Future<void> carregarEletricistas() async {
    try {
      isLoading.value = true;
      erro.value = null;

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

          final concluido = await _checklistService.checklistJaPreenchido(
            _checklistEpiRemoteId,
            eletricistaRemoteId: remoteId,
          );

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
      Get.snackbar(
        'Dados incompletos',
        'Eletricista sem identificador remoto. Sincronize os dados antes de continuar.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final result = await Get.toNamed(Routes.turnoChecklistEPI, arguments: {
      'eletricistaRemoteId': item.remoteId,
      'eletricistaNome': item.eletricista.nome,
    });

    if (result == true) {
      await carregarEletricistas();
    }
  }

  Future<void> abrirTurno() async {
    if (!todosConcluidos) {
      Get.snackbar(
        'Checklist pendente',
        'Finalize o checklist de EPI de todos os eletricistas antes de abrir o turno.',
        snackPosition: SnackPosition.BOTTOM,
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

      // Limpa qualquer erro anterior
      _errorMessageService.limparErro();

      Get.snackbar(
        'Turno aberto com sucesso!',
        'Todos os dados foram enviados para a API. Turno liberado para execução.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      // Navegar para tela de serviços do turno
      await Future.delayed(const Duration(seconds: 2));
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
