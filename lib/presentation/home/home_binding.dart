import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/services/auth_service.dart';
import 'package:nexa_app/core/core_app/services/sync_service.dart';
import 'package:nexa_app/core/security/session_manager.dart';
import 'package:nexa_app/presentation/home/home_controller.dart';

/// Binding responsável pela injeção de dependências da tela Home.
///
/// Configura todas as dependências necessárias para o funcionamento
/// adequado da tela principal, incluindo controladores e serviços.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    /// Injeta o HomeController com suas dependências.
    Get.lazyPut(
      () => HomeController(
        sessionManager: Get.find<SessionManager>(),
        authService: Get.find<AuthService>(),
        syncService: Get.find<SyncService>(),
      ),
    );
  }
}
