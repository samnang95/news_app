# 📚 Clean Architecture Layer Guide

## Which Layer for Theme, l10n, and Widgets?

### 🎨 **Theme** → **PRESENTATION** Layer

**Location:** `lib/presentation/theme/`

**Why?**
- Theme is **UI-related** (colors, styles, visual appearance)
- Only used by presentation layer (pages, widgets)
- Not business logic, not data

**Structure:**
```
lib/presentation/
└── theme/
    └── app_theme.dart
```

**Example:**
```dart
// lib/presentation/theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme { ... }
  static ThemeData get darkTheme { ... }
}
```

---

### 🌐 **l10n** (Localization) → **CORE** Layer (or Root)

**Location:** `lib/core/l10n/` OR `lib/l10n/` (root level)

**Why?**
- **Shared across all layers** (domain, data, presentation)
- **Configuration/utility** - not business logic, not UI
- Flutter standard location is root level
- Can be used by domain (error messages), data (API messages), presentation (UI text)

**Two Options:**

#### Option 1: Root Level (Recommended for Flutter)
```
lib/
└── l10n/
    ├── app_en.arb
    ├── app_km.arb
    └── app_zh.arb
```
**Why:** Flutter's localization system expects it here, and it's generated code.

#### Option 2: Core Layer (Better for Clean Architecture)
```
lib/core/
└── l10n/
    ├── app_en.arb
    ├── app_km.arb
    └── app_zh.arb
```
**Why:** It's shared infrastructure, fits in core layer.

**Recommendation:** Keep at root level (`lib/l10n/`) because:
- Flutter standard
- Generated code location
- Works well with `flutter gen-l10n`

---

### 🧩 **Widgets** → **PRESENTATION** Layer

**Location:** `lib/presentation/widgets/`

**Why?**
- Widgets are **UI components**
- Only used by presentation layer
- Reusable UI elements (buttons, cards, etc.)

**Structure:**
```
lib/presentation/
└── widgets/
    ├── buttons/
    │   └── custom_button.dart
    ├── cards/
    │   └── post_card.dart
    └── inputs/
        └── custom_text_field.dart
```

**Example:**
```dart
// lib/presentation/widgets/buttons/custom_button.dart
class CustomButton extends StatelessWidget {
  // UI component
}
```

---

## 📊 Summary Table

| Item | Layer | Location | Reason |
|------|-------|----------|--------|
| **Theme** | **PRESENTATION** | `lib/presentation/theme/` | UI-related, only used by presentation |
| **l10n** | **CORE** (or Root) | `lib/core/l10n/` or `lib/l10n/` | Shared across all layers, configuration |
| **Widgets** | **PRESENTATION** | `lib/presentation/widgets/` | UI components, only used by presentation |

---

## 🏗️ Complete Structure

```
lib/
├── core/                          # Shared utilities
│   ├── constants/
│   ├── errors/
│   └── l10n/                     # Option 2: l10n here (if you want)
│
├── domain/                       # Business logic
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── data/                         # Data layer
│   ├── models/
│   ├── datasources/
│   └── repositories/
│
├── presentation/                 # UI layer
│   ├── pages/
│   ├── providers/
│   ├── theme/                    ✅ Theme here
│   └── widgets/                  ✅ Widgets here
│
└── l10n/                         # Option 1: l10n here (recommended)
    ├── app_en.arb
    ├── app_km.arb
    └── app_zh.arb
```

---

## 🎯 Quick Decision Guide

### Theme
**Question:** Is it UI-related?
- ✅ Yes → **PRESENTATION** layer

### l10n
**Question:** Is it shared across multiple layers?
- ✅ Yes → **CORE** layer (or root for Flutter standard)

### Widgets
**Question:** Is it a UI component?
- ✅ Yes → **PRESENTATION** layer

---

## ✅ Current Implementation

Based on Clean Architecture best practices:

1. ✅ **Theme** → `lib/presentation/theme/app_theme.dart`
2. ✅ **l10n** → `lib/l10n/` (root level - Flutter standard)
3. ✅ **Widgets** → `lib/presentation/widgets/`

This is the **correct** organization! 🎉





