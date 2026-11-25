import 'package:flutter/material.dart';

enum TaskCategory {
  all,
  work,
  personal,
  shopping,
  health,
  study,
  home,
  other;

  String get label {
    switch (this) {
      case TaskCategory.all:
        return 'All';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.study:
        return 'Study';
      case TaskCategory.home:
        return 'Home';
      case TaskCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.all:
        return Icons.dashboard_outlined;
      case TaskCategory.work:
        return Icons.work_outline_rounded;
      case TaskCategory.personal:
        return Icons.person_outline_rounded;
      case TaskCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TaskCategory.health:
        return Icons.favorite_outline_rounded;
      case TaskCategory.study:
        return Icons.menu_book_rounded;
      case TaskCategory.home:
        return Icons.home_outlined;
      case TaskCategory.other:
        return Icons.bookmark_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.all:
        return const Color(0xFF6366F1);
      case TaskCategory.work:
        return const Color(0xFF3B82F6);
      case TaskCategory.personal:
        return const Color(0xFF8B5CF6);
      case TaskCategory.shopping:
        return const Color(0xFFEC4899);
      case TaskCategory.health:
        return const Color(0xFF10B981);
      case TaskCategory.study:
        return const Color(0xFFF97316);
      case TaskCategory.home:
        return const Color(0xFF14B8A6);
      case TaskCategory.other:
        return const Color(0xFF64748B);
    }
  }

  static TaskCategory fromString(String? value) {
    if (value == null) return TaskCategory.personal;
    return TaskCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TaskCategory.personal,
    );
  }
}
