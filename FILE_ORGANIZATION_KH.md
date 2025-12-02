# 📁 ការរៀបចំឯកសារ - File Organization Guide

## កន្លែងដាក់ឯកសារ (Where to Place Files)

### 1. 🎨 **app_theme.dart** (Theme Configuration)

**ទីតាំងចាស់ (Old Location):**
```
lib/theme/app_them.dart  ❌ (មាន typo: "app_them")
```

**ទីតាំងថ្មី (New Location):**
```
lib/presentation/theme/app_theme.dart  ✅
```

**ហេតុអ្វី?** 
- Theme ជា UI/Presentation related
- ដាក់នៅក្នុង Presentation Layer
- កែ typo: "app_them" → "app_theme"

**ការប្រើប្រាស់:**
```dart
import 'package:taskapp/presentation/theme/app_theme.dart';

// In your MaterialApp:
theme: AppTheme.lightTheme,
darkTheme: AppTheme.darkTheme,
```

---

### 2. 🧩 **Widgets Folder** (Reusable UI Components)

**ទីតាំងចាស់ (Old Location):**
```
lib/widgets/  ❌ (នៅ root level)
```

**ទីតាំងថ្មី (New Location):**
```
lib/presentation/widgets/  ✅
```

**ហេតុអ្វី?**
- Widgets ជា UI components
- ដាក់នៅក្នុង Presentation Layer
- ជួយរៀបចំ code ឱ្យសមរម្យ

**ឧទាហរណ៍:**
```
lib/presentation/widgets/
├── buttons/
│   └── custom_button.dart
├── indicators/
│   └── loading_indicator.dart
└── inputs/
    └── custom_text_field.dart
```

**ការប្រើប្រាស់:**
```dart
import 'package:taskapp/presentation/widgets/buttons/custom_button.dart';
```

---

### 3. 🌐 **l10n Folder** (Localization/Internationalization)

**ទីតាំង (Location):**
```
lib/l10n/  ✅ (រក្សាទុកនៅ root level)
```

**ហេតុអ្វីមិនផ្លាស់ទី?**
- `l10n` ជា Flutter standard location
- Flutter localization system រំពឹងថាវានៅ root level
- ជា generated code (Flutter gen-l10n)
- Shared across all layers

**រចនាសម្ព័ន្ធ:**
```
lib/l10n/
├── app_en.arb          # English translations
├── app_km.arb          # Khmer translations
├── app_zh.arb          # Chinese translations
├── app_localizations.dart
└── app_localizations_*.dart  # Generated files
```

**ការប្រើប្រាស់:**
```dart
import 'package:taskapp/l10n/app_localizations.dart';

// In your widget:
Text(AppLocalizations.of(context)!.title)
```

---

## 📊 ផែនទីទីតាំង (Location Map)

| ឯកសារ/ថត | ទីតាំងចាស់ | ទីតាំងថ្មី | ស្ថានភាព |
|------------|-------------|-------------|----------|
| **Theme** | `lib/theme/app_them.dart` | `lib/presentation/theme/app_theme.dart` | ✅ ផ្លាស់ប្តូរហើយ |
| **Widgets** | `lib/widgets/` | `lib/presentation/widgets/` | ✅ ផ្លាស់ប្តូរហើយ |
| **l10n** | `lib/l10n/` | `lib/l10n/` (រក្សាទុក) | ✅ នៅតែនៅទីនេះ |

---

## 🏗️ រចនាសម្ព័ន្ធ Clean Architecture

```
lib/
├── core/                    # Shared utilities
│   ├── constants/
│   └── errors/
│
├── domain/                  # Business logic
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── data/                    # Data layer
│   ├── models/
│   ├── datasources/
│   └── repositories/
│
├── presentation/            # UI layer
│   ├── pages/
│   ├── providers/
│   ├── theme/              ← Theme នៅទីនេះ ✅
│   └── widgets/            ← Widgets នៅទីនេះ ✅
│
└── l10n/                   ← l10n នៅ root level ✅
    ├── app_en.arb
    ├── app_km.arb
    └── app_zh.arb
```

---

## 🔄 ការផ្លាស់ប្តូរ (Changes Made)

### ✅ បានធ្វើ:
1. ✅ ផ្លាស់ `lib/theme/app_them.dart` → `lib/presentation/theme/app_theme.dart`
2. ✅ កែ typo: `AppThem` → `AppTheme`
3. ✅ បង្កើត `lib/presentation/widgets/` folder
4. ✅ Update imports ក្នុង `main.dart`
5. ✅ លុប file ចាស់ `lib/theme/app_them.dart`

### 📝 អ្វីដែលត្រូវធ្វើ:
- ប្រើ `AppTheme` ជំនួស `AppThem` នៅកន្លែងណាដែលប្រើ
- ដាក់ widgets ថ្មីនៅក្នុង `lib/presentation/widgets/`
- `l10n` នៅតែប្រើដូចដើម

---

## 💡 គន្លឹះ (Tips)

1. **Theme**: ប្រើ `AppTheme` (មិនមែន `AppThem`)
2. **Widgets**: ដាក់ widgets reusable ទាំងអស់នៅក្នុង `presentation/widgets/`
3. **l10n**: មិនត្រូវផ្លាស់ទី - Flutter ត្រូវការវានៅ root level

---

## ❓ FAQ

**Q: ហេតុអ្វី l10n មិនផ្លាស់ទី?**
A: ពីព្រោះ Flutter localization system រំពឹងថាវានៅ root level, ហើយជា generated code.

**Q: តើអាចដាក់ widgets នៅកន្លែងផ្សេងទៀតបានទេ?**
A: បាន, ប៉ុន្តែដាក់នៅ `presentation/widgets/` ជួយឱ្យ code organized ជាង។

**Q: Theme អាចដាក់នៅ core/ បានទេ?**
A: បាន, ប៉ុន្តែដាក់នៅ `presentation/theme/` ត្រឹមត្រូវជាង ពីព្រោះវាជា UI-related។





