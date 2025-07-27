# Expense Tracker

A simple and intuitive expense tracking application built with Flutter.

## Features

- ✅ Add, view, and delete expenses
- 📊 **Dynamic Category Management** - Create, edit, and delete custom categories
- 🎨 **Visual Categories** - Categories with custom icons and colors
- 📈 View expense dashboard with category breakdown
- 👆 Swipe to delete expenses
- 💾 Local SQLite database storage
- 🔄 **Auto-migration** - Seamless database upgrades

## Getting Started

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

## ✨ Category Management System

### New Features Added:

#### 1. **Category Model** (`lib/models/category.dart`)
- Categories now have `name`, `icon`, and `color` properties
- Full CRUD operations support

#### 2. **Enhanced Database** 
- **New categories table** with icon and color support
- **Database version upgraded** to v2 with automatic migration
- **Default categories** automatically created: Food 🍔, Transportation 🚗, Shopping 🛍️, Entertainment 🎬, Bills 📄, Health 🏥, Other 📦

#### 3. **Category Management Screen** (`lib/screens/category_management_screen.dart`)
- ➕ **Add new categories** with custom icons and colors
- ✏️ **Edit existing categories**
- 🗑️ **Delete categories** (moves expenses to "Other")
- 🎨 **20 icons** and **10 colors** to choose from
- ✅ **Validation** to prevent duplicate names

#### 4. **Improved Add Expense Screen**
- 🎯 **Dynamic category dropdown** loaded from database
- 🖼️ **Visual category display** with icons and colors
- ⚙️ **Settings button** to access category management
- 🔄 **Auto-refresh** categories when returning from management

#### 5. **Enhanced Home Screen**
- 📋 **Menu option** to access category management
- 🔄 **Auto-refresh** when categories are modified

### 🚀 How to Use:

#### **Access Category Management:**
- From home screen: Tap the menu (⋮) → "Manage Categories"
- From add expense screen: Tap the settings icon (⚙️) next to category dropdown

#### **Add New Category:**
- Tap the + button
- Enter category name
- Select an icon and color
- Tap "Add"

#### **Edit Category:**
- Tap the edit icon (✏️) on any category
- Modify name, icon, or color
- Tap "Update"

#### **Delete Category:**
- Tap the delete icon (🗑️)
- Confirm deletion
- All expenses using that category will be moved to "Other"

### 🔄 Database Migration:
The app automatically upgrades existing installations to support categories without losing any data!

## Project Structure

```
lib/
├── main.dart                      # Entry point
├── models/
│   ├── expense.dart               # Expense data model
│   ├── category.dart              # Category data model
│   ├── database_helper.dart       # SQLite database helper
│   └── web_database_helper.dart   # Web database helper
└── screens/
    ├── home_screen.dart               # Main expense list
    ├── add_expense_screen.dart        # Add new expense form
    ├── category_management_screen.dart # Category CRUD operations
    └── dashboard_screen.dart          # Expense statistics
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
