import 'package:get/get.dart';
import 'package:nexa_app/core/domain/dto/eletricista_table_dto.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/routes/routes.dart';

class ChecklistEletricistasController extends GetxController {
  final TurnoRepo _turnoRepo = Get.find<TurnoRepo>();
  final EletricistaRepo _eletricistaRepo = Get.find<EletricistaRepo>();
  final ChecklistService _checklistService = Get.find<ChecklistService>();

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

      AppLogger.d('🚀 Iniciando processo de abertura de turno',
          tag: 'ChecklistEletricistasController');

      // Navegar para a splash de abertura de turno
      Get.offAllNamed(Routes.turnoAbrindo);

    } catch (e, stackTrace) {
      AppLogger.e('❌ Erro ao iniciar abertura do turno',
          tag: 'ChecklistEletricistasController', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Erro',
        'Não foi possível iniciar a abertura do turno. Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAbrindoTurno.value = false;
    }
  }

  void _irParaServicos() {
    Get.offAllNamed(Routes.turnoServicos);
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
