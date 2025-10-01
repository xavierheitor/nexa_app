import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_controller.dart';

/// Binding da tela de abrir turno.
///
/// Configura as dependências necessárias para a tela de abertura de turno.
class AbrirTurnoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AbrirTurnoController());
  }
}

