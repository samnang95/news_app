import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/presentation/pages/home/home_view.dart';
import 'package:taskapp/presentation/pages/nav/nav_controller.dart';
import 'package:taskapp/presentation/pages/setting/setting_view.dart';

class NavView extends GetView<NavController> {
  NavView({super.key});
  final List<Widget> _pages = [HomeView(), SettingView()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: _pages[controller.selectedIndex.value],
          bottomNavigationBar: _buildBottomNavigationBar(context),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (controller.selectedIndex.value != 0) {
      controller.onTabSelected(0);
      return false;
    }
    return true;
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.selectedIndex.value,
      onTap: controller.onTabSelected,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Setting'),
      ],
    );
  }
}
