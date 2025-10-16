import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/modules/turno/checklist/epi/checklist_eletricistas_controller.dart';
import 'package:nexa_app/modules/turno/checklist/services/turno_abertura_orchestrator_service.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';

/// Binding responsável por preparar as dependências da listagem de eletricistas
/// para o checklist de EPI.
class ChecklistEletricistasBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();

    // Repositórios necessários para o ChecklistService
    if (!Get.isRegistered<ChecklistModeloRepo>()) {
      Get.lazyPut<ChecklistModeloRepo>(
          () => ChecklistModeloRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }
    if (!Get.isRegistered<ChecklistPerguntaRepo>()) {
      Get.lazyPut<ChecklistPerguntaRepo>(
          () => ChecklistPerguntaRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }
    if (!Get.isRegistered<ChecklistOpcaoRespostaRepo>()) {
      Get.lazyPut<ChecklistOpcaoRespostaRepo>(
          () => ChecklistOpcaoRespostaRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }
    if (!Get.isRegistered<TurnoRepo>()) {
      Get.lazyPut<TurnoRepo>(() => TurnoRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }
    if (!Get.isRegistered<VeiculoRepo>()) {
      Get.lazyPut<VeiculoRepo>(
          () => VeiculoRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }
    if (!Get.isRegistered<EquipeRepo>()) {
      Get.lazyPut<EquipeRepo>(() => EquipeRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }
    if (!Get.isRegistered<ChecklistPreenchidoRepo>()) {
      Get.lazyPut<ChecklistPreenchidoRepo>(
          () => ChecklistPreenchidoRepo(db.checklistPreenchidoDao),
          fenix: true);
    }
    if (!Get.isRegistered<ChecklistRespostaRepo>()) {
      Get.lazyPut<ChecklistRespostaRepo>(
          () => ChecklistRespostaRepo(db.checklistRespostaDao),
          fenix: true);
    }
    if (!Get.isRegistered<EletricistaRepo>()) {
      Get.lazyPut<EletricistaRepo>(
          () => EletricistaRepo(dio: Get.find(), db: Get.find()),
          fenix: true);
    }

    // Service compartilhado com outras etapas do checklist
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

    Get.lazyPut<TurnoAberturaOrchestratorService>(
        () => TurnoAberturaOrchestratorService(
              turnoRepo: Get.find<TurnoRepo>(),
              eletricistaRepo: Get.find<EletricistaRepo>(),
              checklistPreenchidoRepo: Get.find<ChecklistPreenchidoRepo>(),
              checklistRespostaRepo: Get.find<ChecklistRespostaRepo>(),
              checklistModeloRepo: Get.find<ChecklistModeloRepo>(),
              veiculoRepo: Get.find<VeiculoRepo>(),
              equipeRepo: Get.find<EquipeRepo>(),
            ),
        fenix: true);

    Get.lazyPut<ChecklistEletricistasController>(
        () => ChecklistEletricistasController());
  }
}
