import 'package:get/get.dart';
import 'package:taskapp/app/services/console_service.dart';

class DebugController extends GetxController {
  final ConsoleService _consoleService = Get.find<ConsoleService>();

  void executeCommand(String command) {
    _consoleService.executeCommand(command);
  }
}
