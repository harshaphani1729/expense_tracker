import 'package:flutter/material.dart';
import 'package:expense_tracker/models/web_database_helper.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WebDatabaseHelper _dbHelper = WebDatabaseHelper();
  double _totalExpenses = 0.0;
  Map<String, double> _categoryExpenses = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final total = await _dbHelper.getTotalExpenses();
    final categories = await _dbHelper.getExpensesByCategory();
    
    setState(() {
      _totalExpenses = total;
      _categoryExpenses = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Expenses',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${_totalExpenses.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _categoryExpenses.isEmpty
                  ? const Center(child: Text('No expenses to show'))
                  : ListView.builder(
                      itemCount: _categoryExpenses.length,
                      itemBuilder: (context, index) {
                        final category = _categoryExpenses.keys.elementAt(index);
                        final amount = _categoryExpenses[category]!;
                        final percentage = _totalExpenses > 0 
                            ? (amount / _totalExpenses * 100) 
                            : 0.0;

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(category),
                              child: Text(
                                category[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(category),
                            subtitle: Text('${percentage.toStringAsFixed(1)}% of total'),
                            trailing: Text(
                              '₹${amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transportation':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
        return Colors.pink;
      case 'bills':
        return Colors.red;
      case 'health':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
