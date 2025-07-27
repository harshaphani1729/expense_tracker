# Expense Tracker

A simple and intuitive expense tracking application built with Flutter.

## Features

- ✅ Add, view, and delete expenses
- 📊 Categorize expenses (Food, Transportation, Shopping, etc.)
- 📈 View expense dashboard with category breakdown
- 👆 Swipe to delete expenses
- 💾 Local SQLite database storage

## Getting Started

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart              # Entry point
├── models/
│   ├── expense.dart       # Expense data model
│   └── database_helper.dart # SQLite database helper
└── screens/
    ├── home_screen.dart        # Main expense list
    ├── add_expense_screen.dart # Add new expense form
    └── dashboard_screen.dart   # Expense statistics
```

## Dependencies

- flutter: SDK
- sqflite: Local database
- path: File path utilities
- intl: Date formatting
- cupertino_icons: iOS-style icons

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

The built APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## Troubleshooting

1. **Flutter not recognized**: Make sure Flutter is added to your PATH
2. **Dependencies issues**: Run `flutter clean` then `flutter pub get`
3. **Build issues**: Run `flutter doctor` to check for missing dependencies

## Contributing

Feel free to submit issues and pull requests to improve the app!
