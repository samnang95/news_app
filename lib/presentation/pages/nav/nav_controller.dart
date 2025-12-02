import 'package:get/get.dart';

class NavController extends GetxController {
  // final currentIndex = 0.obs;

  // final pages = [const HomeView(), const SettingView()];

  // void changeIndex(int index) => currentIndex.value = index;
  var selectedIndex = 0.obs;
  var username = 'User'.obs;

  void onTabSelected(int index) {
    selectedIndex.value = index;
  }
}
