import 'package:get/get.dart';
import 'package:nexa_app/core/domain/repositories/eletricista_repo.dart';
import 'package:nexa_app/core/domain/repositories/equipe_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_controller.dart';
import 'package:nexa_app/modules/turno/abrir/abrir_turno_service.dart';

/// Binding da tela de abrir turno.
///
/// Configura as dependências necessárias para a tela de abertura de turno.
class AbrirTurnoBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => VeiculoRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut(() => EletricistaRepo(dio: Get.find(), db: Get.find()));
    Get.lazyPut(() => EquipeRepo(dio: Get.find(), db: Get.find()));

    Get.lazyPut(() => AbrirTurnoService());
    Get.lazyPut(() => AbrirTurnoController());
  }
}

