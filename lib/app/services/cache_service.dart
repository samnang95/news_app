import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskapp/app/services/shared_prefs_service.dart';
import 'package:taskapp/app/models/news_item.dart';

class CacheService {
  final SharedPrefsService _prefs = Get.find<SharedPrefsService>();
  static const String _articlesKey = 'cached_articles';

  Future<String> _getCacheDir() async {
    final dir = await getApplicationCacheDirectory();
    return dir.path;
  }

  Future<void> cacheArticles(List<NewsItem> articles) async {
    final articlesJson = articles.map((article) => article.toJson()).toList();
    await _prefs.setString(_articlesKey, jsonEncode(articlesJson));
  }

  Future<List<NewsItem>?> getCachedArticles() async {
    final cached = _prefs.getString(_articlesKey);
    if (cached == null) return null;

    try {
      final articlesJson = jsonDecode(cached) as List;
      return articlesJson.map((json) => NewsItem.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<String?> cacheImage(String imageUrl, String imageId) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final cacheDir = await _getCacheDir();
        final fileName = 'image_$imageId.jpg';
        final filePath = '$cacheDir/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<String?> getCachedImagePath(String imageId) async {
    final cacheDir = await _getCacheDir();
    final fileName = 'image_$imageId.jpg';
    final filePath = '$cacheDir/$fileName';
    final file = File(filePath);
    if (await file.exists()) {
      return filePath;
    }
    return null;
  }

  Future<void> clearCache() async {
    // Clear cached articles
    await _prefs.remove(_articlesKey);

    // Clear cached images
    final cacheDir = await _getCacheDir();
    final dir = Directory(cacheDir);
    if (await dir.exists()) {
      final files = dir.listSync();
      for (final file in files) {
        if (file is File && file.path.endsWith('.jpg')) {
          await file.delete();
        }
      }
    }
  }
}
