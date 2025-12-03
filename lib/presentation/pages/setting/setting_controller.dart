import 'package:get/get.dart';
import 'package:taskapp/app/services/shared_prefs_service.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/app/services/notification_service.dart';
import 'package:taskapp/app/models/news_item.dart';
import 'package:taskapp/app/services/bookmark_service.dart';

class SettingController extends GetxController {
  final SharedPrefsService _prefs = Get.find<SharedPrefsService>();
  final CacheService _cacheService = Get.find<CacheService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final BookmarkService _bookmarkService = Get.find<BookmarkService>();

  final RxBool notificationsEnabled = RxBool(true);
  final RxBool textOnlyMode = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    notificationsEnabled.value = _prefs.getBool(
      'notifications_enabled',
      defaultValue: true,
    );
    textOnlyMode.value = _prefs.getBool('text_only_mode', defaultValue: false);
    print('SettingController - loaded textOnlyMode: ${textOnlyMode.value}');
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await _prefs.setBool('notifications_enabled', value);
  }

  Future<void> toggleTextOnlyMode(bool value) async {
    textOnlyMode.value = value;
    await _prefs.setBool('text_only_mode', value);
  }

  Future<void> clearCache() async {
    await _cacheService.clearCache();
    Get.snackbar('Cache Cleared', 'App cache has been cleared successfully');
  }

  Future<void> testNotification() async {
    if (!notificationsEnabled.value) {
      Get.snackbar(
        'Notifications Disabled',
        'Please enable notifications first',
      );
      return;
    }

    await _notificationService.requestPermissions();

    // Create a test news item for notification
    final testNews = NewsItem(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Notification',
      description:
          'This is a test notification to verify your notification settings.',
      imageUrl: '',
      publishedAt: DateTime.now().toIso8601String(),
      source: 'Test',
    );

    await _notificationService.showBreakingNewsNotification(testNews);
    Get.snackbar('Test Notification Sent', 'Check your notifications');
  }

  Future<void> testBookmark() async {
    // Create a test news item for bookmarking
    final testNews = NewsItem(
      id: 'test_bookmark_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Bookmarked Article',
      description:
          'This is a test article that has been added to your bookmarks for testing purposes.',
      imageUrl: 'https://picsum.photos/400/200?random=test',
      publishedAt: DateTime.now().toIso8601String(),
      source: 'Test Source',
    );

    await _bookmarkService.addBookmark(testNews);
    Get.snackbar('Test Bookmark Added', 'Test article added to bookmarks');
  }
}
