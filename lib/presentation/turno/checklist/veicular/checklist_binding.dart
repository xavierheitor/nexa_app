import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/data/repositories/checklist_modelo_repo.dart';
import 'package:nexa_app/data/repositories/checklist_opcao_resposta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_pergunta_repo.dart';
import 'package:nexa_app/data/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/data/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/turno_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_controller.dart';
import 'package:nexa_app/presentation/turno/checklist/veicular/checklist_service.dart';

/// Binding para o módulo de checklist.
class ChecklistBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();

    // Repositórios com fenix: true para não serem deletados da memória
    Get.lazyPut<ChecklistModeloRepo>(
      () => ChecklistModeloRepo(dio: Get.find(), db: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ChecklistPerguntaRepo>(
      () => ChecklistPerguntaRepo(dio: Get.find(), db: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ChecklistOpcaoRespostaRepo>(
      () => ChecklistOpcaoRespostaRepo(dio: Get.find(), db: Get.find()),
      fenix: true,
    );
    Get.lazyPut<TurnoRepo>(
      () => TurnoRepo(dio: Get.find(), db: Get.find()),
      fenix: true,
    );
    Get.lazyPut<VeiculoRepo>(
      () => VeiculoRepo(dio: Get.find(), db: Get.find()),
      fenix: true,
    );
    Get.lazyPut<EquipeRepo>(
      () => EquipeRepo(dio: Get.find(), db: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ChecklistPreenchidoRepo>(
      () => ChecklistPreenchidoRepo(db.checklistPreenchidoDao),
      fenix: true,
    );
    Get.lazyPut<ChecklistRespostaRepo>(
      () => ChecklistRespostaRepo(db.checklistRespostaDao),
      fenix: true,
    );

    // Service (singleton com fenix: true)
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

    // Controller (sem fenix - pode ser recriado a cada vez)
    Get.lazyPut<ChecklistController>(() => ChecklistController());
  }
}
