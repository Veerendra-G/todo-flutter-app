import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/todo_provider.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: TaskCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = TaskCategory.values[index];
          final isSelected = provider.selectedCategory == cat;

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: Icon(
              cat.icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : cat.color),
            ),
            label: Text(
              cat.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
              ),
            ),
            backgroundColor: isDark
                ? const Color(0xFF1E293B)
                : Colors.white,
            selectedColor: cat.color,
            elevation: isSelected ? 2 : 0,
            shadowColor: cat.color.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            side: BorderSide(
              color: isSelected
                  ? cat.color
                  : (isDark ? const Color(0xFF334155) : Colors.grey.shade200),
              width: 1,
            ),
            onSelected: (_) => provider.setCategoryFilter(cat),
          );
        },
      ),
    );
  }
}
