import 'package:get/get.dart';
import 'package:taskapp/app/routes/app_routes.dart';
import 'package:taskapp/presentation/pages/nav/nav_binding.dart';
import 'package:taskapp/presentation/pages/nav/nav_view.dart';

class NavPage {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: AppRoutes.nav, page: () => NavView(), binding: NavBinding()),
  ];
}
