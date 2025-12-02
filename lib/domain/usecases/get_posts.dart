import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';
import '../../core/errors/failures.dart';

/// Use case for fetching all posts
class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Future<List<PostEntity>> call() async {
    try {
      return await repository.getPosts();
    } catch (e) {
      throw ServerFailure('Failed to fetch posts: $e');
    }
  }
}





