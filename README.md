# TaskApp - News Reader

A comprehensive Flutter news application built with GetX state management, providing an enhanced reading experience with offline capabilities, accessibility features, and modern UI design.

## 🎯 Completed Features

### ✅ 1. Offline Caching for Articles + Images

- **Smart Caching**: Articles and images are cached locally for offline reading
- **Image Optimization**: Efficient image caching with fallback handling
- **Cache Management**: Automatic cache cleanup and storage optimization
- **Offline-First**: Seamless reading experience without internet connection

### ✅ 2. Pull to Refresh for Manual Updates

- **Manual Refresh**: Swipe down to manually refresh news feed
- **Real-time Updates**: Fetch latest articles on demand
- **Loading States**: Visual feedback during refresh operations
- **Error Handling**: Graceful handling of network issues during refresh

### ✅ 3. Text-Only Lightweight Mode (Save Data)

- **Data Saving**: Toggle between full content and text-only mode
- **Bandwidth Optimization**: Reduce data usage by hiding images
- **Settings Integration**: Persistent preference storage
- **Responsive Design**: Maintains readability in text-only mode

### ✅ 4. Bookmark & Highlight Feature

- **Article Bookmarking**: Save favorite articles for later reading
- **Persistent Storage**: Bookmarks survive app restarts
- **Bookmark Management**: Easy removal and organization
- **Quick Access**: Dedicated bookmarks screen for saved articles

### ✅ 5. Night Mode for Long Reading Sessions

- **Dark Theme**: Eye-friendly dark mode for extended reading
- **Theme Persistence**: Remembers user's theme preference
- **Smooth Transitions**: Seamless switching between light and dark modes
- **Accessibility**: Improved readability in low-light conditions

### ✅ 6. Push Notifications for Important News

- **Breaking News Alerts**: Instant notifications for important updates
- **Customizable Settings**: Control notification preferences
- **Background Processing**: Notifications work when app is closed
- **Rich Content**: Notification previews with article snippets

### ✅ 7. Text to Speech (News Reader Voice Mode)

- **Voice Reading**: Listen to articles being read aloud
- **Playback Controls**: Play, pause, and resume functionality
- **Voice Settings**: Adjustable speech rate, volume, and pitch
- **Multi-language Support**: Support for different languages
- **Accessibility**: Hands-free reading experience

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android/iOS device or emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/samnang95/news_app.git
   cd taskapp
   ```

2. **Install dependencies**

   ```bash
   flutter clean
   flutter pub get
   ```

3. **Run the application**

   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   flutter build apk --release  # For Android
   flutter build ios --release  # For iOS
   ```

## 🏗️ Architecture

### Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Local Storage**: SharedPreferences + GetStorage
- **Networking**: HTTP client with caching
- **Notifications**: Flutter Local Notifications
- **Text-to-Speech**: Flutter TTS

### Project Structure

```
lib/
├── app/
│   ├── constants/          # App-wide constants and themes
│   ├── controllers/        # GetX controllers
│   ├── routes/            # Route definitions
│   ├── services/          # Business logic services
│   └── utils/             # Utility functions
├── presentation/
│   └── pages/             # UI screens organized by feature
└── main.dart              # Application entry point
```

### Key Services

- **CacheService**: Handles offline caching
- **BookmarkService**: Manages bookmarked articles
- **TtsService**: Text-to-speech functionality
- **NotificationService**: Push notification management
- **ThemeService**: Theme and appearance settings

## 📱 Features Overview

### User Experience

- **Responsive Design**: Optimized for mobile and tablet devices
- **Intuitive Navigation**: Bottom navigation with smooth transitions
- **Loading States**: Skeleton screens and progress indicators
- **Error Handling**: User-friendly error messages and retry options

### Performance

- **Lazy Loading**: Efficient list rendering with pagination
- **Image Optimization**: Cached and compressed images
- **Memory Management**: Proper disposal of resources
- **Battery Optimization**: Efficient background processing

## 🔧 Configuration

### Environment Setup

- Configure API endpoints in `lib/app/constants/`
- Set up notification channels in platform-specific code
- Configure theme colors and spacing in constants

### Build Configuration

- Debug builds: `flutter build apk --debug`
- Release builds: `flutter build apk --release`
- Platform-specific builds available for Android and iOS

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📦 Dependencies

Key packages used:

- `get`: State management and navigation
- `shared_preferences`: Local data persistence
- `flutter_local_notifications`: Push notifications
- `flutter_tts`: Text-to-speech functionality
- `cached_network_image`: Image caching
- `pull_to_refresh`: Pull-to-refresh functionality

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

**Samnang** - [GitHub](https://github.com/samnang95)

---

_Built with ❤️ using Flutter and GetX_
