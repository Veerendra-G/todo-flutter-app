import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_item.dart';
import 'priority_badge.dart';

class TodoTile extends StatelessWidget {
  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (difference == 1) {
      return 'Tomorrow, ${DateFormat('h:mm a').format(date)}';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference < -1) {
      return '${-difference}d overdue';
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white, size: 24),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom animated check button
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: InkWell(
                    onTap: onToggle,
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: todo.isDone
                            ? const Color(0xFF10B981)
                            : Colors.transparent,
                        border: Border.all(
                          color: todo.isDone
                              ? const Color(0xFF10B981)
                              : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                          width: 2,
                        ),
                      ),
                      child: todo.isDone
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),

                // Main Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.isDone
                              ? (isDark ? Colors.grey.shade500 : Colors.grey.shade400)
                              : (isDark ? Colors.white : Colors.grey.shade900),
                        ),
                      ),

                      // Optional Description
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Badges row: Category, Priority, Due Date
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? todo.category.color.withOpacity(0.15)
                                  : todo.category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  todo.category.icon,
                                  size: 12,
                                  color: todo.category.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  todo.category.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: todo.category.color,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Priority Badge
                          PriorityBadge(priority: todo.priority, compact: true),

                          // Due Date Badge
                          if (todo.dueDate != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: todo.isOverdue
                                    ? (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2))
                                    : (isDark ? const Color(0xFF334155) : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    todo.isOverdue
                                        ? Icons.error_outline_rounded
                                        : Icons.access_time_rounded,
                                    size: 12,
                                    color: todo.isOverdue
                                        ? const Color(0xFFEF4444)
                                        : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDueDate(todo.dueDate!),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: todo.isOverdue
                                          ? const Color(0xFFEF4444)
                                          : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow indicator for tapping to edit
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
