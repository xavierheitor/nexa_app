import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_loading_controller.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_orchestrator.dart';

/// Binding para a tela de loading de navegação do turno.
class TurnoNavigationLoadingBinding extends Bindings {
  @override
  void dependencies() {
    // Repositórios (se não estiverem registrados)
    if (!Get.isRegistered<TurnoRepo>()) {
      Get.lazyPut<TurnoRepo>(
        () => TurnoRepo(dio: Get.find<DioClient>(), db: Get.find<AppDatabase>()),
        fenix: true,
      );
    }

    // ChecklistService (se não estiver registrado)
    if (!Get.isRegistered<ChecklistService>()) {
      Get.lazyPut<ChecklistService>(
        () => ChecklistService(
          checklistModeloRepo: Get.find(),
          checklistPerguntaRepo: Get.find(),
          checklistOpcaoRespostaRepo: Get.find(),
          turnoRepo: Get.find(),
          veiculoRepo: Get.find(),
          equipeRepo: Get.find(),
          checklistPreenchidoRepo: Get.find(),
          checklistRespostaRepo: Get.find(),
        ),
        fenix: true,
      );
    }

    // Orchestrator
    Get.lazyPut<TurnoNavigationOrchestrator>(
      () => TurnoNavigationOrchestrator(
        turnoRepo: Get.find<TurnoRepo>(),
        checklistService: Get.find<ChecklistService>(),
      ),
    );

    // Controller
    Get.lazyPut<TurnoNavigationLoadingController>(
      () => TurnoNavigationLoadingController(
        orchestrator: Get.find<TurnoNavigationOrchestrator>(),
      ),
    );
  }
}

