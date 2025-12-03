import 'package:get/get.dart';
import 'package:taskapp/presentation/pages/debug/debug_view.dart';
import 'package:taskapp/presentation/pages/debug/debug_binding.dart';

class DebugPage {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: '/debug',
      page: () => const DebugView(),
      binding: DebugBinding(),
    ),
  ];
}
