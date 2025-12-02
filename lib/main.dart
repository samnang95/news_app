import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskapp/app/constants/app_translate.dart';
import 'package:taskapp/app/controllers/Locale_controller.dart';
import 'package:taskapp/app/controllers/ratio_controller.dart';
import 'package:taskapp/app/controllers/theme_controller.dart';
import 'package:taskapp/app/routes/app_pages.dart';
import 'package:taskapp/app/services/shared_prefs_service.dart';
import 'package:taskapp/app/themes/dark_theme.dart';
import 'package:taskapp/app/themes/light_theme.dart';
import 'package:taskapp/app/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // optional

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 1️⃣ Initialize SharedPreferences service
  final sharedPrefs = SharedPrefsService();
  await sharedPrefs.init();
  Get.put(sharedPrefs, permanent: true);

  // Initialize controllers
  Get.put(ThemeController(), permanent: true);
  Get.put(RatioController());
  Get.put(LocaleController());

  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  TaskApp({super.key});

  // Controllers
  final ThemeController themeController = Get.find<ThemeController>();
  final LocaleController localeController = Get.find<LocaleController>();

  @override
  Widget build(BuildContext context) {
    // Wrap with Obx to reactively change theme or locale
    return Obx(() {
      // Access isDarkMode here explicitly so Obx can observe changes
      final isDark = themeController.isDarkMode.value;
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'NEWS APP',
            theme: isDark ? darkTheme : lightTheme,
            locale: localeController.locale.value,
            translations: AppTranslations(),
            fallbackLocale: const Locale('en'),
            supportedLocales: const [Locale('en'), Locale('km'), Locale('zh')],
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          );
        },
      );
    });
  }
}
