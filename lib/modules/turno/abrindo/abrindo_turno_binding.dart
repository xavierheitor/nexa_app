import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/abrindo/abrindo_turno_controller.dart';

/// Binding para a tela de abertura de turno.
class AbrindoTurnoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbrindoTurnoController>(() => AbrindoTurnoController());
  }
}

