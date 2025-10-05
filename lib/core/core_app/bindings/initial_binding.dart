import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/controllers/turno_controller.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/database/app_database.dart';
import 'package:nexa_app/core/domain/repositories/turno_repo.dart';
import 'package:nexa_app/core/domain/repositories/usuario_repo.dart';
import 'package:nexa_app/core/domain/repositories/veiculo_repo.dart';
import 'package:nexa_app/core/domain/repositories/tipo_veiculo_repo.dart';
import 'package:nexa_app/core/utils/network/dio_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // === Core (DB, API) ===
    // Banco local (Drift) e cliente HTTP (Dio)
    Get.put(AppDatabase(), permanent: true);
    Get.put(DioClient(), permanent: true);

    // === Repositories ===
    // Abstração de acesso a dados e APIs
    Get.lazyPut(() => UsuarioRepo(dio: Get.find(), db: Get.find()),
        fenix: true);
    Get.lazyPut(() => VeiculoRepo(dio: Get.find(), db: Get.find()),
        fenix: true);
    Get.lazyPut(() => TipoVeiculoRepo(dio: Get.find(), db: Get.find()),
        fenix: true);
    Get.lazyPut(() => TurnoRepo(dio: Get.find(), db: Get.find()), fenix: true);

    // === Services ===
    // Lógica de negócio centralizada
    Get.lazyPut(() => AuthService(usuarioRepo: Get.find()), fenix: true);
    Get.lazyPut(() => SyncService(), fenix: true);

    // === Session Manager ===
    // Gerenciador centralizado de sessão
    Get.put(SessionManager(authService: Get.find()), permanent: true);

    // === Gerenciamento de turno ===
    Get.put(TurnoController(), permanent: true);
  }
}
