# 📍 Where to Put Files - Quick Reference

## 🎯 Simple Answer

| File/Folder | Layer | Location |
|-------------|-------|----------|
| **Theme** | **PRESENTATION** | `lib/presentation/theme/` |
| **l10n** | **CORE** (or Root) | `lib/l10n/` (recommended) or `lib/core/l10n/` |
| **Widgets** | **PRESENTATION** | `lib/presentation/widgets/` |

---

## 📋 Detailed Explanation

### 1. 🎨 **Theme** → **PRESENTATION Layer**

```
lib/presentation/theme/app_theme.dart
```

**Why PRESENTATION?**
- Theme = UI styling (colors, fonts, etc.)
- Only used by UI/presentation layer
- Not business logic, not data

**Current Location:** ✅ `lib/presentation/theme/app_theme.dart`

---

### 2. 🌐 **l10n** → **CORE Layer** (or Root)

**Option 1 (Recommended):**
```
lib/l10n/
├── app_en.arb
├── app_km.arb
└── app_zh.arb
```

**Option 2 (Clean Architecture):**
```
lib/core/l10n/
├── app_en.arb
├── app_km.arb
└── app_zh.arb
```

**Why CORE (or Root)?**
- l10n = Shared across ALL layers
- Used by:
  - Domain (error messages)
  - Data (API error messages)
  - Presentation (UI text)
- Configuration/utility, not business logic

**Current Location:** ✅ `lib/l10n/` (root level - Flutter standard)

**Recommendation:** Keep at root level because:
- Flutter's `flutter gen-l10n` expects it there
- It's generated code
- Works well with Flutter's localization system

---

### 3. 🧩 **Widgets** → **PRESENTATION Layer**

```
lib/presentation/widgets/
├── buttons/
│   └── custom_button.dart
├── cards/
│   └── post_card.dart
└── inputs/
    └── custom_text_field.dart
```

**Why PRESENTATION?**
- Widgets = UI components
- Only used by presentation layer
- Reusable UI elements

**Current Location:** ✅ `lib/presentation/widgets/`

---

## 🏗️ Visual Structure

```
lib/
│
├── core/                    ← Shared utilities
│   ├── constants/
│   ├── errors/
│   └── l10n/              ← Option 2: l10n here (if you want)
│
├── domain/                 ← Business logic (no UI, no data)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── data/                   ← Data layer (API, database)
│   ├── models/
│   ├── datasources/
│   └── repositories/
│
├── presentation/           ← UI layer
│   ├── pages/
│   ├── providers/
│   ├── theme/             ✅ Theme here
│   └── widgets/           ✅ Widgets here
│
└── l10n/                   ✅ Option 1: l10n here (recommended)
    ├── app_en.arb
    ├── app_km.arb
    └── app_zh.arb
```

---

## 🎯 Decision Tree

### For Theme:
```
Is it UI-related? 
  → YES → PRESENTATION layer ✅
```

### For l10n:
```
Is it shared across multiple layers?
  → YES → CORE layer (or root) ✅
```

### For Widgets:
```
Is it a UI component?
  → YES → PRESENTATION layer ✅
```

---

## ✅ Your Current Setup (Correct!)

| Item | Current Location | Layer | Status |
|------|------------------|-------|--------|
| Theme | `lib/presentation/theme/app_theme.dart` | PRESENTATION | ✅ Correct |
| l10n | `lib/l10n/` | Root (Flutter standard) | ✅ Correct |
| Widgets | `lib/presentation/widgets/` | PRESENTATION | ✅ Correct |

**Everything is in the right place!** 🎉

---

## 📝 Quick Rules

1. **UI-related** → PRESENTATION layer
2. **Shared/Configuration** → CORE layer (or root)
3. **Business logic** → DOMAIN layer
4. **Data/API** → DATA layer

---

## 💡 Examples

### ✅ Correct:
- `lib/presentation/theme/` - Theme (UI)
- `lib/presentation/widgets/` - Widgets (UI)
- `lib/l10n/` - Localization (shared)
- `lib/core/constants/` - Constants (shared)

### ❌ Wrong:
- `lib/domain/theme/` - Theme is not business logic
- `lib/data/widgets/` - Widgets are not data
- `lib/presentation/l10n/` - l10n is shared, not just UI

---

## 🎓 Summary

**Theme** = UI → **PRESENTATION** ✅
**l10n** = Shared → **CORE** (or root) ✅
**Widgets** = UI → **PRESENTATION** ✅

Your current organization is perfect! 🚀





