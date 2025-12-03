import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskapp/app/services/cache_service.dart';
import 'package:taskapp/app/models/news_item.dart';
import 'package:taskapp/app/services/notification_service.dart';
import 'package:taskapp/app/services/local_news_service.dart';

class HomeController extends GetxController {
  final CacheService _cacheService = Get.find<CacheService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final LocalNewsService _localNewsService = Get.find<LocalNewsService>();
  final RxList<NewsItem> newsList = <NewsItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load local news first
      await _localNewsService.loadLocalNews();

      // Try to load from cache first
      final cachedArticles = await _cacheService.getCachedArticles();
      if (cachedArticles != null && cachedArticles.isNotEmpty) {
        // Combine local news with cached API news
        final combinedNews = [
          ..._localNewsService.localNews,
          ...cachedArticles,
        ];
        newsList.assignAll(combinedNews);
        isLoading.value = false;
        // Load fresh data in background
        _loadFreshNews();
        return;
      }

      // No cache, load fresh data and combine with local news
      await _loadFreshNews();
    } catch (e) {
      hasError.value = true;
      isLoading.value = false;
    }
  }

  Future<void> _loadFreshNews() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock data - replace with actual API call
      final freshArticles = [
        NewsItem(
          id: '1',
          title: 'Breaking News: Flutter 3.0 Released',
          description:
              'Google has announced the release of Flutter 3.0 with exciting new features...',
          imageUrl: 'https://picsum.photos/400/200?random=flutter',
          publishedAt: '2025-12-02',
          source: 'Tech News',
        ),
        NewsItem(
          id: '2',
          title: 'GetX State Management Best Practices',
          description:
              'Learn how to effectively use GetX for state management in Flutter apps...',
          imageUrl: 'https://picsum.photos/400/200?random=flutter',
          publishedAt: '2025-12-01',
          source: 'Dev Blog',
        ),
        NewsItem(
          id: '3',
          title: 'Mobile App Development Trends 2025',
          description:
              'Explore the latest trends shaping mobile app development this year...',
          imageUrl:
              'https://via.placeholder.com/400x200/2196F3/FFFFFF?text=Mobile+Trends',
          publishedAt: '2025-11-30',
          source: 'Industry Report',
        ),
      ];

      // Cache the fresh data
      await _cacheService.cacheArticles(freshArticles);

      // Cache images for offline viewing
      for (final article in freshArticles) {
        await _cacheService.cacheImage(article.imageUrl, article.id);
      }

      // Update UI if not already showing cached data
      if (newsList.isEmpty) {
        // Combine local news with fresh API news
        final combinedNews = [..._localNewsService.localNews, ...freshArticles];
        newsList.assignAll(combinedNews);
      }

      // Show notifications for important news
      _showNotificationsForNewNews(freshArticles);
    } catch (e) {
      if (newsList.isEmpty) {
        hasError.value = true;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showNotificationsForNewNews(List<NewsItem> newArticles) {
    // Show notifications for the first few important articles
    final importantArticles = newArticles
        .take(2)
        .toList(); // Show max 2 notifications
    for (final article in importantArticles) {
      _notificationService.showBreakingNewsNotification(article);
    }
  }

  Future<void> refreshNews() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock data - replace with actual API call
      final freshArticles = [
        NewsItem(
          id: 'refresh_${DateTime.now().millisecondsSinceEpoch}_1',
          title: 'Breaking: Flutter 3.1 Released with New Features',
          description:
              'The latest Flutter update brings performance improvements and new widgets...',
          imageUrl: 'https://picsum.photos/400/200?random=flutter_update',
          publishedAt: DateTime.now().toString().split(' ')[0],
          source: 'Tech News',
        ),
        NewsItem(
          id: 'refresh_${DateTime.now().millisecondsSinceEpoch}_2',
          title: 'AI Integration in Mobile Apps: Current Trends',
          description:
              'How artificial intelligence is transforming mobile application development...',
          imageUrl: 'https://picsum.photos/400/200?random=flutter_update',
          publishedAt: DateTime.now().toString().split(' ')[0],
          source: 'Dev Blog',
        ),
        NewsItem(
          id: 'refresh_${DateTime.now().millisecondsSinceEpoch}_3',
          title: 'Cross-Platform Development Best Practices 2025',
          description:
              'Essential guidelines for building high-quality cross-plataform applications...',
          imageUrl:
              'https://via.placeholder.com/400x200/607D8B/FFFFFF?text=Best+Practices',
          publishedAt: DateTime.now().toString().split(' ')[0],
          source: 'Industry Report',
        ),
      ];

      // Update the UI with fresh data immediately
      // Combine local news with fresh API news
      final combinedNews = [..._localNewsService.localNews, ...freshArticles];
      newsList.assignAll(combinedNews);

      // Cache the fresh data in background
      _cacheService.cacheArticles(freshArticles);

      // Cache images for offline viewing in background
      for (final article in freshArticles) {
        _cacheService.cacheImage(article.imageUrl, article.id);
      }

      // Show notifications for important news
      _showNotificationsForNewNews(freshArticles);

      // Show success feedback
      Get.snackbar(
        'News Updated',
        'Latest news has been loaded successfully',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Refresh Failed',
        'Unable to load latest news. Please try again.',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showAddNewsDialog({NewsItem? newsToEdit}) {
    final titleController = TextEditingController(
      text: newsToEdit?.title ?? '',
    );
    final descriptionController = TextEditingController(
      text: newsToEdit?.description ?? '',
    );
    final sourceController = TextEditingController(
      text: newsToEdit?.source ?? '',
    );
    File? selectedImage;
    final picker = ImagePicker();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(newsToEdit != null ? 'Edit News' : 'Add New News'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Selection
                  GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Take Photo'),
                                onTap: () async {
                                  Get.back();
                                  try {
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 80,
                                    );
                                    if (image != null) {
                                      setState(() {
                                        selectedImage = File(image.path);
                                      });
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      'Camera Error',
                                      'Unable to access camera. Please check permissions.',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from Gallery'),
                                onTap: () async {
                                  Get.back();
                                  try {
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 80,
                                    );
                                    if (image != null) {
                                      setState(() {
                                        selectedImage = File(image.path);
                                      });
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      'Gallery Error',
                                      'Unable to access gallery. Please check permissions.',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                              ),
                              if (selectedImage != null)
                                ListTile(
                                  leading: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: const Text(
                                    'Remove Image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () {
                                    Get.back();
                                    setState(() => selectedImage = null);
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to add image',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter news title',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter news description',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: sourceController,
                    decoration: const InputDecoration(
                      labelText: 'Source',
                      hintText: 'Enter news source',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                titleController.clear();
                descriptionController.clear();
                sourceController.clear();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    sourceController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please fill in all required fields',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                try {
                  if (newsToEdit != null) {
                    // Update existing news
                    final updatedNews = NewsItem(
                      id: newsToEdit.id,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      imageUrl: selectedImage?.path ?? newsToEdit.imageUrl,
                      source: sourceController.text.trim(),
                      publishedAt: newsToEdit.publishedAt,
                    );

                    await _localNewsService.updateLocalNews(
                      updatedNews,
                      newImageFile: selectedImage,
                    );

                    Get.snackbar(
                      'Success',
                      'News updated successfully!',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    // Add new news
                    final newNews = NewsItem(
                      id: '', // Will be set by the service
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      imageUrl: selectedImage?.path ?? '',
                      source: sourceController.text.trim(),
                      publishedAt: DateTime.now().toString().split(' ')[0],
                    );

                    await _localNewsService.addLocalNews(
                      newNews,
                      imageFile: selectedImage,
                    );

                    Get.snackbar(
                      'Success',
                      'News added successfully!',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }

                  // Refresh the news list
                  await loadNews();

                  Get.back();
                  titleController.clear();
                  descriptionController.clear();
                  sourceController.clear();
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to ${newsToEdit != null ? 'update' : 'add'} news: $e',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text(newsToEdit != null ? 'Update News' : 'Add News'),
            ),
          ],
        ),
      ),
    );
  }
}
