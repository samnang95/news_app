import 'package:get/get.dart';

class NavController extends GetxController {
  final Rx<int> selectedIndex = Rx<int>(0);
  final Rx<String> username = Rx<String>('User');

  void onTabSelected(int index) {
    selectedIndex.value = index;
  }
}
