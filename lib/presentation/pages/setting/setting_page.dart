import 'package:get/get.dart';
import 'package:taskapp/app/routes/app_routes.dart';
import 'package:taskapp/presentation/pages/setting/setting_binding.dart';
import 'package:taskapp/presentation/pages/setting/setting_view.dart';

class SettingPage {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.setting,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
  ];
}
