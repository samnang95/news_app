# TaskApp - Flutter Clean Architecture

A Flutter application demonstrating Clean Architecture principles with posts management, image uploads, and multi-language support.

## 📋 Table of Contents

1. [Features](#features)
2. [Architecture Overview](#architecture-overview)
3. [Step-by-Step: Understanding the File Structure](#step-by-step-understanding-the-file-structure)
4. [Step-by-Step: How Data Flows](#step-by-step-how-data-flows)
5. [Step-by-Step: Finding Your Files](#step-by-step-finding-your-files)
6. [Getting Started](#getting-started)
7. [Project Structure](#project-structure)
8. [API Documentation](#api-documentation)

---

## Features

- **Posts Management**: View, create, edit, and delete posts
- **Image Upload**: Pick images from gallery or use API photos
- **Pull to Refresh**: Refresh the posts list
- **Dark Mode**: Toggle between light and dark themes, persisted across app restarts
- **Multi-Language**: Support for English, Khmer, and Chinese
- **Optimistic Updates**: Instant UI updates with rollback on failure
- **Clean Architecture**: Well-organized, testable, and maintainable code structure

---

## Architecture Overview

This project follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│      PRESENTATION LAYER (UI)            │
│  - Pages, Widgets, State Management    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│       DOMAIN LAYER (Business Logic)      │
│  - Entities, Use Cases, Repositories     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│        DATA LAYER (Data Sources)        │
│  - Models, Data Sources, Repositories   │
└─────────────────────────────────────────┘
```

---

## Step-by-Step: Understanding the File Structure

### Step 1: Core Layer (Shared Utilities)

**Location**: `lib/core/`

This layer contains shared utilities used across the entire app.

#### Files:
- **`core/constants/api_constants.dart`**
  - Contains API base URLs and headers
  - Used by data layer for making HTTP requests
  - Example: `ApiConstants.postsUrl`, `ApiConstants.jsonHeaders`

- **`core/errors/failures.dart`**
  - Defines error types (ServerFailure, NetworkFailure, etc.)
  - Used for consistent error handling across layers

**Why it exists**: Centralizes shared constants and error definitions.

---

### Step 2: Domain Layer (Business Logic)

**Location**: `lib/domain/`

This layer contains pure business logic with **NO external dependencies**.

#### 2.1 Entities (`domain/entities/`)
- **`post_entity.dart`**
  - Pure Dart class representing a Post
  - **No JSON serialization** - just business data
  - Contains: `id`, `userId`, `title`, `body`, `imageFile`, `imageUrl`

**Key Point**: Entity is independent of data sources (API, database, etc.)

#### 2.2 Repositories (`domain/repositories/`)
- **`post_repository.dart`**
  - **Interface/Contract** defining what data operations are needed
  - Methods: `getPosts()`, `createPost()`, `updatePost()`, `deletePost()`
  - **No implementation** - just the contract

**Key Point**: Domain defines WHAT it needs, not HOW it's done.

#### 2.3 Use Cases (`domain/usecases/`)
- **`get_posts.dart`** - Fetch all posts
- **`create_post.dart`** - Create a new post
- **`update_post.dart`** - Update existing post
- **`delete_post.dart`** - Delete a post

**Key Point**: Each use case represents a single business operation.

---

### Step 3: Data Layer (Data Sources)

**Location**: `lib/data/`

This layer handles all data operations (API calls, local storage, etc.)

#### 3.1 Models (`data/models/`)
- **`post_model.dart`**
  - Extends `PostEntity` from domain
  - Adds JSON serialization (`fromJson`, `toJson`)
  - Converts between Entity ↔ Model

**Key Point**: Model = Entity + JSON serialization

#### 3.2 Data Sources (`data/datasources/`)
- **`post_remote_data_source.dart`**
  - Makes HTTP API calls
  - Handles JSON parsing
  - Returns `PostModel` objects
  - Replaces the old `api_service.dart`

**Key Point**: Only handles data fetching, no business logic.

#### 3.3 Repository Implementation (`data/repositories/`)
- **`post_repository_impl.dart`**
  - Implements the `PostRepository` interface from domain
  - Uses data sources to fetch data
  - Converts Models → Entities before returning

**Key Point**: Bridges domain and data layers.

---

### Step 4: Presentation Layer (UI)

**Location**: `lib/presentation/`

This layer contains all UI-related code.

#### 4.1 Pages (`presentation/pages/post/`)
- **`post_form_page.dart`** - Create/Edit post form
- **`posts_page.dart`** - List of all posts
- **`post_details_page.dart`** - View single post details

**Key Point**: Pages use `PostEntity` (domain), not `PostModel` (data).

#### 4.2 Providers (`presentation/providers/`)
- **`post_provider.dart`**
  - State management using Riverpod
  - Uses use cases from domain layer
  - Manages posts list state

- **`theme_provider.dart`** - Theme management
- **`locale_provider.dart`** - Language management

**Key Point**: Providers orchestrate use cases, not direct API calls.

---

## Step-by-Step: How Data Flows

### Example: Fetching Posts

```
1. USER ACTION
   User opens PostsPage
   ↓
2. PRESENTATION LAYER
   posts_page.dart calls postsProvider
   ↓
3. PROVIDER
   post_provider.dart calls GetPosts use case
   ↓
4. DOMAIN LAYER
   GetPosts use case calls PostRepository interface
   ↓
5. DATA LAYER
   PostRepositoryImpl implements the interface
   ↓
6. DATA SOURCE
   post_remote_data_source.dart makes HTTP call
   ↓
7. API RESPONSE
   Returns JSON data
   ↓
8. MODEL CONVERSION
   post_model.dart converts JSON → PostModel
   ↓
9. ENTITY CONVERSION
   post_repository_impl.dart converts PostModel → PostEntity
   ↓
10. USE CASE
    Returns PostEntity to provider
    ↓
11. UI UPDATE
    posts_page.dart displays the posts
```

### Example: Creating a Post

```
1. USER ACTION
   User fills form and clicks Save
   ↓
2. PRESENTATION LAYER
   post_form_page.dart creates PostEntity
   ↓
3. PROVIDER
   Calls CreatePost use case
   ↓
4. DOMAIN LAYER
   CreatePost calls PostRepository.createPost()
   ↓
5. DATA LAYER
   PostRepositoryImpl converts PostEntity → PostModel
   ↓
6. DATA SOURCE
   post_remote_data_source.dart sends HTTP POST
   ↓
7. API RESPONSE
   Returns created post JSON
   ↓
8. CONVERSION
   PostModel → PostEntity
   ↓
9. UI UPDATE
   New post appears in list
```

---

## Step-by-Step: Finding Your Files

### Your Old Files (Still Exist!)

Your original code is **NOT deleted**. It's still in these locations:

#### Old Model
- **Location**: `lib/models/post.dart`
- **What it was**: Mixed model with JSON serialization
- **Status**: Still exists, but not used by new architecture

#### Old API Service
- **Location**: `lib/services/api_service.dart`
- **What it was**: Direct HTTP calls
- **Status**: Still exists, replaced by `data/datasources/post_remote_data_source.dart`

#### Old Provider
- **Location**: `lib/providers/post_provider.dart`
- **What it was**: Direct service usage
- **Status**: Still exists, replaced by `presentation/providers/post_provider.dart`

#### Old Pages
- **Location**: `lib/pages/post/`
  - `post_form_page.dart`
  - `posts_page.dart`
  - `post_details_page.dart`
- **Status**: Still exist, replaced by `presentation/pages/post/`

### New Files (Currently Active)

#### New Entity
- **Location**: `lib/domain/entities/post_entity.dart`
- **What it is**: Pure business object (no JSON)

#### New Data Source
- **Location**: `lib/data/datasources/post_remote_data_source.dart`
- **What it is**: API calls (replaces old `api_service.dart`)

#### New Provider
- **Location**: `lib/presentation/providers/post_provider.dart`
- **What it is**: Uses use cases instead of direct service calls

#### New Pages
- **Location**: `lib/presentation/pages/post/`
- **What they are**: Use `PostEntity` instead of `Post` model

### Quick File Mapping

| What You Need | Old Location | New Location |
|---------------|--------------|--------------|
| **Data Model** | `lib/models/post.dart` | `lib/domain/entities/post_entity.dart` |
| **JSON Model** | `lib/models/post.dart` | `lib/data/models/post_model.dart` |
| **API Calls** | `lib/services/api_service.dart` | `lib/data/datasources/post_remote_data_source.dart` |
| **State Management** | `lib/providers/post_provider.dart` | `lib/presentation/providers/post_provider.dart` |
| **Form Page** | `lib/pages/post/post_form_page.dart` | `lib/presentation/pages/post/post_form_page.dart` |
| **List Page** | `lib/pages/post/posts_page.dart` | `lib/presentation/pages/post/posts_page.dart` |
| **Detail Page** | `lib/pages/post/post_details_page.dart` | `lib/presentation/pages/post/post_details_page.dart` |

---

## Getting Started

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Android Studio / VS Code / Cursor with Flutter extensions

### Installation Steps

1. **Clone the repository** (if applicable)
   ```bash
   git clone <repository-url>
   cd taskapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localizations** (if needed)
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Running on Specific Devices

- **iOS Simulator**: `flutter run -d ios`
- **Android Emulator**: `flutter run -d android`
- **Chrome**: `flutter run -d chrome`
- **macOS**: `flutter run -d macos`

---

## Project Structure

```
lib/
├── core/                           # Shared utilities
│   ├── constants/
│   │   └── api_constants.dart     # API URLs and headers
│   └── errors/
│       └── failures.dart          # Error types
│
├── domain/                        # Business logic (no dependencies)
│   ├── entities/
│   │   └── post_entity.dart      # Pure business object
│   ├── repositories/
│   │   └── post_repository.dart  # Repository interface
│   └── usecases/
│       ├── get_posts.dart        # Fetch posts use case
│       ├── create_post.dart     # Create post use case
│       ├── update_post.dart     # Update post use case
│       └── delete_post.dart     # Delete post use case
│
├── data/                          # Data layer
│   ├── models/
│   │   └── post_model.dart      # JSON serialization model
│   ├── datasources/
│   │   └── post_remote_data_source.dart  # API calls
│   └── repositories/
│       └── post_repository_impl.dart     # Repository implementation
│
├── presentation/                  # UI layer
│   ├── pages/
│   │   └── post/
│   │       ├── post_form_page.dart      # Create/Edit form
│   │       ├── posts_page.dart         # Posts list
│   │       └── post_details_page.dart   # Post details
│   └── providers/
│       ├── post_provider.dart           # Posts state management
│       ├── theme_provider.dart          # Theme management
│       └── locale_provider.dart         # Language management
│
├── l10n/                          # Localization files
│   ├── app_en.arb
│   ├── app_km.arb
│   └── app_zh.arb
│
├── theme/                         # Theme configuration
│   └── app_them.dart
│
└── main.dart                      # App entry point
```

---

## API Documentation

### JSONPlaceholder API

This app uses the [JSONPlaceholder](https://jsonplaceholder.typicode.com) API for testing.

#### Endpoints Used:

- **GET** `/posts` - Fetch all posts
- **GET** `/posts/{id}` - Fetch single post
- **POST** `/posts` - Create new post
- **PUT** `/posts/{id}` - Update post
- **DELETE** `/posts/{id}` - Delete post
- **GET** `/photos?_limit=100` - Fetch photos for post images

#### Base URL:
```
https://jsonplaceholder.typicode.com
```

**Note**: JSONPlaceholder is a fake REST API. Changes are not persisted server-side but are reflected in the response.

---

## Key Concepts Explained

### Clean Architecture Benefits

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Easy to mock and test each layer independently
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features following the same pattern
5. **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)

### Entity vs Model

- **Entity** (`PostEntity`): Pure business object, no external dependencies
- **Model** (`PostModel`): Extends entity, adds JSON serialization

### Repository Pattern

- **Interface** (Domain): Defines WHAT operations are needed
- **Implementation** (Data): Defines HOW operations are performed

### Use Cases

Each use case represents a single business operation:
- One use case = One responsibility
- Easy to test
- Easy to understand

---

## Troubleshooting

### Can't Find Old Files?

Your old files are still in:
- `lib/pages/post/` - Old pages
- `lib/models/post.dart` - Old model
- `lib/services/api_service.dart` - Old service
- `lib/providers/post_provider.dart` - Old provider

### Want to Use Old Files?

1. Update imports in `main.dart` to use old paths
2. Or restore old files from version control

### App Not Working?

1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `flutter run`

---

## Learning Resources

This project demonstrates:
- ✅ Clean Architecture principles
- ✅ Repository pattern
- ✅ Use case pattern
- ✅ Dependency inversion
- ✅ State management with Riverpod
- ✅ Image picking and display
- ✅ Multi-language support
- ✅ Theme management
- ✅ API integration

---

## License

This project is for educational purposes.

---

## Contributing

Feel free to fork, modify, and use this project for learning Clean Architecture in Flutter!
# news_app
