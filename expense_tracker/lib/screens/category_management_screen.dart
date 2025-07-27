import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/database_helper.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    
    final categories = await _databaseHelper.getAllCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  void _showAddEditCategoryDialog({Category? category}) {
    final _nameController = TextEditingController(text: category?.name ?? '');
    String _selectedIcon = category?.icon ?? '📦';
    String _selectedColor = category?.color ?? 'FF607D8B';
    
    final List<String> _availableIcons = [
      '🍔', '🚗', '🛍️', '🎬', '📄', '🏥', '📦', '💰', '🎓', '✈️',
      '🏠', '⚽', '🎵', '📱', '💻', '🎮', '📚', '☕', '🍕', '🚌'
    ];
    
    final List<Map<String, dynamic>> _availableColors = [
      {'name': 'Green', 'value': 'FF4CAF50'},
      {'name': 'Blue', 'value': 'FF2196F3'},
      {'name': 'Pink', 'value': 'FFE91E63'},
      {'name': 'Purple', 'value': 'FF9C27B0'},
      {'name': 'Orange', 'value': 'FFFF5722'},
      {'name': 'Red', 'value': 'FFF44336'},
      {'name': 'Teal', 'value': 'FF009688'},
      {'name': 'Indigo', 'value': 'FF3F51B5'},
      {'name': 'Brown', 'value': 'FF795548'},
      {'name': 'Grey', 'value': 'FF607D8B'},
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Select Icon:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                    ),
                    itemCount: _availableIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _availableIcons[index];
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            _selectedIcon = icon;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedIcon == icon 
                                  ? Colors.blue 
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Select Color:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                    ),
                    itemCount: _availableColors.length,
                    itemBuilder: (context, index) {
                      final colorInfo = _availableColors[index];
                      final colorValue = colorInfo['value'] as String;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            _selectedColor = colorValue;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(int.parse('0x$colorValue')),
                            border: Border.all(
                              color: _selectedColor == colorValue 
                                  ? Colors.black 
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a category name')),
                  );
                  return;
                }
                
                final name = _nameController.text.trim();
                
                // Check if category name already exists (for new categories or name changes)
                if (category == null || category.name != name) {
                  final exists = await _databaseHelper.categoryExists(name);
                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category name already exists')),
                    );
                    return;
                  }
                }
                
                final newCategory = Category(
                  id: category?.id,
                  name: name,
                  icon: _selectedIcon,
                  color: _selectedColor,
                );
                
                try {
                  if (category == null) {
                    await _databaseHelper.insertCategory(newCategory);
                  } else {
                    await _databaseHelper.updateCategory(newCategory);
                  }
                  
                  Navigator.pop(context);
                  _loadCategories();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(category == null 
                          ? 'Category added successfully' 
                          : 'Category updated successfully'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text(category == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?\n\nAny expenses using this category will be moved to "Other".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _databaseHelper.deleteCategory(category.id!);
                Navigator.pop(context);
                _loadCategories();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category deleted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(
                  child: Text(
                    'No categories found.\nTap + to add a category.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse('0x${category.color}')),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              category.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        title: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAddEditCategoryDialog(category: category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCategory(category),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
