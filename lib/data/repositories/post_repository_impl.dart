import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

/// Repository implementation - coordinates data sources
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PostEntity>> getPosts() async {
    final models = await remoteDataSource.getPosts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PostEntity> getPostById(int id) async {
    final model = await remoteDataSource.getPostById(id);
    return model.toEntity();
  }

  @override
  Future<PostEntity> createPost(PostEntity post) async {
    final model = PostModel.fromEntity(post);
    final created = await remoteDataSource.createPost(model);
    return created.toEntity();
  }

  @override
  Future<PostEntity> updatePost(PostEntity post) async {
    final model = PostModel.fromEntity(post);
    final updated = await remoteDataSource.updatePost(model);
    return updated.toEntity();
  }

  @override
  Future<void> deletePost(int id) async {
    await remoteDataSource.deletePost(id);
  }
}





