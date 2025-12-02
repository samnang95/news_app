import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskapp/core/constants/post_api_constants.dart';
import '../models/post_model.dart';

/// Remote data source - handles API calls
abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(int id);
  Future<PostModel> createPost(PostModel post);
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({http.Client? client})
    : client = client ?? http.Client();

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      // Fetch posts and photos in parallel
      final postsFuture = client.get(Uri.parse(PostApiConstants.postsUrl));
      final photosFuture = client.get(
        Uri.parse('${PostApiConstants.photosUrl}?_limit=100'),
      );

      final responses = await Future.wait([postsFuture, photosFuture]);
      final postsResponse = responses[0];
      final photosResponse = responses[1];

      // Check posts response
      if (postsResponse.statusCode != 200) {
        throw Exception(
          'Failed to fetch posts: ${postsResponse.statusCode} - ${postsResponse.body}',
        );
      }

      // Parse posts data
      final postsData = jsonDecode(postsResponse.body) as List<dynamic>;
      if (postsData.isEmpty) {
        return [];
      }

      // Try to fetch photos (optional - don't fail if photos fail)
      List<dynamic> photosData = [];
      if (photosResponse.statusCode == 200) {
        try {
          photosData = jsonDecode(photosResponse.body) as List<dynamic>;
        } catch (e) {
          // Photos parsing failed, continue without photos
          print('Warning: Failed to parse photos: $e');
        }
      }

      // Map photo IDs to URLs
      final photoUrlMap = <int, String>{};
      final fallbackUrls = <String>[];
      for (final photo in photosData) {
        try {
          final id = photo['id'];
          final url = photo['url'];
          if (url is String && url.isNotEmpty) {
            fallbackUrls.add(url);
          }
          if (id is int && url is String && url.isNotEmpty) {
            photoUrlMap[id] = url;
          }
        } catch (e) {
          // Skip invalid photo entries
          continue;
        }
      }

      // Merge posts with photos
      return postsData.asMap().entries.map((entry) {
        try {
          final post = PostModel.fromJson(entry.value as Map<String, dynamic>);
          final fallbackUrl = fallbackUrls.isEmpty
              ? null
              : fallbackUrls[entry.key % fallbackUrls.length];
          final remoteUrl = photoUrlMap[post.id] ?? fallbackUrl;
          if (remoteUrl == null || remoteUrl.isEmpty) return post;
          return post.copyWith(imageUrl: post.imageUrl ?? remoteUrl);
        } catch (e) {
          // If post parsing fails, try to create a basic post
          print('Warning: Failed to parse post at index ${entry.key}: $e');
          try {
            final data = entry.value as Map<String, dynamic>;
            return PostModel(
              userId: data['userId'] as int? ?? 1,
              id: data['id'] as int? ?? entry.key + 1,
              title: data['title'] as String? ?? 'Untitled',
              body: data['body'] as String? ?? '',
            );
          } catch (_) {
            rethrow;
          }
        }
      }).toList();
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    if (id <= 0) throw ArgumentError('Post ID must be positive');

    try {
      final response = await client.get(
        Uri.parse('${PostApiConstants.postsUrl}/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PostModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to fetch post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching post by ID: $e');
    }
  }

  @override
  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await client.post(
        Uri.parse(PostApiConstants.postsUrl),
        headers: PostApiConstants.jsonHeaders,
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PostModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to create post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await client.put(
        Uri.parse('${PostApiConstants.postsUrl}/${post.id}'),
        headers: PostApiConstants.jsonHeaders,
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PostModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to update post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  @override
  Future<void> deletePost(int id) async {
    if (id <= 0) throw ArgumentError('Post ID must be positive');

    try {
      final response = await client.delete(
        Uri.parse('${PostApiConstants.postsUrl}/$id'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to delete post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}
