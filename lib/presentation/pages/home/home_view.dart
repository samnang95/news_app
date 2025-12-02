import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/presentation/pages/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          // Container(child: Text(data)),
        ],
      ),
    );
  }
}
