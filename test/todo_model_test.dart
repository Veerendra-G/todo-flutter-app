import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/todo_item.dart';
import 'package:todo_app/models/priority.dart';
import 'package:todo_app/models/category.dart';

void main() {
  group('TodoItem Model Tests', () {
    test('creates TodoItem with default values', () {
      final item = TodoItem(
        id: '1',
        title: 'Test Task',
      );

      expect(item.id, '1');
      expect(item.title, 'Test Task');
      expect(item.description, '');
      expect(item.isDone, false);
      expect(item.priority, Priority.medium);
      expect(item.category, TaskCategory.personal);
      expect(item.dueDate, isNull);
      expect(item.isOverdue, false);
    });

    test('isOverdue returns true for past due date when not done', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final item = TodoItem(
        id: '2',
        title: 'Overdue Task',
        dueDate: pastDate,
        isDone: false,
      );

      expect(item.isOverdue, true);
    });

    test('isOverdue returns false when task is already done', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final item = TodoItem(
        id: '3',
        title: 'Completed Overdue Task',
        dueDate: pastDate,
        isDone: true,
      );

      expect(item.isOverdue, false);
    });

    test('serialization toJson and fromJson works properly', () {
      final date = DateTime(2026, 12, 25, 10, 30);
      final original = TodoItem(
        id: '4',
        title: 'Holiday Shopping',
        description: 'Gifts for family',
        priority: Priority.high,
        category: TaskCategory.shopping,
        dueDate: date,
        isDone: true,
      );

      final json = original.toJson();
      final reconstituted = TodoItem.fromJson(json);

      expect(reconstituted.id, original.id);
      expect(reconstituted.title, original.title);
      expect(reconstituted.description, original.description);
      expect(reconstituted.priority, Priority.high);
      expect(reconstituted.category, TaskCategory.shopping);
      expect(reconstituted.isDone, true);
      expect(reconstituted.dueDate, date);
    });

    test('copyWith updates fields correctly', () {
      final item = TodoItem(
        id: '5',
        title: 'Original Title',
        priority: Priority.low,
      );

      final updated = item.copyWith(
        title: 'Updated Title',
        priority: Priority.high,
        isDone: true,
      );

      expect(updated.title, 'Updated Title');
      expect(updated.priority, Priority.high);
      expect(updated.isDone, true);
      expect(updated.id, item.id);
    });
  });
}
