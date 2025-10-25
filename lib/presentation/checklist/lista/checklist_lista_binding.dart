import 'package:get/get.dart';
import 'package:nexa_app/presentation/checklist/lista/checklist_lista_controller.dart';

/// Binding para a tela de listagem de checklists.
///
/// Este binding é responsável por injetar as dependências necessárias
/// para a tela de listagem de checklists preenchidos do turno.
///
/// ## Dependências Injetadas:
///
/// - `ChecklistListaController`: Controller principal da tela
///
/// ## Uso:
///
/// ```dart
/// GetPage(
///   name: Routes.checklistLista,
///   page: () => const ChecklistListaPage(),
///   binding: ChecklistListaBinding(),
/// ),
/// ```
class ChecklistListaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChecklistListaController>(
      () => ChecklistListaController(),
    );
  }
}
