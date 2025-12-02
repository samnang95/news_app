class PostApiConstants {
  static const _root = 'https://jsonplaceholder.typicode.com';
  static const String postsUrl = '$_root/posts';
  static const String photosUrl = '$_root/photos';

  static const String contentTypeJson = 'application/json';
  static const Map<String, String> jsonHeaders = {
    'Content-Type': contentTypeJson,
  };
}
