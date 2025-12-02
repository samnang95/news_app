import '../entities/post_entity.dart';

/// Repository interface - defines contract for data operations
abstract class PostRepository {
  /// Fetches all posts
  Future<List<PostEntity>> getPosts();

  /// Fetches a single post by ID
  Future<PostEntity> getPostById(int id);

  /// Creates a new post
  Future<PostEntity> createPost(PostEntity post);

  /// Updates an existing post
  Future<PostEntity> updatePost(PostEntity post);

  /// Deletes a post by ID
  Future<void> deletePost(int id);
}

