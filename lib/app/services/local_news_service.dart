import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/app/models/news_item.dart';

class LocalNewsService extends GetxService {
  static const String _localNewsKey = 'local_news';

  final RxList<NewsItem> localNews = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalNews();
  }

  Future<void> loadLocalNews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localNewsJson = prefs.getStringList(_localNewsKey) ?? [];

      localNews.value = localNewsJson
          .map((json) => NewsItem.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading local news: $e');
    }
  }

  Future<String?> saveImageToLocal(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/local_news_images');

      // Create directory if it doesn't exist
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Generate unique filename
      final fileName =
          'local_news_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localPath = '${imageDir.path}/$fileName';

      // Copy image to local storage
      await imageFile.copy(localPath);

      return localPath;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  Future<void> addLocalNews(NewsItem news, {File? imageFile}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Handle image if provided
      String imageUrl = news.imageUrl;
      if (imageFile != null) {
        final localImagePath = await saveImageToLocal(imageFile);
        if (localImagePath != null) {
          imageUrl = 'file://$localImagePath';
        }
      }

      // Generate a unique ID for local news
      final localNewsId = 'local_${DateTime.now().millisecondsSinceEpoch}';
      final localNewsItem = NewsItem(
        id: localNewsId,
        title: news.title,
        description: news.description,
        imageUrl: imageUrl,
        source: news.source,
        publishedAt: news.publishedAt,
      );

      localNews.add(localNewsItem);

      // Save to SharedPreferences
      final localNewsJson = localNews
          .map((item) => jsonEncode(item.toJson()))
          .toList();

      await prefs.setStringList(_localNewsKey, localNewsJson);
    } catch (e) {
      print('Error adding local news: $e');
      throw Exception('Failed to add news');
    }
  }

  Future<void> removeLocalNews(String id) async {
    try {
      localNews.removeWhere((news) => news.id == id);

      final prefs = await SharedPreferences.getInstance();
      final localNewsJson = localNews
          .map((item) => jsonEncode(item.toJson()))
          .toList();

      await prefs.setStringList(_localNewsKey, localNewsJson);
    } catch (e) {
      print('Error removing local news: $e');
      throw Exception('Failed to remove news');
    }
  }

  Future<void> updateLocalNews(
    NewsItem updatedNews, {
    File? newImageFile,
  }) async {
    try {
      // Handle image if provided
      String imageUrl = updatedNews.imageUrl;
      if (newImageFile != null) {
        final localImagePath = await saveImageToLocal(newImageFile);
        if (localImagePath != null) {
          imageUrl = 'file://$localImagePath';
        }
      }

      // Find and update the news item
      final index = localNews.indexWhere((n) => n.id == updatedNews.id);
      if (index != -1) {
        localNews[index] = NewsItem(
          id: updatedNews.id,
          title: updatedNews.title,
          description: updatedNews.description,
          imageUrl: imageUrl,
          source: updatedNews.source,
          publishedAt: updatedNews.publishedAt,
        );

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final localNewsJson = localNews
            .map((item) => jsonEncode(item.toJson()))
            .toList();
        await prefs.setStringList(_localNewsKey, localNewsJson);

        print('Updated local news: ${updatedNews.title}');
      }
    } catch (e) {
      print('Error updating local news: $e');
      throw Exception('Failed to update news');
    }
  }

  // Console methods for debugging
  Future<void> printLocalNews() async {
    print('Local News Items:');
    for (var news in localNews) {
      print('ID: ${news.id}, Title: ${news.title}, Image: ${news.imageUrl}');
    }
  }

  Future<void> clearAllLocalNews() async {
    try {
      localNews.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localNewsKey);
      print('Cleared all local news from SharedPreferences');
    } catch (e) {
      print('Error clearing local news: $e');
    }
  }

  bool isLocalNews(String id) {
    return id.startsWith('local_');
  }
}
