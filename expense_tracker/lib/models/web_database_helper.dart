import 'dart:async';
import 'expense.dart';

class WebDatabaseHelper {
  static final WebDatabaseHelper _instance = WebDatabaseHelper._internal();
  factory WebDatabaseHelper() => _instance;
  WebDatabaseHelper._internal();

  List<Expense> _expenses = [];
  int _nextId = 1;

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
}
