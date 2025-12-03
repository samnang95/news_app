import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/models/news_item.dart';
import 'package:taskapp/app/services/cache_service.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CacheService _cacheService = Get.find<CacheService>();

  static const String _channelId = 'news_channel';
  static const String _channelName = 'News Notifications';
  static const String _channelDescription = 'Important news updates';

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific news item
    // For now, just navigate to home screen
    Get.offAllNamed('/nav');
  }

  Future<void> showBreakingNewsNotification(NewsItem newsItem) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      newsItem.hashCode, // Unique ID based on news item
      'Breaking News',
      newsItem.title,
      platformChannelSpecifics,
      payload: newsItem.id,
    );
  }

  Future<void> showDailyNewsDigest() async {
    final cachedNews = await _cacheService.getCachedArticles();
    if (cachedNews == null || cachedNews.isEmpty) return;

    final importantNews = _filterImportantNews(cachedNews);
    if (importantNews.isEmpty) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch, // Unique ID
      'Daily News Digest',
      'You have ${importantNews.length} important news updates',
      platformChannelSpecifics,
    );
  }

  List<NewsItem> _filterImportantNews(List<NewsItem> news) {
    // Filter news based on criteria (e.g., contains certain keywords, recent, etc.)
    // For now, return first 3 items as "important"
    return news.take(3).toList();
  }

  Future<void> scheduleNewsNotifications() async {
    // Schedule notifications for cached news
    final cachedNews = await _cacheService.getCachedArticles();
    if (cachedNews == null || cachedNews.isEmpty) return;
    final importantNews = _filterImportantNews(cachedNews);

    for (final news in importantNews) {
      // Schedule notification with some delay to avoid spam
      final delay = Duration(seconds: importantNews.indexOf(news) * 30);
      await Future.delayed(delay);
      await showBreakingNewsNotification(news);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
