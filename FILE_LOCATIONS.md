# 📍 Exact File Locations

## All Post-Related Files in Your Project

### ✅ OLD FILES (Your original code - still exists):
```
lib/
├── models/
│   └── post.dart                              ← OLD MODEL
│
├── services/
│   └── api_service.dart                       ← OLD API SERVICE
│
├── providers/
│   └── post_provider.dart                     ← OLD PROVIDER
│
└── pages/
    └── post/
        ├── post_form_page.dart                ← OLD FORM PAGE
        ├── posts_page.dart                    ← OLD LIST PAGE
        └── post_details_page.dart             ← OLD DETAIL PAGE
```

### 🆕 NEW FILES (Clean Architecture - currently active):
```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart                 ← NEW CONSTANTS
│   └── errors/
│       └── failures.dart                       ← NEW ERRORS
│
├── domain/
│   ├── entities/
│   │   └── post_entity.dart                   ← NEW ENTITY
│   ├── repositories/
│   │   └── post_repository.dart              ← NEW REPOSITORY INTERFACE
│   └── usecases/
│       ├── get_posts.dart                     ← NEW USE CASE
│       ├── create_post.dart                   ← NEW USE CASE
│       ├── update_post.dart                   ← NEW USE CASE
│       └── delete_post.dart                   ← NEW USE CASE
│
├── data/
│   ├── models/
│   │   └── post_model.dart                    ← NEW DATA MODEL
│   ├── datasources/
│   │   └── post_remote_data_source.dart      ← NEW DATA SOURCE
│   └── repositories/
│       └── post_repository_impl.dart          ← NEW REPOSITORY IMPL
│
└── presentation/
    ├── pages/
    │   └── post/
    │       ├── post_form_page.dart            ← NEW FORM PAGE
    │       ├── posts_page.dart                ← NEW LIST PAGE
    │       └── post_details_page.dart          ← NEW DETAIL PAGE
    └── providers/
        └── post_provider.dart                  ← NEW PROVIDER
```

## 🔍 Quick Search Guide

### To find your OLD code:
- **Model**: `lib/models/post.dart`
- **API Service**: `lib/services/api_service.dart`
- **Provider**: `lib/providers/post_provider.dart`
- **Pages**: `lib/pages/post/` folder

### To find your NEW code:
- **Entity**: `lib/domain/entities/post_entity.dart`
- **Data Source**: `lib/data/datasources/post_remote_data_source.dart`
- **Provider**: `lib/presentation/providers/post_provider.dart`
- **Pages**: `lib/presentation/pages/post/` folder

## 📊 Side-by-Side Comparison

| What You Need | OLD Location | NEW Location |
|---------------|--------------|--------------|
| **Data Model** | `lib/models/post.dart` | `lib/domain/entities/post_entity.dart` |
| **JSON Model** | `lib/models/post.dart` | `lib/data/models/post_model.dart` |
| **API Calls** | `lib/services/api_service.dart` | `lib/data/datasources/post_remote_data_source.dart` |
| **State Management** | `lib/providers/post_provider.dart` | `lib/presentation/providers/post_provider.dart` |
| **Form Page** | `lib/pages/post/post_form_page.dart` | `lib/presentation/pages/post/post_form_page.dart` |
| **List Page** | `lib/pages/post/posts_page.dart` | `lib/presentation/pages/post/posts_page.dart` |
| **Detail Page** | `lib/pages/post/post_details_page.dart` | `lib/presentation/pages/post/post_details_page.dart` |
| **Constants** | `lib/constants/api_contants.dart` | `lib/core/constants/api_constants.dart` |

## 🎯 Current Status

**Your app is using:** NEW files (clean architecture)
**Your old files:** Still exist, just not being used

## 💡 How to View Your Old Code

1. **In VS Code/Cursor:**
   - Press `Cmd+P` (Mac) or `Ctrl+P` (Windows)
   - Type: `lib/pages/post/post_form_page.dart`
   - Press Enter

2. **In File Explorer:**
   - Navigate to: `lib/pages/post/`
   - All your old files are there!

3. **Compare Old vs New:**
   - Open: `lib/pages/post/post_form_page.dart` (old)
   - Open: `lib/presentation/pages/post/post_form_page.dart` (new)
   - Compare them side-by-side

## ✅ Summary

- ✅ Your old files are **NOT deleted**
- ✅ They're in the same locations you remember
- ✅ New files are in organized folders
- ✅ App currently uses new structure
- ✅ You can access old files anytime





