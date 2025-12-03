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
import 'package:taskapp/presentation/pages/home/home_controller.dart';
import 'package:taskapp/presentation/pages/setting/setting_controller.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/app/services/notification_service.dart';
import 'package:taskapp/app/services/bookmark_service.dart';
import 'package:taskapp/app/services/tts_service.dart';
import 'package:taskapp/presentation/pages/bookmarks/bookmarks_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize SharedPreferences service
  final sharedPrefs = SharedPrefsService();
  await sharedPrefs.init();
  Get.put(sharedPrefs, permanent: true);

  // Initialize core controllers
  Get.put(ThemeController(), permanent: true);
  Get.put(RatioController());
  Get.put(LocaleController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => SettingController());
  Get.lazyPut(() => BookmarksController());
  Get.lazyPut(() => CacheService());
  Get.put(NotificationService(), permanent: true);
  Get.put(BookmarkService(), permanent: true);
  Get.put(TtsService(), permanent: true);

  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final localeController = Get.find<LocaleController>();
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
            supportedLocales: const [Locale('en'), Locale('zh')],
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          );
        },
      );
    });
  }
}
