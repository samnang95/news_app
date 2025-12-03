import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/app/services/theme_service.dart';
import 'package:taskapp/app/themes/dark_theme.dart';
import 'package:taskapp/app/themes/light_theme.dart';

class ThemeController extends GetxController {
  final ThemeService _service = ThemeService();
  final Rx<bool> isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    await Future.delayed(Duration.zero); // Wait for ScreenUtil to initialize
    final storedTheme = await _service.getTheme();
    _applyTheme(storedTheme, persist: false);
  }

  void toggleTheme() {
    _applyTheme(!isDarkMode.value);
  }

  void setTheme(bool isDark) {
    if (isDarkMode.value == isDark) return;
    _applyTheme(isDark);
  }

  void _applyTheme(bool isDark, {bool persist = true}) {
    isDarkMode.value = isDark;
    if (persist) {
      _service.saveTheme(isDark);
    }
  }
}
