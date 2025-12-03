import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/constants/app_color.dart';
import 'package:taskapp/app/constants/app_spacing.dart';
import 'package:taskapp/app/controllers/ratio_controller.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/presentation/pages/bookmarks/bookmarks_controller.dart';
import 'package:taskapp/presentation/pages/setting/setting_controller.dart';
import 'package:taskapp/app/services/tts_service.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  late BookmarksController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookmarksController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _showClearAllDialog,
            tooltip: 'Clear All Bookmarks',
          ),
        ],
      ),
      body: Obx(() {
        final settingController = Get.find<SettingController>();
        final isTextOnly = settingController.textOnlyMode.value;

        if (controller.bookmarkedArticles.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Refresh bookmarks - could reload from storage if needed
            // For now, just provide haptic feedback
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: EdgeInsets.all(AppSpacing.paddingM),
            itemCount: controller.bookmarkedArticles.length,
            itemBuilder: (context, index) {
              final news = controller.bookmarkedArticles[index];
              return _buildBookmarkedNewsCard(news, isTextOnly);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: AppColors.greyColor),
          SizedBox(height: AppSpacing.marginLarge),
          Text(
            'No Bookmarks Yet',
            style: TextStyle(
              fontSize: RatioController.to.scaledFont(20),
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.marginMedium),
          Text(
            'Bookmark articles to read them later',
            style: TextStyle(
              fontSize: RatioController.to.scaledFont(16),
              color: AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.marginLarge),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to News'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkedNewsCard(dynamic news, bool isTextOnly) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RatioController.to.scaledRadius(8)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: isTextOnly
                    ? null
                    : Get.find<CacheService>().getCachedImagePath(news.id),
                builder: (context, snapshot) {
                  if (isTextOnly) return const SizedBox.shrink();
                  final cachedPath = snapshot.data;
                  return ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(RatioController.to.scaledRadius(8)),
                    ),
                    child: cachedPath != null
                        ? Image.file(
                            File(cachedPath),
                            height: RatioController.to.scaledHeight(200),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                                  news.imageUrl,
                                  height: RatioController.to.scaledHeight(200),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: RatioController.to.scaledHeight(
                                          200,
                                        ),
                                        color: AppColors.greyColor,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                      ),
                                ),
                          )
                        : Image.network(
                            news.imageUrl,
                            height: RatioController.to.scaledHeight(200),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: RatioController.to.scaledHeight(200),
                                  color: AppColors.greyColor,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                          ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: RatioController.to.scaledFont(18),
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.marginSmall),
                    Text(
                      news.description,
                      style: TextStyle(
                        fontSize: RatioController.to.scaledFont(14),
                        color: AppColors.lightTextSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.marginMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news.source,
                                style: TextStyle(
                                  fontSize: RatioController.to.scaledFont(12),
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                news.publishedAt,
                                style: TextStyle(
                                  fontSize: RatioController.to.scaledFont(12),
                                  color: AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: AppSpacing.paddingS,
            left: AppSpacing.paddingS,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.white),
                onPressed: () async {
                  final ttsService = Get.find<TtsService>();
                  await ttsService.speakArticle(
                    news.id,
                    news.title,
                    news.description,
                  );
                },
                tooltip: 'Read Article Aloud',
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.paddingS,
            right: AppSpacing.paddingS,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.white),
                onPressed: () => controller.removeBookmark(news.id),
                tooltip: 'Remove Bookmark',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text(
          'Are you sure you want to remove all bookmarked articles?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAllBookmarks();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
