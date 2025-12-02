import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_details_page.dart';
import '../../providers/post_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
// import '../../../domain/entities/post_entity.dart';
import 'post_form_page.dart';
import '../../widgets/index.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);
    final themeMode = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.posts),
        actions: [
          DropdownButton<Locale>(
            value: currentLocale,
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                ref.read(localeProvider.notifier).setLocale(newLocale);
              }
            },
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
              DropdownMenuItem(value: Locale('km'), child: Text('Khmer')),
              DropdownMenuItem(value: Locale('zh'), child: Text('Chinese')),
            ],
          ),
          CustomIconButton(
            icon: themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
            tooltip: themeMode == ThemeMode.dark ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(postsProvider.notifier).refresh(),
        child: postsAsync.when(
          data: (posts) => posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to create your first post',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(postId: post.id),
                        ),
                      ),
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostFormPage(post: post),
                        ),
                      ),
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Post'),
                            content: const Text(
                              'Are you sure you want to delete this post?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              CustomButton(
                                text: 'Delete',
                                type: ButtonType.danger,
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          try {
                            await ref
                                .read(postsProvider.notifier)
                                .removePost(post.id);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to delete: $e')),
                              );
                            }
                          }
                        }
                      },
                    );
                  },
                ),
          loading: () => const LoadingIndicator(message: 'Loading posts...'),
          error: (error, stack) => ErrorDisplay(
            message: '${AppLocalizations.of(context)!.error}: $error',
            onRetry: () => ref.invalidate(postsProvider),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PostFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
