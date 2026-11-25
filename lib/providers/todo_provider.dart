import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/todo_item.dart';
import '../models/priority.dart';
import '../models/category.dart';

enum TodoFilterStatus { all, active, completed }

enum TodoSortBy { dueDate, priority, createdAt, alphabetical }

class TodoProvider with ChangeNotifier {
  static const String _storageKey = 'flutter_todos_cache_v1';
  final _uuid = const Uuid();

  List<TodoItem> _todos = [];
  bool _isLoading = true;

  // Filter & Search & Sort states
  String _searchQuery = '';
  TaskCategory _selectedCategory = TaskCategory.all;
  TodoFilterStatus _filterStatus = TodoFilterStatus.all;
  TodoSortBy _sortBy = TodoSortBy.createdAt;
  bool _sortAscending = false;

  // Getters
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TaskCategory get selectedCategory => _selectedCategory;
  TodoFilterStatus get filterStatus => _filterStatus;
  TodoSortBy get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  List<TodoItem> get allTodos => List.unmodifiable(_todos);

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isDone).length;
  int get activeCount => _todos.where((t) => !t.isDone).length;
  int get overdueCount => _todos.where((t) => t.isOverdue).length;

  double get completionProgress {
    if (_todos.isEmpty) return 0.0;
    return completedCount / totalCount;
  }

  // Filtered & Sorted Todos List
  List<TodoItem> get filteredTodos {
    var result = _todos.where((item) {
      // Status filter
      if (_filterStatus == TodoFilterStatus.active && item.isDone) return false;
      if (_filterStatus == TodoFilterStatus.completed && !item.isDone) return false;

      // Category filter
      if (_selectedCategory != TaskCategory.all && item.category != _selectedCategory) {
        return false;
      }

      // Search Query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesDesc = item.description.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc) return false;
      }

      return true;
    }).toList();

    // Sorting
    result.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case TodoSortBy.dueDate:
          if (a.dueDate == null && b.dueDate == null) {
            comparison = 0;
          } else if (a.dueDate == null) {
            comparison = 1;
          } else if (b.dueDate == null) {
            comparison = -1;
          } else {
            comparison = a.dueDate!.compareTo(b.dueDate!);
          }
          break;
        case TodoSortBy.priority:
          comparison = b.priority.level.compareTo(a.priority.level);
          break;
        case TodoSortBy.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case TodoSortBy.alphabetical:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
      }

      return _sortAscending ? comparison : -comparison;
    });

    return result;
  }

  TodoProvider() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        _todos = decoded.map((item) => TodoItem.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        // Initial friendly demo tasks
        _todos = _getInitialSampleTasks();
        await _saveToPreferences();
      }
    } catch (e) {
      debugPrint('Error loading todos: $e');
      _todos = _getInitialSampleTasks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_todos.map((t) => t.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  // Task Mutations
  Future<void> addTodo({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    TaskCategory category = TaskCategory.personal,
    DateTime? dueDate,
  }) async {
    final newItem = TodoItem(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      priority: priority,
      category: category,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );

    _todos.insert(0, newItem);
    notifyListeners();
    await _saveToPreferences();
  }

  Future<void> updateTodo(TodoItem updatedItem) async {
    final index = _todos.indexWhere((t) => t.id == updatedItem.id);
    if (index != -1) {
      _todos[index] = updatedItem;
      notifyListeners();
      await _saveToPreferences();
    }
  }

  Future<void> toggleTodoStatus(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = _todos[index];
      final newStatus = !current.isDone;
      _todos[index] = current.copyWith(
        isDone: newStatus,
        completedAt: newStatus ? DateTime.now() : null,
      );
      notifyListeners();
      await _saveToPreferences();
    }
  }

  // Delete & Undo support
  Future<int> deleteTodo(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos.removeAt(index);
      notifyListeners();
      await _saveToPreferences();
      return index;
    }
    return -1;
  }

  Future<void> insertTodoAt(int index, TodoItem item) async {
    if (index >= 0 && index <= _todos.length) {
      _todos.insert(index, item);
    } else {
      _todos.add(item);
    }
    notifyListeners();
    await _saveToPreferences();
  }

  Future<void> clearCompleted() async {
    _todos.removeWhere((item) => item.isDone);
    notifyListeners();
    await _saveToPreferences();
  }

  // Filtering & Sorting setters
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(TaskCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setFilterStatus(TodoFilterStatus status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setSortBy(TodoSortBy sortBy) {
    if (_sortBy == sortBy) {
      _sortAscending = !_sortAscending;
    } else {
      _sortBy = sortBy;
      _sortAscending = false;
    }
    notifyListeners();
  }

  List<TodoItem> _getInitialSampleTasks() {
    final now = DateTime.now();
    return [
      TodoItem(
        id: _uuid.v4(),
        title: 'Welcome to FlowDo! 👋',
        description: 'Tap on a task to edit it, or tap the checkmark to mark it done.',
        category: TaskCategory.personal,
        priority: Priority.high,
        dueDate: now.add(const Duration(hours: 4)),
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TodoItem(
        id: _uuid.v4(),
        title: 'Review Flutter Android Build 🚀',
        description: 'Verify project setup, build Gradle files, and AndroidManifest configuration.',
        category: TaskCategory.work,
        priority: Priority.high,
        dueDate: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      TodoItem(
        id: _uuid.v4(),
        title: 'Pick up groceries 🛒',
        description: 'Fresh vegetables, milk, coffee beans, and whole wheat bread.',
        category: TaskCategory.shopping,
        priority: Priority.medium,
        dueDate: now.add(const Duration(days: 2)),
        createdAt: now,
      ),
      TodoItem(
        id: _uuid.v4(),
        title: '30-minute cardio & stretch 🏃',
        description: 'Morning workout routine to stay energetic and healthy.',
        category: TaskCategory.health,
        priority: Priority.low,
        isDone: true,
        completedAt: now.subtract(const Duration(minutes: 30)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
