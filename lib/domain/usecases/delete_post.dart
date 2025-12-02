import '../repositories/post_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for deleting a post
class DeletePost {
  final PostRepository repository;

  DeletePost(this.repository);

  Future<void> call(int id) async {
    try {
      await repository.deletePost(id);
    } catch (e) {
      throw ServerFailure('Failed to delete post: $e');
    }
  }
}





