import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/delete_post.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/update_post.dart';
import '../../data/datasources/post_remote_data_source.dart';
import '../../data/repositories/post_repository_impl.dart';

/// Provider for PostRepository
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remoteDataSource = PostRemoteDataSourceImpl();
  return PostRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetPosts use case
final getPostsProvider = Provider<GetPosts>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return GetPosts(repository);
});

/// Provider for CreatePost use case
final createPostProvider = Provider<CreatePost>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return CreatePost(repository);
});

/// Provider for UpdatePost use case
final updatePostProvider = Provider<UpdatePost>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return UpdatePost(repository);
});

/// Provider for DeletePost use case
final deletePostProvider = Provider<DeletePost>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return DeletePost(repository);
});

/// State notifier for posts list
class PostsNotifier extends AsyncNotifier<List<PostEntity>> {
  @override
  Future<List<PostEntity>> build() async {
    final getPosts = ref.read(getPostsProvider);
    return await getPosts();
  }

  Future<void> addPost(PostEntity post) async {
    final previousState = state.value ?? [];
    final optimisticPost = post.copyWith(
      id: DateTime.now().millisecondsSinceEpoch,
    );
    state = AsyncValue.data([...previousState, optimisticPost]);

    try {
      final createPost = ref.read(createPostProvider);
      final createdPost = await createPost(post);
      state = AsyncValue.data([...previousState, createdPost]);
    } catch (e) {
      state = AsyncValue.data(previousState);
      rethrow;
    }
  }

  Future<void> updatePost(PostEntity updatedPost) async {
    final previousState = state.value ?? [];
    final index = previousState.indexWhere((p) => p.id == updatedPost.id);
    if (index == -1) return;

    final originalPost = previousState[index];
    state = AsyncValue.data([
      ...previousState.sublist(0, index),
      updatedPost,
      ...previousState.sublist(index + 1),
    ]);

    try {
      final updatePost = ref.read(updatePostProvider);
      await updatePost(updatedPost);
    } catch (e) {
      state = AsyncValue.data([
        ...previousState.sublist(0, index),
        originalPost,
        ...previousState.sublist(index + 1),
      ]);
      rethrow;
    }
  }

  Future<void> removePost(int id) async {
    final previousState = state.value ?? [];
    final index = previousState.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final removedPost = previousState[index];
    state = AsyncValue.data([
      ...previousState.sublist(0, index),
      ...previousState.sublist(index + 1),
    ]);

    try {
      final deletePost = ref.read(deletePostProvider);
      await deletePost(id);
    } catch (e) {
      state = AsyncValue.data([...previousState, removedPost]);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final getPosts = ref.read(getPostsProvider);
    state = await AsyncValue.guard(() => getPosts());
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<PostEntity>>(() {
  return PostsNotifier();
});





