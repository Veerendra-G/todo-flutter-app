# FlowDo - Modern Material 3 Flutter Android Todo App

A production-grade, beautifully designed Android Todo Application built using **Flutter** and **Material Design 3**.

---

## 📱 Features

- **Modern Material 3 Design**: Supports both Dark Mode & Light Mode seamlessly with smooth animations.
- **Task Management**:
  - Add tasks with title, description, category, priority, due date, and reminder time.
  - Interactive completion toggle with animated checkmarks and strike-through text.
  - Edit tasks anytime by tapping the card.
  - Swipe-to-dismiss (delete) with an instant **Undo** SnackBar.
- **Categorization & Priorities**:
  - Categories: Work, Personal, Shopping, Health, Study, Home, Other.
  - Priority levels: High (Urgent), Medium, Low with color-coded badges and icons.
- **Smart Scheduling & Overdue Alerts**:
  - Pick due dates & times.
  - Real-time overdue indicator for incomplete deadlines.
  - Relative time tags: *Today*, *Tomorrow*, *Yesterday*, *X days overdue*.
- **Search, Filtering & Sorting**:
  - Instant live search bar by title and description.
  - Filter tabs: All, Active, Completed.
  - Filter chips by category.
  - Sort by Due Date, Priority, Creation Date, or Alphabetical.
- **Productivity Dashboard**:
  - Visual progress bar showing daily/total completion percentage.
  - Dedicated Analytics & Statistics screen with task distribution by priority and category.
- **Offline Persistence**:
  - Automatically saves all tasks locally using `shared_preferences`.
  - Comes pre-populated with friendly sample tasks on first launch.

---

## 📁 Project Architecture

```
flutter_todo_app/
├── android/                             # Android native configuration
│   ├── app/
│   │   ├── build.gradle                 # Android app Gradle configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml      # App permissions and launch activity
│   │       └── kotlin/com/example/flutter_todo_app/MainActivity.kt
│   ├── build.gradle                     # Top-level Gradle configuration
│   └── settings.gradle                  # Gradle plugin loader
├── lib/
│   ├── main.dart                        # App entry point with MultiProvider & theme
│   ├── models/
│   │   ├── category.dart                # TaskCategory enum with icons & colors
│   │   ├── priority.dart                # Priority enum with levels & colors
│   │   └── todo_item.dart               # TodoItem data model with serialization
│   ├── providers/
│   │   └── todo_provider.dart           # State management & local persistence
│   ├── screens/
│   │   ├── home_screen.dart             # Main dashboard with task list & filters
│   │   ├── add_edit_todo_screen.dart    # Create & edit task screen with date picker
│   │   └── stats_screen.dart            # Analytics & productivity summary screen
│   ├── theme/
│   │   └── app_theme.dart               # Material 3 light & dark theme definitions
│   └── widgets/
│       ├── category_filter_bar.dart     # Horizontal category chip bar
│       ├── empty_state_view.dart        # Clean empty & no-search-results state
│       ├── priority_badge.dart          # Colored priority pill
│       ├── stats_header.dart            # Today's progress banner
│       └── todo_tile.dart               # Animated task card with swipe-to-delete
├── test/
│   ├── todo_model_test.dart             # Unit tests for data model & serialization
│   └── widget_test.dart                 # Widget tests for UI rendering
└── pubspec.yaml                         # Dependencies and assets
```

---

## 🚀 How to Run the App

### 1. Install Flutter (If not installed)
1. Download Flutter SDK for Windows from [flutter.dev](https://docs.flutter.dev/get-started/install/windows).
2. Extract the zip file (e.g., to `C:\src\flutter`).
3. Add `C:\src\flutter\bin` to your system `PATH` environment variable.
4. Run `flutter doctor` in your terminal to verify installation.

### 2. Set Up Android Studio / Device
- Install **Android Studio** and the **Android SDK Command-line Tools**.
- Start an Android Emulator from Android Studio Device Manager, or connect an Android phone with USB Debugging enabled.

### 3. Run the App
Open a terminal in this project folder:
```bash
cd C:\Users\gandl\.gemini\antigravity\scratch\flutter_todo_app

# Fetch dependencies
flutter pub get

# Run on Android emulator or connected device
flutter run
```

### 4. Build Android APK / App Bundle
```bash
# Build Release APK
flutter build apk --release

# The APK will be generated at:
# build/app/outputs/flutter-apk/app-release.apk

# Build Google Play App Bundle (AAB)
flutter build appbundle
```
