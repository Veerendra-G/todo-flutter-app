import 'package:flutter/material.dart';
import '../models/priority.dart';

class PriorityBadge extends StatelessWidget {
  final Priority priority;
  final bool compact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: isDark ? priority.color.withOpacity(0.2) : priority.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: priority.color.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority.icon,
            size: compact ? 12 : 14,
            color: priority.color,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              priority.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: priority.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
