import 'package:get/get.dart';
import 'package:nexa_app/core/domain/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_controller.dart';
import 'package:nexa_app/modules/turno/checklist/veicular/checklist_service.dart';

/// Binding para o módulo de checklist.
class ChecklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChecklistModeloRepo>(
        () => ChecklistModeloRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut<ChecklistPerguntaRepo>(
        () => ChecklistPerguntaRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut<ChecklistOpcaoRespostaRepo>(
        () => ChecklistOpcaoRespostaRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut<TurnoRepo>(() => TurnoRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut<VeiculoRepo>(
        () => VeiculoRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut<EquipeRepo>(() => EquipeRepo(dio: Get.find(), db: Get.find()));

    // Service (singleton)
    Get.lazyPut<ChecklistService>(
      () => ChecklistService(
        checklistModeloRepo: Get.find<ChecklistModeloRepo>(),
        checklistPerguntaRepo: Get.find<ChecklistPerguntaRepo>(),
        checklistOpcaoRespostaRepo: Get.find<ChecklistOpcaoRespostaRepo>(),
        turnoRepo: Get.find<TurnoRepo>(),
        veiculoRepo: Get.find<VeiculoRepo>(),
        equipeRepo: Get.find<EquipeRepo>(),
      ),
      fenix: true,
    );

    // Controller
    Get.lazyPut<ChecklistController>(() => ChecklistController());
  }
}
