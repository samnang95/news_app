import 'package:get/get.dart';
import 'package:taskapp/app/services/bookmark_service.dart';
import 'package:taskapp/app/models/news_item.dart';

class BookmarksController extends GetxController {
  final BookmarkService _bookmarkService = Get.find<BookmarkService>();

  RxList<NewsItem> get bookmarkedArticles =>
      _bookmarkService.bookmarkedArticles;

  void removeBookmark(String articleId) {
    _bookmarkService.removeBookmark(articleId);
    Get.snackbar('Bookmark Removed', 'Article removed from bookmarks');
  }

  void clearAllBookmarks() {
    _bookmarkService.clearBookmarks();
    Get.snackbar('Bookmarks Cleared', 'All bookmarks have been removed');
  }

  bool isBookmarked(String articleId) {
    return _bookmarkService.isBookmarked(articleId);
  }
}
