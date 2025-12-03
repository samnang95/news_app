import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:taskapp/app/routes/app_routes.dart';
import 'package:taskapp/presentation/pages/splash/splash_binding.dart';
import 'package:taskapp/presentation/pages/splash/splash_view.dart';

class SplashPage {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
