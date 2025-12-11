# Task Manager

A Flutter mobile application demonstrating clean architecture, modern state management with Riverpod, and local data persistence with Hive.

## 📋 Overview

This Task Manager application was built as a technical assessment to showcase mobile development expertise, focusing on:

- **Clean Architecture**: Feature-based organization with clear separation of concerns
- **State Management**: Reactive state management using Riverpod
- **Data Persistence**: Local storage with Hive for offline-first functionality
- **Modern UI/UX**: Material Design 3 with intuitive user interactions
- **Best Practices**: Type safety, error handling, code quality, and maintainability

## ✨ Features

### Core Functionality
- ✅ **Task List**: View all tasks with title, description, and completion status
- ✅ **Empty State**: Friendly UI when no tasks exist or no search results
- ✅ **Add Tasks**: Create new tasks with title and description
- ✅ **Edit Tasks**: Update existing task information by tapping on them
- ✅ **Delete Tasks**: Remove tasks with swipe-to-delete gesture and confirmation dialog
- ✅ **Toggle Completion**: Mark tasks as complete/incomplete with checkbox
- ✅ **Search**: Real-time search filtering by title or description
- ✅ **Data Persistence**: All tasks persist between app sessions using Hive

### UI/UX Features
- 📱 Material Design 3 theming
- 🔍 Expandable search bar in app bar
- 📊 Task statistics (completed/total count)
- 🎨 Visual feedback for completed tasks (strikethrough, reduced opacity)
- 🔄 Pull-to-refresh for task list
- ⏰ Smart date formatting (Today, Yesterday, X days ago)
- ⚠️ Form validation with clear error messages
- 💾 Loading states during async operations
- ❌ Error handling with retry options

## 🏗️ Architecture

### Project Structure

```
lib/
├── features/
│   └── tasks/
│       ├── models/
│       │   ├── task_model.dart          # Task data model with Hive annotations
│       │   └── task_model.g.dart        # Generated Hive type adapter
│       ├── providers/
│       │   ├── task_list_provider.dart  # Task state management
│       │   └── search_provider.dart     # Search state management
│       ├── services/
│       │   └── task_service.dart        # Business logic & CRUD operations
│       ├── screens/
│       │   ├── task_list_screen.dart    # Main task list screen
│       │   └── task_form_screen.dart    # Add/edit task screen
│       └── widgets/
│           ├── task_card.dart           # Reusable task card widget
│           ├── empty_state.dart         # Empty state UI component
│           └── delete_dialog.dart       # Confirmation dialog
├── utils/
│   └── constants.dart                   # App constants & strings
└── main.dart                            # App entry point
```

### Architecture Pattern: Clean Architecture with Feature-Based Organization

The application follows **Clean Architecture** principles with a feature-based folder structure:

#### 1. **Data Layer** (`models/`)
- Defines the `Task` data model
- Uses Hive type adapters for serialization
- Immutable data structures with `copyWith()` method

#### 2. **Business Logic Layer** (`services/`)
- `TaskService` encapsulates all CRUD operations
- Handles data validation and error handling
- Provides search and filtering functionality
- Independent of UI framework

#### 3. **State Management Layer** (`providers/`)
- Riverpod providers for reactive state management
- `TaskListNotifier` manages task list state
- Separate providers for search functionality
- Compile-time safe state access

#### 4. **Presentation Layer** (`screens/` & `widgets/`)
- UI components consume state from providers
- Reusable widgets for consistency
- Responsive to state changes
- Clear separation from business logic

### Why This Architecture?

✅ **Scalability**: Easy to add new features without affecting existing code  
✅ **Testability**: Each layer can be tested independently  
✅ **Maintainability**: Clear boundaries make code easier to understand and modify  
✅ **Team Collaboration**: Multiple developers can work on different features simultaneously  
✅ **Separation of Concerns**: Business logic is isolated from UI and data layers  

## 🎯 State Management: Riverpod

### Why Riverpod?

The application uses **Riverpod** (version 2.5.1) for state management:

- **Compile-Time Safety**: Catches errors at compile-time rather than runtime
- **No BuildContext**: Access state without needing context
- **Better Performance**: Fine-grained reactivity rebuilds only what's necessary
- **Easy Testing**: Providers can be easily overridden for testing
- **Modern Approach**: Active development and strong community support

### State Management Pattern

```dart
// Provider for the service
final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

// StateNotifier for managing state
class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  // Handles loading, data, and error states
}

// StateNotifier provider
final taskListProvider = StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>(...);
```

### Key Benefits:
- **Immutable State**: All state changes create new state objects
- **AsyncValue**: Built-in loading, data, and error states
- **Automatic Disposal**: Providers automatically clean up when no longer needed
- **DevTools Support**: Integration with Flutter DevTools for debugging

## 💾 Data Persistence: Hive

### Why Hive over SQLite?

- **Performance**: Up to 10x faster for simple CRUD operations
- **Type Safety**: Code generation ensures compile-time type safety
- **Simplicity**: No SQL queries, minimal boilerplate
- **Cross-Platform**: Works seamlessly on all Flutter platforms
- **Lightweight**: Small binary size impact

### Hive Setup

```dart
// 1. Define model with annotations
@HiveType(typeId: 0)
class Task {
  @HiveField(0) final String id;
  @HiveField(1) final String title;
  // ...
}

// 2. Generate adapters
// flutter pub run build_runner build

// 3. Initialize and register
await Hive.initFlutter();
Hive.registerAdapter(TaskAdapter());

// 4. Open box and use
final box = await Hive.openBox<Task>('tasks');
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: ≥3.9.0
- Dart SDK: ≥3.0.0

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Aradhik11/task_manager.git
   cd task_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Hive type adapters)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Running on Different Platforms

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Web
flutter run -d chrome
```

## 📦 Dependencies

### Production Dependencies
- **flutter_riverpod** (^2.5.1): State management solution
- **hive** (^2.2.3): NoSQL database for local storage
- **hive_flutter** (^1.1.0): Hive integration for Flutter
- **path_provider** (^2.1.1): Access to filesystem paths
- **uuid** (^4.2.2): Generate unique task IDs

### Development Dependencies
- **hive_generator** (^2.0.1): Code generation for Hive type adapters
- **build_runner** (^2.4.7): Dart code generation tool
- **flutter_lints** (^5.0.0): Recommended linting rules

## 🧪 Testing

### Static Analysis
```bash
flutter analyze
```

### Running Tests
```bash
flutter test
```

### Manual Testing Scenarios

1. **Task Creation**
   - Open app → Tap FAB → Enter title/description → Save
   - Verify task appears in list

2. **Task Persistence**
   - Create multiple tasks → Close app → Reopen
   - Verify all tasks are still present

3. **Task Editing**
   - Tap on task → Modify fields → Save
   - Verify changes are reflected

4. **Task Completion**
   - Toggle checkbox on task
   - Verify visual feedback (strikethrough)

5. **Task Deletion**
   - Swipe task left → Confirm deletion
   - Verify task is removed

6. **Search Functionality**
   - Tap search icon → Enter query
   - Verify filtered results

## 🎨 Code Quality

### Best Practices Implemented

✅ **Consistent Naming**: Clear, descriptive variable and function names  
✅ **Type Safety**: Strong typing throughout the codebase  
✅ **Error Handling**: Try-catch blocks with meaningful error messages  
✅ **Code Comments**: Meaningful comments for complex logic  
✅ **Separation of Concerns**: Clear boundaries between layers  
✅ **DRY Principle**: Reusable widgets and utility functions  
✅ **Immutability**: Immutable data models with copyWith()  
✅ **Single Responsibility**: Each class has a single, well-defined purpose  

### Linting
The project uses `flutter_lints` with strict linting rules to ensure code quality.

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## 👨‍💻 Development Notes

### Design Decisions

1. **Riverpod over Provider**: Chosen for compile-time safety and better performance
2. **Hive over SQLite**: Preferred for simplicity and speed in a CRUD-heavy app
3. **Feature-Based Structure**: Scales better than layer-based organization
4. **Material Design 3**: Modern, accessible UI components
5. **Swipe-to-Delete**: Common mobile pattern for delete actions
6. **Confirmation Dialogs**: Prevents accidental deletions

### Edge Cases Handled

- Empty title validation
- Maximum length constraints
- Search with no results
- App restart data persistence
- Async operation loading states
- Error recovery with retry options


---

**Built with ❤️ using Flutter**

