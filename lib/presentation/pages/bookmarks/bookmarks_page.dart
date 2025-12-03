import 'package:get/get.dart';
import 'package:taskapp/app/routes/app_routes.dart';
import 'package:taskapp/presentation/pages/bookmarks/bookmarks_view.dart';
import 'package:taskapp/presentation/pages/bookmarks/bookmarks_binding.dart';

class BookmarksPage {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.bookmarks,
      page: () => const BookmarksView(),
      binding: BookmarksBinding(),
    ),
  ];
}
