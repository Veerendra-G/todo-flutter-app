import 'priority.dart';
import 'category.dart';

class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final Priority priority;
  final TaskCategory category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;

  TodoItem({
    required this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
    this.priority = Priority.medium,
    this.category = TaskCategory.personal,
    this.dueDate,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isOverdue {
    if (isDone || dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    Priority? priority,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
    bool clearDueDate = false,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'priority': priority.name,
      'category': category.name,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      isDone: (json['isDone'] as bool?) ?? false,
      priority: Priority.fromString(json['priority'] as String?),
      category: TaskCategory.fromString(json['category'] as String?),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }
}
