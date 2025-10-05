import 'package:get/get.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/repositories/checklist_preenchido_repo.dart';
import 'package:nexa_app/core/domain/repositories/checklist_resposta_repo.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_controller.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_service.dart';

class ChecklistBinding extends Bindings {
  @override
  void dependencies() {
    // Injetar dependências
    Get.lazyPut<AppDatabase>(() => AppDatabase());
    
    // Repositórios
    Get.lazyPut<ChecklistPreenchidoRepo>(() {
      final db = Get.find<AppDatabase>();
      return ChecklistPreenchidoRepo(db.checklistPreenchidoDao);
    });

    Get.lazyPut<ChecklistRespostaRepo>(() {
      final db = Get.find<AppDatabase>();
      return ChecklistRespostaRepo(db.checklistRespostaDao);
    });
    
    // Serviço
    Get.lazyPut<ChecklistService>(() {
      final db = Get.find<AppDatabase>();
      final checklistPreenchidoRepo = Get.find<ChecklistPreenchidoRepo>();
      final checklistRespostaRepo = Get.find<ChecklistRespostaRepo>();
      return ChecklistService(
          db, checklistPreenchidoRepo, checklistRespostaRepo);
    });
    
    // Controller
    Get.lazyPut<ChecklistController>(() {
      final checklistService = Get.find<ChecklistService>();
      return ChecklistController(checklistService);
    });
  }
}
