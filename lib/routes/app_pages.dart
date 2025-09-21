import 'package:get/get.dart';
import 'package:nexa_app/core/middlewares/auth_middleware.dart';
import 'package:nexa_app/modules/home/home_binding.dart';
import 'package:nexa_app/modules/home/home_page.dart';
import 'package:nexa_app/routes/routes.dart';

class AppPages {
  static const String initial = Routes.home;

  static final routes = [
    GetPage(
        name: Routes.home,
        page: () => const HomePage(),
        binding: HomeBinding(),
        middlewares: [AuthMiddleware()]),
  ];
}
