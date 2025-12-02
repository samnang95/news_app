import 'dart:io';

/// Domain entity - pure business object, no JSON serialization
class PostEntity {
  final int userId;
  final int id;
  final String title;
  final String body;
  final File? imageFile; // Local file from gallery
  final String? imageUrl; // Remote URL from API

  const PostEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.imageFile,
    this.imageUrl,
  });

  PostEntity copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    File? imageFile,
    String? imageUrl,
  }) {
    return PostEntity(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}





