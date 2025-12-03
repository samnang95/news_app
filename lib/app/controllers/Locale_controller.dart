import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  final Rx<Locale> locale = Rx<Locale>(const Locale('en'));
  final List<String> supportedLanguages = ['en', 'zh'];

  @override
  void onInit() {
    super.onInit();
    // Ensure current locale is supported
    if (!supportedLanguages.contains(locale.value.languageCode)) {
      changeLocale(const Locale('en'));
    }
  }

  void changeLocale(Locale newLocale) {
    if (supportedLanguages.contains(newLocale.languageCode)) {
      locale.value = newLocale;
      Get.updateLocale(newLocale);
    }
  }
}
