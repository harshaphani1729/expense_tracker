import 'dart:async';
import 'expense.dart';
import 'category.dart';

class WebDatabaseHelper {
  static final WebDatabaseHelper _instance = WebDatabaseHelper._internal();
  factory WebDatabaseHelper() => _instance;
  WebDatabaseHelper._internal();

  List<Expense> _expenses = [];
  List<Category> _categories = [];
  int _nextId = 1;
  int _nextCategoryId = 1;
  bool _categoriesInitialized = false;

  Future<int> insertExpense(Expense expense) async {
    final newExpense = expense.copyWith(id: _nextId);
    _expenses.add(newExpense);
    _nextId++;
    return newExpense.id!;
  }

  Future<List<Expense>> getAllExpenses() async {
    // Sort by date descending
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    return List.from(_expenses);
  }

  Future<int> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      return 1;
    }
    return 0;
  }

  Future<int> deleteExpense(int id) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses.removeAt(index);
      return 1;
    }
    return 0;
  }

  Future<double> getTotalExpenses() async {
    return _expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<Map<String, double>> getExpensesByCategory() async {
    Map<String, double> categoryTotals = {};
    for (var expense in _expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0.0) + expense.amount;
    }
    return categoryTotals;
  }
  
  void _initializeDefaultCategories() {
    if (!_categoriesInitialized) {
      _categories = [
        Category(id: _nextCategoryId++, name: 'Food', icon: '🍔', color: 'FF4CAF50'),
        Category(id: _nextCategoryId++, name: 'Transportation', icon: '🚗', color: 'FF2196F3'),
        Category(id: _nextCategoryId++, name: 'Shopping', icon: '🛍️', color: 'FFE91E63'),
        Category(id: _nextCategoryId++, name: 'Entertainment', icon: '🎬', color: 'FF9C27B0'),
        Category(id: _nextCategoryId++, name: 'Bills', icon: '📄', color: 'FFFF5722'),
        Category(id: _nextCategoryId++, name: 'Health', icon: '🏥', color: 'FFF44336'),
        Category(id: _nextCategoryId++, name: 'Other', icon: '📦', color: 'FF607D8B'),
      ];
      _categoriesInitialized = true;
    }
  }
  
  // Category management methods
  Future<int> insertCategory(Category category) async {
    _initializeDefaultCategories();
    final newCategory = category.copyWith(id: _nextCategoryId);
    _categories.add(newCategory);
    _nextCategoryId++;
    return newCategory.id!;
  }
  
  Future<List<Category>> getAllCategories() async {
    _initializeDefaultCategories();
    _categories.sort((a, b) => a.name.compareTo(b.name));
    return List.from(_categories);
  }
  
  Future<int> updateCategory(Category category) async {
    _initializeDefaultCategories();
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      final oldCategoryName = _categories[index].name;
      _categories[index] = category;
      
      // Update expenses that use this category
      if (oldCategoryName != category.name) {
        for (int i = 0; i < _expenses.length; i++) {
          if (_expenses[i].category == oldCategoryName) {
            _expenses[i] = _expenses[i].copyWith(category: category.name);
          }
        }
      }
      return 1;
    }
    return 0;
  }
  
  Future<int> deleteCategory(int id) async {
    _initializeDefaultCategories();
    final index = _categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      final categoryToDelete = _categories[index];
      
      // Update expenses using this category to 'Other'
      for (int i = 0; i < _expenses.length; i++) {
        if (_expenses[i].category == categoryToDelete.name) {
          _expenses[i] = _expenses[i].copyWith(category: 'Other');
        }
      }
      
      _categories.removeAt(index);
      return 1;
    }
    return 0;
  }
  
  Future<bool> categoryExists(String name) async {
    _initializeDefaultCategories();
    return _categories.any((category) => category.name.toLowerCase() == name.toLowerCase());
  }
}
