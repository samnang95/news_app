import 'package:get/get.dart';
import 'package:taskapp/app/routes/app_routes.dart';

class SplashController extends GetxController {
  static const Duration _splashDuration = Duration(seconds: 3);

  @override
  void onReady() {
    super.onReady();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(_splashDuration);
    Get.offAllNamed(AppRoutes.nav);
  }
}
