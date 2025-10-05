import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_controller.dart';
import 'package:nexa_app/modules/turno/checklist/checklist_service.dart';

/// Binding para o módulo de checklist.
class ChecklistBinding extends Bindings {
  @override
  void dependencies() {
    // Service (singleton)
    Get.lazyPut<ChecklistService>(() => ChecklistService(), fenix: true);

    // Controller
    Get.lazyPut<ChecklistController>(() => ChecklistController());
  }
}

