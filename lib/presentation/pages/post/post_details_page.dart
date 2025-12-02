// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_form_page.dart';
import '../../providers/post_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/entities/post_entity.dart';
import '../../widgets/index.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);
    final post = postsAsync.maybeWhen(
      data: (posts) => posts.where((p) => p.id == widget.postId).firstOrNull,
      orElse: () => null,
    );

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.postDetail)),
        body: ErrorDisplay(message: 'Post not found', icon: Icons.search_off),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.postDetail),
        actions: [
          CustomIconButton(
            icon: Icons.edit,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostFormPage(post: post)),
            ),
            tooltip: 'Edit',
          ),
          CustomIconButton(
            icon: Icons.delete,
            onPressed: _isDeleting
                ? null
                : () => _showDeleteDialog(context, post),
            tooltip: 'Delete',
            color: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeroImage(post: post),
            const SizedBox(height: 24),
            InfoCard(
              title: 'Post ID',
              value: post.id.toString(),
              icon: Icons.tag,
            ),
            const SizedBox(height: 12),
            InfoCard(
              title: 'User ID',
              value: post.userId.toString(),
              icon: Icons.person,
            ),
            const SizedBox(height: 24),
            Text(
              post.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Edit',
                    icon: Icons.edit,
                    type: ButtonType.outline,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostFormPage(post: post),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Delete',
                    icon: Icons.delete,
                    type: ButtonType.danger,
                    isLoading: _isDeleting,
                    onPressed: _isDeleting
                        ? null
                        : () => _showDeleteDialog(context, post),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PostEntity post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Delete',
            type: ButtonType.danger,
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isDeleting = true;
              });
              try {
                await ref
                    .read(postsProvider.notifier)
                    .removePost(widget.postId);
                if (!mounted) return;
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (!mounted) return;
                setState(() {
                  _isDeleting = false;
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PostHeroImage extends StatelessWidget {
  final PostEntity post;

  const _PostHeroImage({required this.post});

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    if (post.imageFile != null) {
      provider = FileImage(post.imageFile!);
    } else if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      provider = NetworkImage(post.imageUrl!);
    }

    if (provider == null) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text('No image', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image(
        image: provider,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
