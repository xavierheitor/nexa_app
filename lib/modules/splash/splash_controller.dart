import 'package:get/get.dart';
import 'package:nexa_app/core/core_app/session/session_manager.dart';
import 'package:nexa_app/core/utils/logger/app_logger.dart';
import 'package:nexa_app/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    AppLogger.d('🌀 Splash: onInit iniciado');

    final session = Get.find<SessionManager>();
    await session.init();

    AppLogger.d('🌀 Após init. Usuario: ${session.usuario}');

    if (!session.estaLogado) {
      AppLogger.w('🔐 Nenhum usuário logado. Indo para login.');
      await Get.offAllNamed(Routes.login);
      return;
    }
  }
}
