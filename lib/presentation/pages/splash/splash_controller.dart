import 'package:get/get.dart';
import 'dart:async';
// import 'package:flutter/scheduler.dart';
import 'package:taskapp/app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Wait 3 seconds and navigate
    Future.delayed(const Duration(seconds: 3), () {
      // Force route replacement -- use offAllNamed to clear route stack
      Get.offAllNamed(AppRoutes.nav);
    });
  }
}
