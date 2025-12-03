import 'package:get/get.dart';
import 'package:taskapp/presentation/pages/bookmarks/bookmarks_controller.dart';

class BookmarksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarksController>(() => BookmarksController());
  }
}
