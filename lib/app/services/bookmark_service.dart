import 'dart:convert';
import 'package:get/get.dart';
import 'package:taskapp/app/services/shared_prefs_service.dart';
import 'package:taskapp/app/models/news_item.dart';

class BookmarkService extends GetxService {
  final SharedPrefsService _prefs = Get.find<SharedPrefsService>();
  static const String _bookmarksKey = 'bookmarked_articles';

  final RxSet<String> bookmarkedIds = <String>{}.obs;
  final RxList<NewsItem> bookmarkedArticles = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final bookmarksJson = _prefs.getString(_bookmarksKey);
    if (bookmarksJson != null) {
      try {
        final bookmarksList = jsonDecode(bookmarksJson) as List;
        final articles = bookmarksList
            .map((json) => NewsItem.fromJson(json))
            .toList();

        bookmarkedArticles.assignAll(articles);
        bookmarkedIds.assignAll(articles.map((article) => article.id));
      } catch (e) {
        // Handle error - maybe clear corrupted data
        await clearBookmarks();
      }
    }
  }

  Future<void> toggleBookmark(NewsItem article) async {
    if (isBookmarked(article.id)) {
      await removeBookmark(article.id);
    } else {
      await addBookmark(article);
    }
  }

  Future<void> addBookmark(NewsItem article) async {
    if (!isBookmarked(article.id)) {
      bookmarkedArticles.add(article);
      bookmarkedIds.add(article.id);
      await _saveBookmarks();
    }
  }

  Future<void> removeBookmark(String articleId) async {
    bookmarkedArticles.removeWhere((article) => article.id == articleId);
    bookmarkedIds.remove(articleId);
    await _saveBookmarks();
  }

  bool isBookmarked(String articleId) {
    return bookmarkedIds.contains(articleId);
  }

  Future<void> _saveBookmarks() async {
    final bookmarksJson = bookmarkedArticles
        .map((article) => article.toJson())
        .toList();
    await _prefs.setString(_bookmarksKey, jsonEncode(bookmarksJson));
  }

  Future<void> clearBookmarks() async {
    bookmarkedArticles.clear();
    bookmarkedIds.clear();
    await _prefs.remove(_bookmarksKey);
  }

  // Get bookmarked articles sorted by most recently added
  List<NewsItem> getBookmarkedArticles() {
    return bookmarkedArticles.toList();
  }
}
