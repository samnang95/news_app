import 'package:get/get.dart';
import 'package:taskapp/app/services/database_service.dart';
import 'package:taskapp/app/services/local_news_service.dart';
import 'package:taskapp/app/services/bookmark_service.dart';

class ConsoleService extends GetxService {
  final DatabaseService _databaseService = DatabaseService.instance;
  final LocalNewsService _localNewsService = Get.find<LocalNewsService>();
  final BookmarkService _bookmarkService = Get.find<BookmarkService>();

  // Console commands
  void executeCommand(String command) {
    final parts = command.trim().split(' ');
    final cmd = parts[0].toLowerCase();

    switch (cmd) {
      case 'db':
      case 'database':
        _handleDatabaseCommand(parts);
        break;
      case 'news':
        _handleNewsCommand(parts);
        break;
      case 'bookmarks':
        _handleBookmarksCommand(parts);
        break;
      case 'clear':
        _handleClearCommand(parts);
        break;
      case 'stats':
        _printStats();
        break;
      case 'help':
        _printHelp();
        break;
      default:
        print('Unknown command: $cmd');
        print('Type "help" for available commands');
    }
  }

  void _handleDatabaseCommand(List<String> parts) {
    if (parts.length < 2) {
      print('Database commands:');
      print('  db stats     - Show database statistics');
      print('  db news      - Show all news in database');
      print('  db local     - Show local news only');
      print('  db bookmarks - Show bookmarked items');
      print('  db clear     - Clear all data');
      return;
    }

    final subCmd = parts[1].toLowerCase();
    switch (subCmd) {
      case 'stats':
        _databaseService.printDatabaseStats();
        break;
      case 'news':
        _databaseService.printAllNews();
        break;
      case 'local':
        _databaseService.printLocalNews();
        break;
      case 'bookmarks':
        _databaseService.printBookmarks();
        break;
      case 'clear':
        _databaseService.clearAllData();
        break;
      default:
        print('Unknown database command: $subCmd');
    }
  }

  void _handleNewsCommand(List<String> parts) {
    if (parts.length < 2) {
      print('News commands:');
      print('  news list    - List all local news');
      print('  news add     - Add sample news (for testing)');
      print('  news clear   - Clear all local news');
      return;
    }

    final subCmd = parts[1].toLowerCase();
    switch (subCmd) {
      case 'list':
        _localNewsService.printLocalNews();
        break;
      case 'clear':
        _localNewsService.clearAllLocalNews();
        break;
      default:
        print('Unknown news command: $subCmd');
    }
  }

  void _handleBookmarksCommand(List<String> parts) {
    if (parts.length < 2) {
      print('Bookmarks commands:');
      print('  bookmarks list   - List all bookmarked items');
      print('  bookmarks clear  - Clear all bookmarks');
      return;
    }

    final subCmd = parts[1].toLowerCase();
    switch (subCmd) {
      case 'list':
        _bookmarkService.printBookmarks();
        break;
      case 'clear':
        _bookmarkService.clearBookmarks();
        break;
      default:
        print('Unknown bookmarks command: $subCmd');
    }
  }

  void _handleClearCommand(List<String> parts) {
    if (parts.length < 2) {
      print('Clear commands:');
      print('  clear all     - Clear all data');
      print('  clear news    - Clear local news only');
      print('  clear bookmarks - Clear bookmarks only');
      return;
    }

    final subCmd = parts[1].toLowerCase();
    switch (subCmd) {
      case 'all':
        _databaseService.clearAllData();
        break;
      case 'news':
        _localNewsService.clearAllLocalNews();
        break;
      case 'bookmarks':
        _bookmarkService.clearBookmarks();
        break;
      default:
        print('Unknown clear command: $subCmd');
    }
  }

  void _printStats() {
    _databaseService.printDatabaseStats();
  }

  void _printHelp() {
    print('''
=== NEWS APP CONSOLE DATABASE ===

Available Commands:

DATABASE COMMANDS:
  db stats           - Show database statistics
  db news            - Show all news in database
  db local           - Show local news only
  db bookmarks       - Show bookmarked items
  db clear           - Clear all database data

NEWS COMMANDS:
  news list          - List all local news
  news clear         - Clear all local news

BOOKMARKS COMMANDS:
  bookmarks list     - List all bookmarked items
  bookmarks clear    - Clear all bookmarks

GENERAL COMMANDS:
  clear all          - Clear all data (news + bookmarks)
  clear news         - Clear local news only
  clear bookmarks    - Clear bookmarks only
  stats              - Show database statistics
  help               - Show this help message

USAGE EXAMPLES:
  db stats           - View database overview
  news list          - See all your local news
  bookmarks list     - Check your saved articles
  clear all          - Reset everything

Type any command to interact with the database.
''');
  }

  // Initialize console service
  @override
  void onInit() {
    super.onInit();
    print('''
╔══════════════════════════════════════╗
║        NEWS APP DATABASE READY       ║
║                                      ║
║  Type "help" for available commands  ║
║                                      ║
║  Example: db stats                   ║
╚══════════════════════════════════════╝
''');
  }
}
