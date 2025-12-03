import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/constants/app_color.dart';
import 'package:taskapp/app/constants/app_spacing.dart';
import 'package:taskapp/app/controllers/Locale_controller.dart';
import 'package:taskapp/app/controllers/ratio_controller.dart';
import 'package:taskapp/app/controllers/theme_controller.dart';
import 'package:taskapp/presentation/pages/setting/setting_controller.dart';
import 'package:taskapp/app/services/tts_service.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final themeController = Get.find<ThemeController>();
        final localeController = Get.find<LocaleController>();

        return ListView(
          padding: EdgeInsets.all(AppSpacing.paddingM),
          children: [
            _buildSectionTitle('Appearance'),
            _buildThemeToggle(themeController),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('Language'),
            _buildLanguageSelector(localeController),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('Data & Performance'),
            _buildTextOnlyModeToggle(),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('Notifications'),
            _buildNotificationsToggle(),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('Text-to-Speech'),
            _buildTtsSettings(),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('Storage'),
            _buildClearCacheButton(),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('Test Features'),
            _buildTestNotificationButton(),
            _buildTestBookmarkButton(),
            SizedBox(height: AppSpacing.marginMedium),

            _buildSectionTitle('About'),
            _buildAboutSection(),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
      child: Text(
        title,
        style: TextStyle(
          fontSize: RatioController.to.scaledFont(16),
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildThemeToggle(ThemeController themeController) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: ListTile(
        leading: Icon(
          themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
          color: AppColors.primary,
        ),
        title: const Text('Dark Mode'),
        trailing: Switch(
          value: themeController.isDarkMode.value,
          onChanged: (value) => themeController.setTheme(value),
          activeThumbColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(LocaleController localeController) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primary),
            title: const Text('Language'),
            subtitle: Text(_getLanguageName(localeController.locale.value)),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLanguageButton('en', 'English', localeController),
                _buildLanguageButton('km', 'ខ្មែរ', localeController),
                _buildLanguageButton('zh', '中文', localeController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    String code,
    String name,
    LocaleController localeController,
  ) {
    final isSelected = localeController.locale.value.languageCode == code;
    return ElevatedButton(
      onPressed: () => localeController.changeLocale(Locale(code)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            RatioController.to.scaledRadius(8),
          ),
        ),
      ),
      child: Text(name),
    );
  }

  Widget _buildTextOnlyModeToggle() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: ListTile(
        leading: const Icon(Icons.text_fields, color: AppColors.primary),
        title: const Text('Text-Only Mode'),
        subtitle: const Text('Save data by hiding images'),
        trailing: Switch(
          value: controller.textOnlyMode.value,
          onChanged: controller.toggleTextOnlyMode,
          activeThumbColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildNotificationsToggle() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: AppColors.primary),
        title: const Text('Notifications'),
        subtitle: const Text('Enable push notifications'),
        trailing: Switch(
          value: controller.notificationsEnabled.value,
          onChanged: controller.toggleNotifications,
          activeThumbColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildClearCacheButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: ListTile(
        leading: const Icon(Icons.cleaning_services, color: AppColors.primary),
        title: const Text('Clear Cache'),
        subtitle: const Text('Free up storage space'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: controller.clearCache,
          color: AppColors.error,
        ),
      ),
    );
  }

  Widget _buildTestNotificationButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.notifications_active,
          color: AppColors.primary,
        ),
        title: const Text('Test Notification'),
        subtitle: const Text('Send a test notification'),
        trailing: IconButton(
          icon: const Icon(Icons.send),
          onPressed: controller.testNotification,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'News App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.marginSmall),
            const Text('Version 1.0.0'),
            SizedBox(height: AppSpacing.marginSmall),
            const Text(
              'Stay updated with the latest news from around the world.',
            ),
            SizedBox(height: AppSpacing.marginMedium),
            Center(
              child: Text(
                '© 2025 News App Team',
                style: TextStyle(
                  fontSize: RatioController.to.scaledFont(12),
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestBookmarkButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: ListTile(
        leading: const Icon(Icons.bookmark_border, color: AppColors.primary),
        title: const Text('Test Bookmark'),
        subtitle: const Text('Add a test article to bookmarks'),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: controller.testBookmark,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTtsSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volume_up, color: AppColors.primary),
                SizedBox(width: AppSpacing.marginSmall),
                const Text(
                  'Voice Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.marginMedium),

            // Speech Rate
            Obx(() {
              final ttsService = Get.find<TtsService>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Speech Rate: ${(ttsService.speechRate.value * 100).round()}%',
                    style: TextStyle(
                      fontSize: RatioController.to.scaledFont(14),
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Slider(
                    value: ttsService.speechRate.value,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    onChanged: (value) => ttsService.setSpeechRate(value),
                    activeColor: AppColors.primary,
                  ),
                ],
              );
            }),

            SizedBox(height: AppSpacing.marginMedium),

            // Volume
            Obx(() {
              final ttsService = Get.find<TtsService>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volume: ${(ttsService.volume.value * 100).round()}%',
                    style: TextStyle(
                      fontSize: RatioController.to.scaledFont(14),
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Slider(
                    value: ttsService.volume.value,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: (value) => ttsService.setVolume(value),
                    activeColor: AppColors.primary,
                  ),
                ],
              );
            }),

            SizedBox(height: AppSpacing.marginMedium),

            // Pitch
            Obx(() {
              final ttsService = Get.find<TtsService>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pitch: ${ttsService.pitch.value.toStringAsFixed(1)}x',
                    style: TextStyle(
                      fontSize: RatioController.to.scaledFont(14),
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  Slider(
                    value: ttsService.pitch.value,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    onChanged: (value) => ttsService.setPitch(value),
                    activeColor: AppColors.primary,
                  ),
                ],
              );
            }),

            SizedBox(height: AppSpacing.marginMedium),

            // Stop TTS Button
            Obx(() {
              final ttsService = Get.find<TtsService>();
              final isPlaying = ttsService.isPlaying.value;
              final isPaused = ttsService.isPaused.value;

              if (isPlaying || isPaused) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () => ttsService.stop(),
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Speech'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'km':
        return 'ខ្មែរ (Khmer)';
      case 'zh':
        return '中文 (Chinese)';
      default:
        return 'English';
    }
  }
}
