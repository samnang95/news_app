import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskapp/app/constants/app_color.dart';
import 'package:taskapp/app/constants/app_spacing.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/presentation/pages/home/home_controller.dart';
import 'package:taskapp/presentation/pages/setting/setting_controller.dart';
import 'package:taskapp/app/models/news_item.dart';
import 'package:taskapp/app/services/bookmark_service.dart';
import 'package:taskapp/app/services/tts_service.dart';
import 'package:taskapp/app/services/local_news_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();
    final cacheService = Get.find<CacheService>();
    final bookmarkService = Get.find<BookmarkService>();
    final ttsService = Get.find<TtsService>();
    final localNewsService = Get.find<LocalNewsService>();

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
              onPressed: () async => controller.refreshNews(),
              tooltip: 'Refresh News',
            );
          }),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print("Search pressed");
            },
          ),
        ],
      ),
      body: Obx(() {
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
                  return _buildNewsCard(
                    news,
                    isTextOnly,
                    cacheService,
                    bookmarkService,
                    ttsService,
                    localNewsService,
                  );
                },
              ),
            ),

            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            }),

            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: controller.showAddNewsDialog,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: Colors.white),
                // tooltip: 'Add New News',
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNewsCard(
    NewsItem news,
    bool isTextOnly,
    CacheService cacheService,
    BookmarkService bookmarkService,
    TtsService ttsService,
    LocalNewsService localNewsService,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Image - always shown
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Builder(
                  builder: (_) {
                    // CASE 1: Local news (image stored in device)
                    if (localNewsService.isLocalNews(news.id) &&
                        news.imageUrl.isNotEmpty) {
                      // Extract file path from file:// URI
                      String filePath = news.imageUrl;
                      if (filePath.startsWith('file://')) {
                        filePath = filePath.substring(
                          7,
                        ); // Remove 'file://' prefix
                      }

                      print('Local news image path: $filePath');
                      final imageFile = File(filePath);
                      print('File exists: ${imageFile.existsSync()}');

                      return ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                          errorBuilder: (_, error, ___) {
                            print('Image load error: $error');
                            return _errorImage();
                          },
                        ),
                      );
                    }

                    // CASE 2: Remote news → Load from network with simple caching
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.network(
                        news.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            // Image loaded successfully, cache it in background
                            cacheService.cacheImage(news.imageUrl, news.id);
                            return child;
                          }
                          return _loadingImage();
                        },
                        errorBuilder: (_, error, ___) {
                          print(
                            'Network image load error for ${news.id}: $error',
                          );
                          print('Failed URL: ${news.imageUrl}');
                          // Try a fallback image
                          return Image.network(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _errorImage(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(AppSpacing.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginSmall),

                    GestureDetector(
                      onTap: () {
                        print(news.imageUrl); // or print(news.description);
                      },
                      child: Text(
                        news.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.marginMedium),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                news.source,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (localNewsService.isLocalNews(news.id))
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Local',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          news.publishedAt,
                          style: const TextStyle(
                            fontSize: 12,
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

          Positioned(
            top: AppSpacing.paddingS,
            right: AppSpacing.paddingS,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: bookmarkService.isBookmarked(news.id)
                    ? 'Remove Bookmark'
                    : 'Bookmark Article',
                icon: Icon(
                  bookmarkService.isBookmarked(news.id)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: bookmarkService.isBookmarked(news.id)
                      ? AppColors.primary
                      : Colors.white,
                ),
                onPressed: () {
                  bookmarkService.toggleBookmark(news);
                  Get.forceAppUpdate();
                  Get.snackbar(
                    bookmarkService.isBookmarked(news.id)
                        ? 'Bookmark Removed'
                        : 'Bookmarked',
                    bookmarkService.isBookmarked(news.id)
                        ? 'Article removed from bookmarks'
                        : 'Article added to bookmarks',
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
            ),
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
                tooltip: ttsService.isCurrentlyPlaying(news.id)
                    ? 'Pause Speech'
                    : ttsService.isCurrentlyPaused(news.id)
                    ? 'Resume Speech'
                    : 'Read Article Aloud',
                icon: Icon(
                  ttsService.isCurrentlyPlaying(news.id)
                      ? Icons.pause
                      : ttsService.isCurrentlyPaused(news.id)
                      ? Icons.play_arrow
                      : Icons.volume_up,
                  color:
                      (ttsService.isCurrentlyPlaying(news.id) ||
                          ttsService.isCurrentlyPaused(news.id))
                      ? AppColors.primary
                      : Colors.white,
                ),
                onPressed: () async {
                  if (ttsService.isCurrentlyPlaying(news.id)) {
                    await ttsService.pause();
                  } else if (ttsService.isCurrentlyPaused(news.id)) {
                    await ttsService.resume();
                  } else {
                    await ttsService.speakArticle(
                      news.id,
                      news.title,
                      news.description,
                    );
                  }
                  Get.forceAppUpdate();
                },
              ),
            ),
          ),

          // Edit and Delete buttons for local news
          if (localNewsService.isLocalNews(news.id)) ...[
            Positioned(
              bottom: AppSpacing.paddingS,
              left: AppSpacing.paddingS,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Edit News',
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () =>
                      controller.showAddNewsDialog(newsToEdit: news),
                ),
              ),
            ),
            Positioned(
              bottom: AppSpacing.paddingS,
              right: AppSpacing.paddingS,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Delete News',
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Delete News'),
                        content: const Text(
                          'Are you sure you want to delete this news item?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.back();
                              try {
                                await localNewsService.removeLocalNews(news.id);
                                await controller.loadNews();
                                Get.snackbar(
                                  'Deleted',
                                  'News item deleted successfully',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to delete news: $e',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _loadingImage() {
    return Container(
      color: AppColors.greyColor.withOpacity(0.3),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _errorImage() {
    return Container(
      color: AppColors.greyColor,
      child: const Icon(
        Icons.image_not_supported,
        size: 48,
        color: Colors.white,
      ),
    );
  }
}
