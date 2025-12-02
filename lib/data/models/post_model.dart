import 'dart:io';
import '../../domain/entities/post_entity.dart';

/// Data model - handles JSON serialization/deserialization
class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
    super.imageFile,
    super.imageUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'image': imageUrl, // Only URL goes to API, not File
    };
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      userId: entity.userId,
      id: entity.id,
      title: entity.title,
      body: entity.body,
      imageFile: entity.imageFile,
      imageUrl: entity.imageUrl,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      userId: userId,
      id: id,
      title: title,
      body: body,
      imageFile: imageFile,
      imageUrl: imageUrl,
    );
  }

  @override
  PostModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    File? imageFile,
    String? imageUrl,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

