# 📱 TaskApp – Screen Flow & Architecture

This document summarises how users move through the app and how the code is layered.

---

## 🗺️ Screen Flow

### Navigation at a Glance

```
┌───────────────────────────────────────────────┐
│                TaskApp (main.dart)             │
│  • AppTheme (light/dark)                       │
│  • Locale switcher (en/km/zh)                  │
└───────────────┬───────────────────────────────┘
                │
        ┌───────▼────────┐
        │   PostsPage     │
        │ • Post feed     │
        │ • Pull-to-refresh│
        │ • FAB (create)  │
        └───────┬────────┘
                │
    ┌───────────┴───────────┐
    │                       │
┌───▼────┐             ┌────▼────┐
│PostForm│             │PostDetail│
│(Create)│             │  Page    │
└───┬────┘             └────┬─────┘
    │                       │
    │     ┌─────────────────┘
    │     │ Edit button
    │     ▼
┌───┴────┐
│PostForm│
│ (Edit) │
└────────┘
```

### Screen Summary

| Screen | Purpose | Highlights |
|--------|---------|------------|
| PostsPage | Landing feed showing all posts | `PostCard`, theme toggle, locale switch, global FAB |
| PostFormPage | Create or edit a post | Form sections, validation, gallery picker, saving state |
| PostDetailPage | Inspect a single post | Hero image, metadata chips, edit/delete actions |

### Key User Journeys

1. **Create a post**
   ```
   PostsPage → FAB → PostFormPage → fill form + image → Save → PostsPage (new card)
   ```
2. **Edit a post**
   ```
   PostsPage → Card tap → PostDetailPage → Edit → PostFormPage → Save → back to Detail/List
   ```
3. **Delete a post**
   ```
   PostsPage → Card tap → PostDetailPage → Delete → Confirm dialog → card removed
   ```
4. **Change theme or language**
   ```
   PostsPage AppBar → Theme icon / Locale dropdown → UI re-renders immediately
   ```

---

## 🏗️ Architecture Overview

### Clean Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│              PRESENTATION LAYER (UI)                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │    Pages      │  │  Providers   │  │   Widgets    │ │
│  │  - PostsPage  │  │ - PostProv.  │  │ - CustomBtn  │ │
│  │  - PostForm   │  │ - ThemeProv. │  │ - Loading    │ │
│  │  - PostDetail │  │ - LocaleProv.│  │              │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│            DOMAIN LAYER (Business Logic)                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Entities   │  │ Repositories │  │  Use Cases  │ │
│  │ - PostEntity │  │ - Interface  │  │ - GetPosts   │ │
│  │              │  │              │  │ - CreatePost │ │
│  │              │  │              │  │ - UpdatePost │ │
│  │              │  │              │  │ - DeletePost │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│              DATA LAYER (Data Sources)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Models     │  │ Data Sources │  │ Repositories │ │
│  │ - PostModel  │  │ - Remote      │  │ - Impl       │ │
│  │              │  │   DataSource  │  │              │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│              CORE LAYER (Shared)                        │
│  ┌──────────────┐  ┌──────────────┐                    │
│  │  Constants   │  │   Errors     │                    │
│  │ - API URLs    │  │ - Failures   │                    │
│  └──────────────┘  └──────────────┘                    │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Location | Responsibilities | Depends On |
|-------|----------|-------------------|------------|
| **Presentation** | `lib/presentation/` | Pages, reusable widgets, themed UI, Riverpod providers | Domain |
| **Domain** | `lib/domain/` | `PostEntity`, repository contracts, use cases (Get/Create/Update/Delete) | — |
| **Data** | `lib/data/` | `PostModel`, remote data source, repository implementation | Domain + Core |
| **Core** | `lib/core/` | Shared constants (API URLs), errors (`Failure`) | — |

### Data Flow Example: Fetching Posts

```
1. User opens PostsPage
   ↓
2. PostsPage watches postsProvider
   ↓
3. postsProvider calls GetPosts use case
   ↓
4. GetPosts calls PostRepository.getPosts()
   ↓
5. PostRepositoryImpl calls PostRemoteDataSource.getPosts()
   ↓
6. PostRemoteDataSource makes HTTP GET request
   ↓
7. API returns JSON data
   ↓
8. PostModel.fromJson() converts JSON → PostModel
   ↓
9. PostModel.toEntity() converts PostModel → PostEntity
   ↓
10. PostEntity returned to PostsPage
    ↓
11. UI displays posts
```

### Project Structure

```
lib/
├── core/            # api_constants, failures
├── domain/          # entities, repositories, usecases
├── data/            # models, remote data source, repo impl
├── presentation/
│   ├── pages/post/  # posts_page, post_form_page, post_details_page
│   ├── providers/   # Riverpod notifiers
│   ├── widgets/     # buttons, cards, forms, indicators
│   └── theme/       # AppTheme
├── l10n/            # localisation files
└── main.dart
```

### Key Design Patterns

1. **Repository Pattern**
   - Domain defines interface
   - Data implements interface
   - Decouples business logic from data sources

2. **Use Case Pattern**
   - One use case = One business operation
   - Easy to test and maintain

3. **Dependency Inversion**
   - High-level modules don't depend on low-level modules
   - Both depend on abstractions (interfaces)

4. **State Management (Riverpod)**
   - AsyncNotifier for async state
   - StateNotifier for simple state
   - Provider for dependency injection

---

## 🚀 Quick Start

### Running the App

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Key Features

- ✅ **Posts Management:** CRUD operations
- ✅ **Image Upload:** Pick from gallery
- ✅ **Dark Mode:** Toggle theme
- ✅ **Multi-Language:** English, Khmer, Chinese
- ✅ **Clean Architecture:** Well-organized code
- ✅ **Error Handling:** Comprehensive error management

### API Endpoints

- **Base URL:** `https://jsonplaceholder.typicode.com`
- **Posts:** `/posts`
- **Photos:** `/photos`

---

## 📊 Architecture Benefits

1. **Separation of Concerns:** Each layer has single responsibility
2. **Testability:** Easy to mock and test independently
3. **Maintainability:** Changes in one layer don't affect others
4. **Scalability:** Easy to add new features
5. **Dependency Rule:** Dependencies point inward

---

## 🔗 Related Documentation

- `README.md` - Full project documentation
- `API_FIXES.md` - API connection details
- `LAYER_GUIDE.md` - Layer organization guide
- `WHERE_TO_PUT_FILES.md` - File placement guide
- `QUICK_DOCS.md` - One-page reference

---

**Last Updated:** 2024
**Version:** 1.0.0


