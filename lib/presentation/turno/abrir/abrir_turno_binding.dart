import 'package:get/get.dart';
import 'package:nexa_app/data/repositories/eletricista_repo.dart';
import 'package:nexa_app/data/repositories/equipe_repo.dart';
import 'package:nexa_app/data/repositories/veiculo_repo.dart';
import 'package:nexa_app/presentation/turno/abrir/abrir_turno_controller.dart';
import 'package:nexa_app/presentation/turno/abrir/abrir_turno_service.dart';

/// Binding da tela de abrir turno.
///
/// Configura as dependências necessárias para a tela de abertura de turno.
class AbrirTurnoBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => EletricistaRepo(dio: Get.find(), db: Get.find()),
        fenix: true);
    Get.lazyPut(() => EquipeRepo(dio: Get.find(), db: Get.find()),
        fenix: true);

    Get.lazyPut(
      () => AbrirTurnoService(
        veiculoRepo: Get.find<VeiculoRepo>(),
        eletricistaRepo: Get.find<EletricistaRepo>(),
        equipeRepo: Get.find<EquipeRepo>(),
      ),
    );
    Get.lazyPut(() => AbrirTurnoController());
  }
}

