import 'package:get/get.dart';
import 'package:taskapp/presentation/pages/nav/nav_controller.dart';

class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(() => NavController());
  }
}
