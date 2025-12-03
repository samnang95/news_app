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

### ✅ 8. Local News Management (Add Custom News)

- **Add Custom News**: Create and store personal news articles locally
- **Direct Image Upload**: Upload images directly from camera or gallery (no URLs needed)
- **Image Selection**: Choose from camera or photo gallery with permission handling
- **Image Preview**: Real-time preview of selected images with success indicators
- **Rendering Stability**: Optimized image display to prevent UI rendering errors
- **Error Handling**: Graceful fallback for image loading failures
- **Floating Action Button**: Easy access to add new news from the home screen
- **Local Storage**: News and images saved locally for offline access
- **News Editor**: Form-based interface for title, description, image, and source
- **Local Indicators**: Visual badges to distinguish local news from API news
- **Persistent Data**: Local news survives app restarts and updates

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
- **LocalNewsService**: Local news storage and management with image upload support

## 📱 User Guide - Step by Step

### Getting Started

1. **Launch the App**

   - Open the TaskApp on your device
   - The app will load the latest news automatically

2. **Navigate the Interface**
   - **Home Screen**: View news feed with articles
   - **Settings**: Access app preferences (bottom navigation)
   - **Navigation**: Use bottom tabs to switch between screens

### Reading News

3. **Browse News Articles**

   - Scroll through the news feed
   - Each card shows: title, description, source, and date
   - **Local News**: Marked with "Local" badge (user-added articles)

4. **View Article Images**

   - Images display at the top of each news card
   - **Text-Only Mode**: Toggle in Settings to hide images and save data
   - Images load automatically for online articles

5. **Listen to Articles (Text-to-Speech)**
   - Tap the **speaker icon** (top-left of news card)
   - Article will be read aloud
   - **Controls**: Play/Pause/Resume available
   - Works offline for cached articles

### Managing Bookmarks

6. **Bookmark Articles**

   - Tap the **bookmark icon** (top-right of news card)
   - Article saved to bookmarks for later reading
   - Icon changes to filled bookmark when saved

7. **Access Bookmarks**
   - Go to Settings → Test Features → Test Bookmark
   - View all saved articles
   - Remove bookmarks by tapping the bookmark icon again

### Adding Custom News

8. **Add New Article**

   - Tap the **floating + button** (bottom-right of home screen)
   - Fill in the form:
     - **Title**: Article headline
     - **Description**: Article content
     - **Source**: Publication name
     - **Image**: Optional - tap to select from camera or gallery

9. **Upload Images**

   - Tap "Tap to add image" in the add news dialog
   - Choose: **Take Photo** (camera) or **Choose from Gallery**
   - Image preview shows with green checkmark when selected
   - Images are compressed and saved locally

10. **Save Custom News**
    - Tap **"Add News"** button
    - Article appears in feed with "Local" badge
    - Available offline and survives app restarts

### Editing News

11. **Edit Local Articles**
    - Find your local news (marked with "Local" badge)
    - Tap the **edit icon** (pencil, bottom-left of card)
    - Modify title, description, source, or image
    - Tap **"Update News"** to save changes

### Deleting News

12. **Delete Local Articles**
    - Find your local news article
    - Tap the **delete icon** (trash, bottom-right of card)
    - Confirm deletion in the popup dialog
    - Article permanently removed from local storage

### App Settings

13. **Customize Appearance**

    - Go to **Settings** screen
    - **Dark Mode**: Toggle for night reading
    - **Text-Only Mode**: Hide images to save data
    - **Language**: Switch between English, Khmer, Chinese

14. **Notification Settings**

    - **Notifications**: Enable/disable push notifications
    - **Test Notification**: Send test alert to verify settings

15. **Text-to-Speech Settings**
    - **Speech Rate**: Adjust reading speed (0.1x to 1.0x)
    - **Volume**: Control audio level (0% to 100%)
    - **Pitch**: Change voice pitch (0.5x to 2.0x)

### Data Management

16. **Refresh News Feed**

    - Pull down on home screen or tap refresh button (🔄)
    - Loads latest articles from server
    - Cached for offline reading

17. **Clear Cache**
    - Settings → Data & Performance → Clear Cache
    - Frees storage space
    - Removes cached images and articles

### Offline Usage

18. **Read Offline**

    - Bookmarked and local articles available without internet
    - Images cached for offline viewing
    - Text-to-speech works offline

19. **Background Features**
    - Notifications work when app closed
    - Cached content survives network issues
    - Local news always available

### Troubleshooting

20. **Common Issues**
    - **Images not loading**: Check internet or toggle text-only mode
    - **Camera/gallery not working**: Grant permissions in device settings
    - **Notifications not appearing**: Enable in Settings and device notifications
    - **App slow**: Clear cache or restart device
    - **Text-to-speech not working**: Check device TTS settings

### Advanced Features

21. **Debug Console** (Developer)

    - Settings → Developer Options → Debug Console
    - Access database commands for troubleshooting
    - View local news storage and system info

22. **Test Features**
    - Settings → Test Features
    - Test notifications and bookmarks
    - Verify app functionality

## 🔧 Configuration

### Environment Setup

- Configure API endpoints in `lib/app/constants/`
- Set up notification channels in platform-specific code
- Configure theme colors and spacing in constants
- **Image Permissions**: Camera and gallery permissions are automatically configured for Android and iOS

### Build Configuration

- Debug builds: `flutter build apk --debug`
- Release builds: `flutter build apk --release`
- Platform-specific builds available for Android and iOS

### Image Upload Configuration

The app includes comprehensive image upload functionality:

- **Android Permissions**: Camera, storage read/write, and media permissions
- **iOS Permissions**: Camera and photo library usage descriptions
- **Image Quality**: Automatic 80% compression for optimal storage
- **File Storage**: Images saved to app's documents directory
- **Error Handling**: Graceful fallbacks for permission denials and file errors

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📦 Dependencies

Key packages used:

- `get`: State management and navigation
- `shared_preferences`: Local data persistence (bookmarks, settings, local news)
- `flutter_local_notifications`: Push notifications
- `flutter_tts`: Text-to-speech functionality
- `cached_network_image`: Image caching for API news
- `pull_to_refresh`: Pull-to-refresh functionality
- `image_picker`: Direct camera/gallery image selection with permission handling
- `path_provider`: Local file system access for image storage and management

## 🐛 Troubleshooting

### Image Upload Issues

**Problem**: Gallery/camera not accessible
**Solution**: Grant camera and storage permissions in device settings

**Problem**: Rendering errors after image selection
**Solution**: The app includes automatic error handling and fallbacks for image display issues

**Problem**: Images not saving
**Solution**: Check available storage space and app permissions

### Performance Issues

**Problem**: Slow image loading
**Solution**: Images are automatically compressed and cached for optimal performance

**Problem**: High battery usage
**Solution**: Background services are optimized for minimal battery impact

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

## 📋 Recent Updates

### v1.0.1 - Image Upload Stability Fixes

- **Fixed**: Rendering assertion errors (`!semantics.parentDataDirty`) after image selection
- **Improved**: Image preview stability in news creation dialog
- **Enhanced**: Error handling for image loading and permission issues
- **Optimized**: Image display performance with proper fallbacks
- **Updated**: Permission handling for Android and iOS platforms
