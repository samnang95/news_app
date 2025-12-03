import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskapp/app/models/news_item.dart';

class DatabaseService {
  static const String _databaseName = 'news_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String newsTable = 'news';
  static const String bookmarksTable = 'bookmarks';

  // News table columns
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnImageUrl = 'image_url';
  static const String columnPublishedAt = 'published_at';
  static const String columnSource = 'source';
  static const String columnIsLocal = 'is_local';

  // Bookmarks table columns
  static const String bookmarkColumnId = 'id';
  static const String bookmarkColumnNewsId = 'news_id';

  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create news table
    await db.execute('''
      CREATE TABLE $newsTable (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnImageUrl TEXT,
        $columnPublishedAt TEXT NOT NULL,
        $columnSource TEXT NOT NULL,
        $columnIsLocal INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create bookmarks table
    await db.execute('''
      CREATE TABLE $bookmarksTable (
        $bookmarkColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $bookmarkColumnNewsId TEXT NOT NULL UNIQUE,
        FOREIGN KEY ($bookmarkColumnNewsId) REFERENCES $newsTable ($columnId) ON DELETE CASCADE
      )
    ''');

    print('Database created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    print('Upgrading database from $oldVersion to $newVersion');
  }

  // News operations
  Future<int> insertNews(NewsItem news, {bool isLocal = false}) async {
    Database db = await database;
    Map<String, dynamic> row = {
      columnId: news.id,
      columnTitle: news.title,
      columnDescription: news.description,
      columnImageUrl: news.imageUrl,
      columnPublishedAt: news.publishedAt,
      columnSource: news.source,
      columnIsLocal: isLocal ? 1 : 0,
    };
    return await db.insert(
      newsTable,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewsItem>> getAllNews() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      newsTable,
      orderBy: '$columnPublishedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return NewsItem(
        id: maps[i][columnId],
        title: maps[i][columnTitle],
        description: maps[i][columnDescription],
        imageUrl: maps[i][columnImageUrl] ?? '',
        publishedAt: maps[i][columnPublishedAt],
        source: maps[i][columnSource],
      );
    });
  }

  Future<List<NewsItem>> getLocalNews() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      newsTable,
      where: '$columnIsLocal = ?',
      whereArgs: [1],
      orderBy: '$columnPublishedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return NewsItem(
        id: maps[i][columnId],
        title: maps[i][columnTitle],
        description: maps[i][columnDescription],
        imageUrl: maps[i][columnImageUrl] ?? '',
        publishedAt: maps[i][columnPublishedAt],
        source: maps[i][columnSource],
      );
    });
  }

  Future<int> deleteNews(String id) async {
    Database db = await database;
    return await db.delete(newsTable, where: '$columnId = ?', whereArgs: [id]);
  }

  // Bookmark operations
  Future<int> addBookmark(String newsId) async {
    Database db = await database;
    Map<String, dynamic> row = {bookmarkColumnNewsId: newsId};
    return await db.insert(
      bookmarksTable,
      row,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> removeBookmark(String newsId) async {
    Database db = await database;
    return await db.delete(
      bookmarksTable,
      where: '$bookmarkColumnNewsId = ?',
      whereArgs: [newsId],
    );
  }

  Future<List<String>> getBookmarkedNewsIds() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(bookmarksTable);
    return maps.map((map) => map[bookmarkColumnNewsId] as String).toList();
  }

  Future<bool> isBookmarked(String newsId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      bookmarksTable,
      where: '$bookmarkColumnNewsId = ?',
      whereArgs: [newsId],
    );
    return maps.isNotEmpty;
  }

  // Console/Database inspection methods
  Future<void> printAllNews() async {
    List<NewsItem> news = await getAllNews();
    print('\n=== DATABASE: ALL NEWS ===');
    print('Total news items: ${news.length}');
    for (var item in news) {
      print('ID: ${item.id}');
      print('Title: ${item.title}');
      print('Source: ${item.source}');
      print('Published: ${item.publishedAt}');
      print('Image: ${item.imageUrl.isNotEmpty ? item.imageUrl : 'No image'}');
      print('---');
    }
  }

  Future<void> printLocalNews() async {
    List<NewsItem> news = await getLocalNews();
    print('\n=== DATABASE: LOCAL NEWS ===');
    print('Total local news items: ${news.length}');
    for (var item in news) {
      print('ID: ${item.id}');
      print('Title: ${item.title}');
      print(
        'Description: ${item.description.substring(0, min(50, item.description.length))}...',
      );
      print('Source: ${item.source}');
      print('Image: ${item.imageUrl.isNotEmpty ? item.imageUrl : 'No image'}');
      print('---');
    }
  }

  Future<void> printBookmarks() async {
    List<String> bookmarks = await getBookmarkedNewsIds();
    print('\n=== DATABASE: BOOKMARKS ===');
    print('Total bookmarked items: ${bookmarks.length}');
    for (var newsId in bookmarks) {
      print('Bookmarked News ID: $newsId');
    }
  }

  Future<void> printDatabaseStats() async {
    Database db = await database;

    // Count news items
    int totalNews =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $newsTable'),
        ) ??
        0;
    int localNews =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM $newsTable WHERE $columnIsLocal = 1',
          ),
        ) ??
        0;
    int apiNews =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM $newsTable WHERE $columnIsLocal = 0',
          ),
        ) ??
        0;

    // Count bookmarks
    int bookmarks =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $bookmarksTable'),
        ) ??
        0;

    print('\n=== DATABASE STATISTICS ===');
    print('Total News Items: $totalNews');
    print('  - Local News: $localNews');
    print('  - API News: $apiNews');
    print('Bookmarked Items: $bookmarks');
    print('Database Path: ${db.path}');
  }

  Future<void> clearAllData() async {
    Database db = await database;
    await db.delete(newsTable);
    await db.delete(bookmarksTable);
    print('All data cleared from database');
  }

  int min(int a, int b) => a < b ? a : b;
}
