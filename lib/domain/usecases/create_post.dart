import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for creating a new post
class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  Future<PostEntity> call(PostEntity post) async {
    try {
      return await repository.createPost(post);
    } catch (e) {
      throw ServerFailure('Failed to create post: $e');
    }
  }
}





