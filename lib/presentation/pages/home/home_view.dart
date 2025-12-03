import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/constants/app_color.dart';
import 'package:taskapp/app/constants/app_spacing.dart';
import 'package:taskapp/app/controllers/ratio_controller.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/presentation/pages/home/home_controller.dart';
import 'package:taskapp/presentation/pages/setting/setting_controller.dart';
import 'package:taskapp/app/models/news_item.dart';
import 'package:taskapp/app/services/bookmark_service.dart';
import 'package:taskapp/app/services/tts_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await controller.refreshNews();
              },
              tooltip: 'Refresh News',
            );
          }),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Obx(() {
        final settingController = Get.find<SettingController>();
        final isTextOnly = settingController.textOnlyMode.value;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load news',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadNews,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: controller.refreshNews,
              child: ListView.builder(
                padding: EdgeInsets.all(AppSpacing.paddingM),
                itemCount: controller.newsList.length,
                itemBuilder: (context, index) {
                  final news = controller.newsList[index];
                  return _buildNewsCard(news, isTextOnly);
                },
              ),
            ),
            // Loading overlay during refresh
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }

  Widget _buildNewsCard(NewsItem news, bool isTextOnly) {
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
              // News Image - conditionally shown
              if (!isTextOnly)
                FutureBuilder<String?>(
                  future: Get.find<CacheService>().getCachedImagePath(news.id),
                  builder: (context, snapshot) {
                    final cachedPath = snapshot.data;
                    return ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          RatioController.to.scaledRadius(8),
                        ),
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
                                    height: RatioController.to.scaledHeight(
                                      200,
                                    ),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              height: RatioController.to
                                                  .scaledHeight(200),
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
                    );
                  },
                ),

              // News Content
              Padding(
                padding: EdgeInsets.all(AppSpacing.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
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

                    // Description
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

                    // Source and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ],
                ),
              ),
            ],
          ),

          // Bookmark Button
          Positioned(
            top: AppSpacing.paddingS,
            right: AppSpacing.paddingS,
            child: Obx(() {
              final bookmarkService = Get.find<BookmarkService>();
              final isBookmarked = bookmarkService.isBookmarked(news.id);
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.primary : Colors.white,
                  ),
                  onPressed: () {
                    bookmarkService.toggleBookmark(news);
                    Get.snackbar(
                      isBookmarked ? 'Bookmark Removed' : 'Bookmarked',
                      isBookmarked
                          ? 'Article removed from bookmarks'
                          : 'Article added to bookmarks',
                      duration: const Duration(seconds: 2),
                    );
                  },
                  tooltip: isBookmarked
                      ? 'Remove Bookmark'
                      : 'Bookmark Article',
                ),
              );
            }),
          ),

          // TTS Controls
          Positioned(
            top: AppSpacing.paddingS,
            left: AppSpacing.paddingS,
            child: Obx(() {
              final ttsService = Get.find<TtsService>();
              final isPlayingThis = ttsService.isCurrentlyPlaying(news.id);
              final isPausedThis = ttsService.isCurrentlyPaused(news.id);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isPlayingThis
                        ? Icons.pause
                        : isPausedThis
                        ? Icons.play_arrow
                        : Icons.volume_up,
                    color: isPlayingThis || isPausedThis
                        ? AppColors.primary
                        : Colors.white,
                  ),
                  onPressed: () async {
                    if (isPlayingThis) {
                      await ttsService.pause();
                    } else if (isPausedThis) {
                      await ttsService.resume();
                    } else {
                      await ttsService.speakArticle(
                        news.id,
                        news.title,
                        news.description,
                      );
                    }
                  },
                  tooltip: isPlayingThis
                      ? 'Pause Speech'
                      : isPausedThis
                      ? 'Resume Speech'
                      : 'Read Article Aloud',
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
