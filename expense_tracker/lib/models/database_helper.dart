import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'expense.dart';
import 'category.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        icon TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');
    
    // Insert default categories
    await _insertDefaultCategories(db);
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          icon TEXT NOT NULL,
          color TEXT NOT NULL
        )
      ''');
      await _insertDefaultCategories(db);
    }
  }
  
  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {'name': 'Food', 'icon': '🍔', 'color': 'FF4CAF50'},
      {'name': 'Transportation', 'icon': '🚗', 'color': 'FF2196F3'},
      {'name': 'Shopping', 'icon': '🛍️', 'color': 'FFE91E63'},
      {'name': 'Entertainment', 'icon': '🎬', 'color': 'FF9C27B0'},
      {'name': 'Bills', 'icon': '📄', 'color': 'FFFF5722'},
      {'name': 'Health', 'icon': '🏥', 'color': 'FFF44336'},
      {'name': 'Other', 'icon': '📦', 'color': 'FF607D8B'},
    ];
    
    for (var category in defaultCategories) {
      await db.insert('categories', category);
    }
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses',
    );
    return result[0]['total']?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getExpensesByCategory() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM expenses GROUP BY category',
    );
    
    Map<String, double> categoryTotals = {};
    for (var row in result) {
      categoryTotals[row['category']] = row['total']?.toDouble() ?? 0.0;
    }
    return categoryTotals;
  }
  
  // Category management methods
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }
  
  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      orderBy: 'name ASC',
    );
    
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
  
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
  
  Future<int> deleteCategory(int id) async {
    final db = await database;
    // First, update any expenses using this category to 'Other'
    final categories = await getAllCategories();
    final categoryToDelete = categories.firstWhere((cat) => cat.id == id);
    
    await db.update(
      'expenses',
      {'category': 'Other'},
      where: 'category = ?',
      whereArgs: [categoryToDelete.name],
    );
    
    // Then delete the category
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<bool> categoryExists(String name) async {
    final db = await database;
    final result = await db.query(
      'categories',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }
}
