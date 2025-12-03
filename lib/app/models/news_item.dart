class NewsItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;
  final String source;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
  });

  // Factory constructor for JSON deserialization
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      publishedAt: json['publishedAt'] as String,
      source: json['source'] as String,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt,
      'source': source,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
