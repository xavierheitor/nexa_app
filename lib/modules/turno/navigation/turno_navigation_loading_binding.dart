import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_loading_controller.dart';
import 'package:nexa_app/modules/turno/navigation/turno_navigation_orchestrator.dart';

/// Binding para a tela de loading de navegação do turno.
///
/// Registra todas as dependências necessárias para o sistema de navegação
/// inteligente de turnos, incluindo repositórios e services.
class TurnoNavigationLoadingBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();
    final dio = Get.find<DioClient>();

    // ========================================================================
    // REPOSITÓRIOS BASE
    // ========================================================================

    if (!Get.isRegistered<TurnoRepo>()) {
      Get.lazyPut<TurnoRepo>(
        () => TurnoRepo(dio: dio, db: db),
        fenix: true,
      );
    }

    if (!Get.isRegistered<VeiculoRepo>()) {
      Get.lazyPut<VeiculoRepo>(
        () => VeiculoRepo(dio: dio, db: db),
        fenix: true,
      );
    }

    if (!Get.isRegistered<EquipeRepo>()) {
      Get.lazyPut<EquipeRepo>(
        () => EquipeRepo(dio: dio, db: db),
        fenix: true,
      );
    }

    // ========================================================================
    // REPOSITÓRIOS DE CHECKLIST
    // ========================================================================

    if (!Get.isRegistered<ChecklistModeloRepo>()) {
      Get.lazyPut<ChecklistModeloRepo>(
        () => ChecklistModeloRepo(dio: dio, db: db),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ChecklistPerguntaRepo>()) {
      Get.lazyPut<ChecklistPerguntaRepo>(
        () => ChecklistPerguntaRepo(dio: dio, db: db),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ChecklistOpcaoRespostaRepo>()) {
      Get.lazyPut<ChecklistOpcaoRespostaRepo>(
        () => ChecklistOpcaoRespostaRepo(dio: dio, db: db),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ChecklistPreenchidoRepo>()) {
      Get.lazyPut<ChecklistPreenchidoRepo>(
        () => ChecklistPreenchidoRepo(db.checklistPreenchidoDao),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ChecklistRespostaRepo>()) {
      Get.lazyPut<ChecklistRespostaRepo>(
        () => ChecklistRespostaRepo(db.checklistRespostaDao),
        fenix: true,
      );
    }

    // ========================================================================
    // CHECKLIST SERVICE
    // ========================================================================

    if (!Get.isRegistered<ChecklistService>()) {
      Get.lazyPut<ChecklistService>(
        () => ChecklistService(
          checklistModeloRepo: Get.find<ChecklistModeloRepo>(),
          checklistPerguntaRepo: Get.find<ChecklistPerguntaRepo>(),
          checklistOpcaoRespostaRepo: Get.find<ChecklistOpcaoRespostaRepo>(),
          turnoRepo: Get.find<TurnoRepo>(),
          veiculoRepo: Get.find<VeiculoRepo>(),
          equipeRepo: Get.find<EquipeRepo>(),
          checklistPreenchidoRepo: Get.find<ChecklistPreenchidoRepo>(),
          checklistRespostaRepo: Get.find<ChecklistRespostaRepo>(),
        ),
        fenix: true,
      );
    }

    // ========================================================================
    // ORCHESTRATOR E CONTROLLER
    // ========================================================================

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

