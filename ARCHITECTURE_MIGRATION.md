# Clean Architecture Migration Guide

## 📁 File Location Mapping

### OLD FILES (Still exist, but NOT used by new architecture)
```
lib/
├── models/
│   └── post.dart                    ← OLD: Mixed model/entity
├── services/
│   └── api_service.dart             ← OLD: Direct API calls
├── providers/
│   ├── post_provider.dart           ← OLD: Direct service usage
│   ├── theme_provider.dart          ← OLD: Still works, but moved
│   └── locale_provider.dart         ← OLD: Still works, but moved
├── pages/
│   └── post/
│       ├── post_form_page.dart      ← OLD: Uses Post model
│       ├── posts_page.dart          ← OLD: Uses Post model
│       └── post_details_page.dart   ← OLD: Uses Post model
└── constants/
    └── api_contants.dart            ← OLD: Typo in name, moved
```

### NEW FILES (Clean Architecture - Currently Active)
```
lib/
├── core/                           ← NEW: Shared utilities
│   ├── constants/
│   │   └── api_constants.dart      ← NEW: Fixed typo, better organized
│   └── errors/
│       └── failures.dart           ← NEW: Error handling
│
├── domain/                         ← NEW: Business logic (no dependencies)
│   ├── entities/
│   │   └── post_entity.dart        ← NEW: Pure business object
│   ├── repositories/
│   │   └── post_repository.dart    ← NEW: Interface/contract
│   └── usecases/
│       ├── get_posts.dart          ← NEW: Business use case
│       ├── create_post.dart       ← NEW: Business use case
│       ├── update_post.dart       ← NEW: Business use case
│       └── delete_post.dart       ← NEW: Business use case
│
├── data/                           ← NEW: Data layer
│   ├── models/
│   │   └── post_model.dart         ← NEW: JSON serialization
│   ├── datasources/
│   │   └── post_remote_data_source.dart  ← NEW: API calls
│   └── repositories/
│       └── post_repository_impl.dart     ← NEW: Implements domain interface
│
└── presentation/                   ← NEW: UI layer
    ├── pages/
    │   └── post/
    │       ├── post_form_page.dart      ← NEW: Uses PostEntity
    │       ├── posts_page.dart         ← NEW: Uses PostEntity
    │       └── post_details_page.dart   ← NEW: Uses PostEntity
    └── providers/
        ├── post_provider.dart           ← NEW: Uses use cases
        ├── theme_provider.dart          ← NEW: Moved here
        └── locale_provider.dart         ← NEW: Moved here
```

## 🔄 Step-by-Step Migration Explanation

### Step 1: Understanding the Old Structure
**OLD WAY (What you had before):**
```
lib/models/post.dart → Direct JSON model
lib/services/api_service.dart → Direct HTTP calls
lib/providers/post_provider.dart → Uses ApiService directly
lib/pages/post/*.dart → Uses Post model directly
```

**Problem:** Everything was mixed together. Hard to test, hard to maintain.

### Step 2: New Clean Architecture Layers

#### **Layer 1: CORE** (Shared utilities)
- `lib/core/constants/api_constants.dart`
  - **What it is:** API URLs and headers
  - **Old location:** `lib/constants/api_contants.dart` (had typo)
  - **Why moved:** Better organization, fixed typo

#### **Layer 2: DOMAIN** (Business logic - no external dependencies)
- `lib/domain/entities/post_entity.dart`
  - **What it is:** Pure business object (no JSON, no File I/O)
  - **Old equivalent:** `lib/models/post.dart` (but that had JSON mixed in)
  - **Key difference:** Entity is pure Dart class, no serialization

- `lib/domain/repositories/post_repository.dart`
  - **What it is:** Interface/contract defining what data operations are needed
  - **Old equivalent:** None (was implicit in ApiService)
  - **Why needed:** Allows swapping implementations (API, local DB, etc.)

- `lib/domain/usecases/*.dart`
  - **What they are:** Business logic operations
  - **Old equivalent:** Methods in `post_provider.dart`
  - **Why separated:** Each use case is a single responsibility

#### **Layer 3: DATA** (Data sources and models)
- `lib/data/models/post_model.dart`
  - **What it is:** Extends PostEntity, adds JSON serialization
  - **Old equivalent:** `lib/models/post.dart`
  - **Key difference:** Separates data model from business entity

- `lib/data/datasources/post_remote_data_source.dart`
  - **What it is:** Handles HTTP API calls
  - **Old equivalent:** `lib/services/api_service.dart`
  - **Key difference:** Only handles data fetching, no business logic

- `lib/data/repositories/post_repository_impl.dart`
  - **What it is:** Implements the domain repository interface
  - **Old equivalent:** None (was mixed in provider)
  - **Why needed:** Bridges domain and data layers

#### **Layer 4: PRESENTATION** (UI)
- `lib/presentation/pages/post/*.dart`
  - **What they are:** UI screens
  - **Old equivalent:** `lib/pages/post/*.dart`
  - **Key difference:** Uses PostEntity (domain) instead of Post (data model)

- `lib/presentation/providers/post_provider.dart`
  - **What it is:** State management using use cases
  - **Old equivalent:** `lib/providers/post_provider.dart`
  - **Key difference:** Uses use cases instead of direct service calls

## 📊 Data Flow Comparison

### OLD FLOW:
```
UI (pages/post/*.dart)
  ↓ uses
Post (model with JSON)
  ↓ uses
ApiService (direct HTTP)
```

### NEW FLOW (Clean Architecture):
```
UI (presentation/pages/post/*.dart)
  ↓ uses
PostEntity (domain entity)
  ↓ uses
Use Cases (domain/usecases/*.dart)
  ↓ uses
Repository Interface (domain/repositories/*.dart)
  ↓ implemented by
Repository Implementation (data/repositories/*.dart)
  ↓ uses
Data Source (data/datasources/*.dart)
  ↓ uses
PostModel (data/models/*.dart)
```

## 🎯 What You Need to Know

### Currently Active Files:
✅ **USE THESE:**
- `lib/presentation/pages/post/*.dart` - Your UI pages
- `lib/presentation/providers/post_provider.dart` - State management
- `lib/domain/entities/post_entity.dart` - Your data structure
- `lib/data/datasources/post_remote_data_source.dart` - API calls
- `lib/core/constants/api_constants.dart` - API URLs

### Old Files (Can be deleted or kept for reference):
⚠️ **NOT USED (but still exist):**
- `lib/pages/post/*.dart` - Old UI pages
- `lib/models/post.dart` - Old model
- `lib/services/api_service.dart` - Old service
- `lib/providers/post_provider.dart` - Old provider (in root)
- `lib/constants/api_contants.dart` - Old constants (with typo)

## 🔧 How to Switch Back (if needed)

If you want to use old files temporarily:
1. Update `main.dart` imports to use old paths
2. Update old files to import from old locations
3. Or delete new files and restore old ones

## 🚀 Next Steps

1. **Test the new structure** - Run your app, it should work the same
2. **Delete old files** (optional) - Once confirmed working:
   - `lib/pages/post/` (old pages)
   - `lib/models/post.dart` (old model)
   - `lib/services/api_service.dart` (old service)
   - `lib/providers/post_provider.dart` (old provider - root level)
   - `lib/constants/api_contants.dart` (old constants)

3. **Update any other files** that might import from old locations





