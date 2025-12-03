import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/app/models/news_item.dart';
import 'package:taskapp/app/services/notification_service.dart';

class HomeController extends GetxController {
  final CacheService _cacheService = Get.find<CacheService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final RxList<NewsItem> newsList = <NewsItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Try to load from cache first
      final cachedArticles = await _cacheService.getCachedArticles();
      if (cachedArticles != null && cachedArticles.isNotEmpty) {
        newsList.assignAll(cachedArticles);
        isLoading.value = false;
        // Load fresh data in background
        _loadFreshNews();
        return;
      }

      // No cache, load fresh data
      await _loadFreshNews();
    } catch (e) {
      hasError.value = true;
      isLoading.value = false;
    }
  }

  Future<void> _loadFreshNews() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock data - replace with actual API call
      final freshArticles = [
        NewsItem(
          id: '1',
          title: 'Breaking News: Flutter 3.0 Released',
          description:
              'Google has announced the release of Flutter 3.0 with exciting new features...',
          imageUrl: 'https://picsum.photos/400/200?random=1',
          publishedAt: '2025-12-02',
          source: 'Tech News',
        ),
        NewsItem(
          id: '2',
          title: 'GetX State Management Best Practices',
          description:
              'Learn how to effectively use GetX for state management in Flutter apps...',
          imageUrl: 'https://picsum.photos/400/200?random=2',
          publishedAt: '2025-12-01',
          source: 'Dev Blog',
        ),
        NewsItem(
          id: '3',
          title: 'Mobile App Development Trends 2025',
          description:
              'Explore the latest trends shaping mobile app development this year...',
          imageUrl: 'https://picsum.photos/400/200?random=3',
          publishedAt: '2025-11-30',
          source: 'Industry Report',
        ),
      ];

      // Cache the fresh data
      await _cacheService.cacheArticles(freshArticles);

      // Cache images for offline viewing
      for (final article in freshArticles) {
        await _cacheService.cacheImage(article.imageUrl, article.id);
      }

      // Update UI if not already showing cached data
      if (newsList.isEmpty) {
        newsList.assignAll(freshArticles);
      }

      // Show notifications for important news
      _showNotificationsForNewNews(freshArticles);
    } catch (e) {
      if (newsList.isEmpty) {
        hasError.value = true;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showNotificationsForNewNews(List<NewsItem> newArticles) {
    // Show notifications for the first few important articles
    final importantArticles = newArticles
        .take(2)
        .toList(); // Show max 2 notifications
    for (final article in importantArticles) {
      _notificationService.showBreakingNewsNotification(article);
    }
  }

  Future<void> refreshNews() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock data - replace with actual API call
      final freshArticles = [
        NewsItem(
          id: 'refresh_${DateTime.now().millisecondsSinceEpoch}_1',
          title: 'Breaking: Flutter 3.1 Released with New Features',
          description:
              'The latest Flutter update brings performance improvements and new widgets...',
          imageUrl: 'https://picsum.photos/400/200?random=refresh1',
          publishedAt: DateTime.now().toString().split(' ')[0],
          source: 'Tech News',
        ),
        NewsItem(
          id: 'refresh_${DateTime.now().millisecondsSinceEpoch}_2',
          title: 'AI Integration in Mobile Apps: Current Trends',
          description:
              'How artificial intelligence is transforming mobile application development...',
          imageUrl: 'https://picsum.photos/400/200?random=refresh2',
          publishedAt: DateTime.now().toString().split(' ')[0],
          source: 'Dev Blog',
        ),
        NewsItem(
          id: 'refresh_${DateTime.now().millisecondsSinceEpoch}_3',
          title: 'Cross-Platform Development Best Practices 2025',
          description:
              'Essential guidelines for building high-quality cross-platform applications...',
          imageUrl: 'https://picsum.photos/400/200?random=refresh3',
          publishedAt: DateTime.now().toString().split(' ')[0],
          source: 'Industry Report',
        ),
      ];

      // Update the UI with fresh data immediately
      newsList.assignAll(freshArticles);

      // Cache the fresh data in background
      _cacheService.cacheArticles(freshArticles);

      // Cache images for offline viewing in background
      for (final article in freshArticles) {
        _cacheService.cacheImage(article.imageUrl, article.id);
      }

      // Show notifications for important news
      _showNotificationsForNewNews(freshArticles);

      // Show success feedback
      Get.snackbar(
        'News Updated',
        'Latest news has been loaded successfully',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Refresh Failed',
        'Unable to load latest news. Please try again.',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
