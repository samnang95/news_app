import 'package:get/get.dart';
import 'package:taskapp/app/services/database_service.dart';
import 'package:taskapp/app/models/news_item.dart';

class BookmarkService extends GetxService {
  final DatabaseService _databaseService = DatabaseService.instance;

  final RxSet<String> bookmarkedIds = <String>{}.obs;
  final RxList<NewsItem> bookmarkedArticles = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      bookmarkedIds.assignAll(await _databaseService.getBookmarkedNewsIds());
      print('Loaded ${bookmarkedIds.length} bookmarked items from database');
    } catch (e) {
      print('Error loading bookmarks: $e');
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
      try {
        await _databaseService.addBookmark(article.id);
        bookmarkedIds.add(article.id);
        bookmarkedArticles.add(article);
        print('Added bookmark for article: ${article.title}');
      } catch (e) {
        print('Error adding bookmark: $e');
      }
    }
  }

  Future<void> removeBookmark(String articleId) async {
    try {
      await _databaseService.removeBookmark(articleId);
      bookmarkedIds.remove(articleId);
      bookmarkedArticles.removeWhere((article) => article.id == articleId);
      print('Removed bookmark for article ID: $articleId');
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

  bool isBookmarked(String articleId) {
    return bookmarkedIds.contains(articleId);
  }

  Future<void> clearBookmarks() async {
    try {
      // Clear all bookmarks from database
      List<String> bookmarks = await _databaseService.getBookmarkedNewsIds();
      for (String newsId in bookmarks) {
        await _databaseService.removeBookmark(newsId);
      }

      bookmarkedArticles.clear();
      bookmarkedIds.clear();
      print('Cleared all bookmarks from database');
    } catch (e) {
      print('Error clearing bookmarks: $e');
    }
  }

  // Get bookmarked articles sorted by most recently added
  List<NewsItem> getBookmarkedArticles() {
    return bookmarkedArticles.toList();
  }

  // Console methods for debugging
  Future<void> printBookmarks() async {
    await _databaseService.printBookmarks();
  }
}
