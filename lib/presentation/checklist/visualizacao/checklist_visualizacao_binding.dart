import 'package:get/get.dart';
import 'package:nexa_app/presentation/checklist/visualizacao/checklist_visualizacao_controller.dart';

/// Binding para a tela de visualização de checklist.
///
/// Este binding é responsável por injetar as dependências necessárias
/// para a tela de visualização detalhada de um checklist.
///
/// ## Dependências Injetadas:
///
/// - `ChecklistVisualizacaoController`: Controller principal da tela
///
/// ## Uso:
///
/// ```dart
/// GetPage(
///   name: Routes.checklistVisualizacao,
///   page: () => const ChecklistVisualizacaoPage(),
///   binding: ChecklistVisualizacaoBinding(),
/// ),
/// ```
class ChecklistVisualizacaoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChecklistVisualizacaoController>(
      () => ChecklistVisualizacaoController(),
    );
  }
}
