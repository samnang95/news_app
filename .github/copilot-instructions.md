# AI Copilot Instructions - TaskApp (Flutter + GetX)

## Architecture Overview

**Framework**: Flutter with GetX (MVC pattern) + GetStorage for local persistence + flutter_screenutil for responsive design.

**Folder Structure**:
- `lib/app/` — Core application configuration (controllers, services, routes, themes, constants)
- `lib/presentation/` — UI pages organized per feature (splash, home, nav, settings)
- `lib/main.dart` — Entry point with global controller initialization

**Key Design Pattern**: GetX MVC with service layer abstraction.

## Global Controllers & Initialization

Controllers are initialized in `main()` as permanent services (not lazy-loaded):

```dart
// main.dart initialization order
Get.put(SharedPrefsService(), permanent: true);  // Data persistence
Get.put(ThemeController(), permanent: true);     // Theme state (reactive)
Get.put(RatioController());                      // Responsive scaling
Get.put(LocaleController());                     // Localization (i18n)
```

- **ThemeController**: Manages `isDarkMode.obs` (Rx<bool>) — toggles between `darkTheme` and `lightTheme`
- **RatioController**: Exposes device info (isTablet, isMobile, isWeb, isDesktop) and scaling methods via static getter `RatioController.to`
- **LocaleController**: Holds `locale.obs` (Rx<Locale>) and provides `changeLocale()` method
- **SharedPrefsService**: Wraps SharedPreferences with async `init()`, `getString()`, `setBool()`, `remove()`

## State Management Pattern

Use **Rx<T>** explicitly for clarity; avoid bare `.obs`:

```dart
// ✅ Preferred
final Rx<int> counter = Rx<int>(0);
final Rx<String> name = Rx<String>('Default');

// ⚠️ Avoid bare .obs unless obvious
var count = 0.obs;  // Type inference breaks readability
```

Observe reactive values in widgets with `Obx()` or `GetBuilder<Controller>()`.

## Page/Feature Structure

Each page (Splash, Home, Nav, Settings) follows this layout:

```
lib/presentation/pages/[feature]/
├── [feature]_page.dart       # Route definition (GetPage + binding)
├── [feature]_view.dart       # UI (GetView<Controller>)
├── [feature]_controller.dart # Business logic (GetxController)
└── [feature]_binding.dart    # Dependency injection (Bindings)
```

**Example Route Definition** (`home_page.dart`):
```dart
class HomePage {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
```

All routes collected in `app_pages.dart` via spread operator (`...PageName.routes`).

## Services & Persistence

Place business logic and external dependencies in `lib/app/services/`:

- **SharedPrefsService**: Generic key-value persistence abstraction
- **ThemeService**: Handles theme preference storage/retrieval (note: uses SharedPreferences internally, not GetStorage)

Example service pattern:
```dart
class ExampleService {
  Future<String> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }
}
```

## Constants & Styling

Organize constants in `lib/app/constants/`:
- `app_color.dart` — Color palette (AppColors class)
- `app_string.dart` — Localization keys and fallback strings
- `app_spacing.dart` — Responsive spacing (uses RatioController for scaling)

**Responsive Design**:
```dart
// AppSpacing automatically scales via RatioController.to
double paddingM = AppSpacing.paddingM;    // Scales across devices
double fontSizeLarge = RatioController.to.scaledFont(18);
```

## Routing & Navigation

Routes defined in `app_routes.dart`:
```dart
class AppRoutes {
  static const splash = '/splash';
  static const nav = '/nav';
  static const home = '/home';
  static const setting = '/setting';
}
```

Navigation patterns:
```dart
Get.toNamed(AppRoutes.home);           // Push new route
Get.offAllNamed(AppRoutes.nav);        // Replace entire stack
Get.back();                             // Pop current route
```

## Code Style & Conventions

1. **Async Methods**: Add `Future<void>` return type annotation (not `void async`)
   ```dart
   Future<void> loadData() async { ... }  // ✅ Correct
   void loadData() async { ... }           // ❌ Avoid
   ```

2. **Rx Types**: Explicit type parameters for clarity
   ```dart
   final Rx<bool> isDark = false.obs;      // ✅ Clear
   var isDark = false.obs;                 // ❌ Less clear
   ```

3. **Private Constants**: Prefix with underscore, use UPPER_SNAKE_CASE
   ```dart
   static const Duration _splashDuration = Duration(seconds: 3);
   static const String _themeKey = 'isDarkMode';
   ```

4. **Widget Construction**: Use `const` for immutable widgets
   ```dart
   const TaskApp({super.key});        // ✅ Const constructor
   Text('Hello');                     // ✅ Implicit const
   SizedBox(height: 8);              // ⚠️ Add const if possible
   ```

5. **Import Organization**: 
   - Absolute imports from `package:taskapp/...`
   - Relative imports only within same module if unavoidable

## Common Workflows

**Add a New Page**:
1. Create `lib/presentation/pages/[feature]/` directory
2. Write `[feature]_view.dart` (StatelessWidget extending GetView)
3. Create `[feature]_controller.dart` (extends GetxController)
4. Create `[feature]_binding.dart` (extends Bindings, override dependencies())
5. Create `[feature]_page.dart` (static routes getter)
6. Add to `lib/app/routes/app_routes.dart` and include in `app_pages.dart`

**Add a New Service**:
1. Create file in `lib/app/services/`
2. Write class with clear method signatures
3. Initialize in `main()` if global, otherwise inject via Binding

**Change Theme**:
```dart
final themeController = Get.find<ThemeController>();
themeController.toggleTheme();        // Toggles dark/light
themeController.setTheme(true);       // Sets explicitly
```

**Change Locale**:
```dart
final localeController = Get.find<LocaleController>();
localeController.changeLocale(const Locale('km'));  // Khmer
```

## Localization (i18n)

Supported locales: English (`en`), Khmer (`km`), Chinese (`zh`).

Translation files in `lib/l10n/app_*.arb` generated by `flutter gen-l10n`.

Access translations via `'key'.tr` (GetX i18n) or `AppLocalizations.of(context)?.key`.

## Build & Run

```bash
flutter clean && flutter pub get     # Setup
flutter run -d [device_id]           # Run on device
flutter build apk --release          # Android release
flutter build ios --release          # iOS release
```

## Testing & Debugging

- Controllers can be tested standalone (GetxController is testable)
- Use Mockito for service mocking
- Print `Get.find<RatioController>().isTablet` to debug device detection
- Debug theme/locale changes via Obx observers in build methods
