import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/constants/app_color.dart';
// import 'package:taskapp/app/routes/app_routes.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo.jpg",
              scale: 10,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 48),
            ),
          ),
          Text(
            "NEWS APP",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          // Hide progress indicator by default but make sure navigation
          // happens from the controller after 3 seconds. This will help
          // visually indicate something is happening.
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
