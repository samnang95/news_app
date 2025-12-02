# 📱 TaskApp - Quick Documentation

## 🗺️ Screen Flow

```
┌─────────────────────────────────────┐
│         Main App (main.dart)         │
│  - Theme: Light/Dark                 │
│  - Language: en/km/zh                │
└──────────────┬───────────────────────┘
               │
    ┌──────────▼──────────┐
    │    PostsPage         │
    │  • Posts List        │
    │  • Pull to Refresh   │
    │  • Theme Toggle      │
    │  • Language Switch   │
    │  • FAB (Create)       │
    └──────┬───────┬───────┘
           │       │
    ┌──────▼──┐ ┌──▼──────┐
    │  Post   │ │  Post   │
    │  Form   │ │ Details │
    │ (New)   │ │  Page   │
    └─────────┘ └────┬────┘
                     │
              ┌──────▼──────┐
              │  Post Form  │
              │   (Edit)    │
              └─────────────┘
```

### Navigation Paths

**Create Post:**
```
PostsPage → FAB → PostForm (New) → Save → PostsPage
```

**View Post:**
```
PostsPage → Tap Post → PostDetail
```

**Edit Post:**
```
PostsPage → Tap Post → PostDetail → Edit → PostForm (Edit) → Save
```

**Delete Post:**
```
PostsPage → Tap Post → PostDetail → Delete → PostsPage
```

### Widget Highlights

| Screen | Key Widgets |
|--------|-------------|
| PostsPage | `PostCard`, `CustomIconButton`, `LoadingIndicator`, `ErrorDisplay` |
| PostDetailPage | `InfoCard`, `CustomButton`, hero image container |
| PostFormPage | `FormSection`, `CustomTextField`, `ImagePickerField`, `CustomButton` |

---

## 🏗️ Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│     PRESENTATION (UI)                │
│  Pages • Providers • Widgets • Theme │
└──────────────┬───────────────────────┘
               │ uses
┌──────────────▼───────────────────────┐
│     DOMAIN (Business Logic)           │
│  Entities • Repositories • Use Cases  │
└──────────────┬───────────────────────┘
               │ implemented by
┌──────────────▼───────────────────────┐
│     DATA (Data Sources)               │
│  Models • Data Sources • Repositories │
└──────────────┬───────────────────────┘
               │ uses
┌──────────────▼───────────────────────┐
│     CORE (Shared)                     │
│  Constants • Errors                   │
└───────────────────────────────────────┘
```

| Layer | Folder | Purpose |
|-------|--------|---------|
| Presentation | `lib/presentation/` | Pages, providers, reusable widgets, theme |
| Domain | `lib/domain/` | Entities, repository interfaces, use cases |
| Data | `lib/data/` | Models, remote data source, repository implementation |
| Core | `lib/core/` | Shared constants (API), failures |

### Data Flow: Fetch Posts

```
UI (PostsPage)
  ↓ watches
Provider (postsProvider)
  ↓ calls
Use Case (GetPosts)
  ↓ calls
Repository Interface
  ↓ implemented by
Repository Impl
  ↓ calls
Data Source (API)
  ↓ returns
PostModel → PostEntity → UI
```

### Folder Structure

```
lib/
├── core/              # Constants, Errors
├── domain/             # Entities, Use Cases
├── data/               # Models, API Calls
├── presentation/       # Pages, Providers, Theme, Widgets
└── l10n/               # Localization
```

---

## 📋 Key Components

### Presentation Layer
- **PostsPage** - List all posts
- **PostFormPage** - Create/Edit post
- **PostDetailPage** - View post details
- **Providers** - State management (Riverpod)

### Domain Layer
- **PostEntity** - Business object
- **Use Cases** - GetPosts, CreatePost, UpdatePost, DeletePost
- **Repository Interface** - Data contract

### Data Layer
- **PostModel** - JSON serialization
- **PostRemoteDataSource** - API calls
- **PostRepositoryImpl** - Repository implementation

### Core Layer
- **ApiConstants** - API URLs
- **Failures** - Error types

---

## 🔄 User Actions → Data Flow

### Example: Create Post

1. **User:** Fills form, picks image, taps Save
2. **UI:** PostFormPage creates PostEntity
3. **Provider:** Calls CreatePost use case
4. **Use Case:** Calls repository.createPost()
5. **Repository:** Converts Entity → Model
6. **Data Source:** Sends HTTP POST
7. **API:** Returns created post
8. **Flow Reverses:** Model → Entity → UI
9. **UI:** New post appears in list

---

## ✅ Features

- ✅ CRUD Operations (Create, Read, Update, Delete)
- ✅ Image Upload (Gallery picker)
- ✅ Dark Mode Toggle
- ✅ Multi-Language (en/km/zh)
- ✅ Pull to Refresh
- ✅ Optimistic Updates
- ✅ Error Handling

---

## 🚀 Quick Start

```bash
flutter pub get
flutter run
```

---

**For detailed docs, see:** `DOCUMENTATION.md`


