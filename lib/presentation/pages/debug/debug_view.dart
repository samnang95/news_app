import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/services/console_service.dart';

class DebugView extends GetView<ConsoleService> {
  const DebugView({super.key});

  @override
  Widget build(BuildContext context) {
    final consoleService = Get.find<ConsoleService>();
    final TextEditingController commandController = TextEditingController();
    final RxList<String> commandHistory = <String>[].obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Console'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Command history
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => ListView.builder(
                  itemCount: commandHistory.length,
                  itemBuilder: (context, index) {
                    return Text(
                      commandHistory[index],
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Command input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(top: BorderSide(color: Colors.grey[700]!)),
            ),
            child: Row(
              children: [
                const Text(
                  '> ',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: commandController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter command (type "help" for commands)',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (command) {
                      if (command.trim().isNotEmpty) {
                        commandHistory.add('> $command');
                        consoleService.executeCommand(command);
                        commandController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    final command = commandController.text.trim();
                    if (command.isNotEmpty) {
                      commandHistory.add('> $command');
                      consoleService.executeCommand(command);
                      commandController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
