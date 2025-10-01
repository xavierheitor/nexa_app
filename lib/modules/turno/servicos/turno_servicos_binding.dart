import 'package:get/get.dart';
import 'package:nexa_app/modules/turno/servicos/turno_servicos_controller.dart';

/// Binding da tela de serviços do turno.
///
/// Configura as dependências necessárias para a tela de serviços.
class TurnoServicosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TurnoServicosController());
  }
}

