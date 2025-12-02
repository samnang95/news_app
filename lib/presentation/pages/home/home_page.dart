import 'package:get/get.dart';
import 'package:taskapp/app/routes/app_routes.dart';
import 'package:taskapp/presentation/pages/home/home_binding.dart';
import 'package:taskapp/presentation/pages/home/home_view.dart';

class HomePage {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
