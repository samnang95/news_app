import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for updating a post
class UpdatePost {
  final PostRepository repository;

  UpdatePost(this.repository);

  Future<PostEntity> call(PostEntity post) async {
    try {
      return await repository.updatePost(post);
    } catch (e) {
      throw ServerFailure('Failed to update post: $e');
    }
  }
}





