import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {'hello': 'Hello', 'tasks': 'Tasks'},
    'km': {'hello': 'សួស្តី', 'tasks': 'ការងារ'},
    'zh': {'hello': '你好', 'tasks': '任务'},
  };
}
