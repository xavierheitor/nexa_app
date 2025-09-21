import 'package:get/get.dart';
import 'package:nexa_app/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.login);
    });
  }
}
