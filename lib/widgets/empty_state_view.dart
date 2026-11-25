import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onClearFilter;

  const EmptyStateView({
    super.key,
    required this.isSearching,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearching ? Icons.search_off_rounded : Icons.task_alt_rounded,
                size: 40,
                color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearching ? 'No Matching Tasks' : 'All Clear for Now!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching with different keywords or reset filters.'
                  : 'You have completed everything or haven’t added any tasks yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
