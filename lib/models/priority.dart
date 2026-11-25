import 'package:flutter/material.dart';

enum Priority {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case Priority.low:
        return const Color(0xFF10B981); // Emerald Green
      case Priority.medium:
        return const Color(0xFFF59E0B); // Amber / Orange
      case Priority.high:
        return const Color(0xFFEF4444); // Red / Coral
    }
  }

  Color get backgroundColor {
    switch (this) {
      case Priority.low:
        return const Color(0xFFD1FAE5);
      case Priority.medium:
        return const Color(0xFFFEF3C7);
      case Priority.high:
        return const Color(0xFFFEE2E2);
    }
  }

  IconData get icon {
    switch (this) {
      case Priority.low:
        return Icons.arrow_downward_rounded;
      case Priority.medium:
        return Icons.horizontal_rule_rounded;
      case Priority.high:
        return Icons.arrow_upward_rounded;
    }
  }

  int get level {
    switch (this) {
      case Priority.low:
        return 1;
      case Priority.medium:
        return 2;
      case Priority.high:
        return 3;
    }
  }

  static Priority fromString(String? value) {
    if (value == null) return Priority.medium;
    return Priority.values.firstWhere(
      (p) => p.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Priority.medium,
    );
  }
}
