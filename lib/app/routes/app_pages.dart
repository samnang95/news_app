import 'package:taskapp/presentation/pages/home/home_page.dart';
import 'package:taskapp/presentation/pages/splash/splash_page.dart';
import 'package:taskapp/presentation/pages/nav/nav_page.dart';
import 'package:taskapp/presentation/pages/setting/setting_page.dart';

class AppPages {
  static final pages = [
    ...SplashPage.routes,
    ...HomePage.routes,
    ...NavPage.routes,
    ...SettingPage.routes,
  ];
}
