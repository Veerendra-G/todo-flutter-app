import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/stats_header.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/todo_tile.dart';
import '../widgets/empty_state_view.dart';
import 'add_edit_todo_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddTodo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddEditTodoScreen(),
      ),
    );
  }

  void _openEditTodo(BuildContext context, String id) {
    final provider = context.read<TodoProvider>();
    final todo = provider.allTodos.firstWhere((t) => t.id == id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditTodoScreen(todo: todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final todos = provider.filteredTodos;

    return Scaffold(
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.grey.shade900,
                ),
                onChanged: (val) => provider.setSearchQuery(val),
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('FlowDo'),
                ],
              ),
        actions: [
          IconButton(
            tooltip: _isSearchOpen ? 'Close Search' : 'Search Tasks',
            icon: Icon(_isSearchOpen ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                if (_isSearchOpen) {
                  _searchController.clear();
                  provider.setSearchQuery('');
                  _isSearchOpen = false;
                } else {
                  _isSearchOpen = true;
                }
              });
            },
          ),
          PopupMenuButton<TodoSortBy>(
            tooltip: 'Sort Options',
            icon: const Icon(Icons.sort_rounded),
            onSelected: (sortBy) => provider.setSortBy(sortBy),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: TodoSortBy.createdAt,
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Creation Date',
                      style: TextStyle(
                        fontWeight: provider.sortBy == TodoSortBy.createdAt
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TodoSortBy.dueDate,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Due Date',
                      style: TextStyle(
                        fontWeight: provider.sortBy == TodoSortBy.dueDate
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TodoSortBy.priority,
                child: Row(
                  children: [
                    const Icon(Icons.flag_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Priority',
                      style: TextStyle(
                        fontWeight: provider.sortBy == TodoSortBy.priority
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TodoSortBy.alphabetical,
                child: Row(
                  children: [
                    const Icon(Icons.sort_by_alpha_rounded, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Alphabetical',
                      style: TextStyle(
                        fontWeight: provider.sortBy == TodoSortBy.alphabetical
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'stats') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              } else if (value == 'clear_completed') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Completed Tasks?'),
                    content: const Text('This will permanently remove all finished tasks.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          provider.clearCompleted();
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Completed tasks cleared'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Statistics & Analytics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_completed',
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Clear Completed'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    // Stats Card at Top
                    const StatsHeader(),

                    // Category Horizontal Chips
                    const CategoryFilterBar(),
                    const SizedBox(height: 8),

                    // Status Filter Segment (All, Active, Completed)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildStatusTab(context, 'All (${provider.totalCount})', TodoFilterStatus.all),
                          const SizedBox(width: 8),
                          _buildStatusTab(context, 'Active (${provider.activeCount})', TodoFilterStatus.active),
                          const SizedBox(width: 8),
                          _buildStatusTab(context, 'Completed (${provider.completedCount})', TodoFilterStatus.completed),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Tasks List
                    Expanded(
                      child: todos.isEmpty
                          ? EmptyStateView(
                              isSearching: provider.searchQuery.isNotEmpty,
                              onClearFilter: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 4, bottom: 84),
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                final todo = todos[index];
                                return TodoTile(
                                  todo: todo,
                                  onToggle: () => provider.toggleTodoStatus(todo.id),
                                  onTap: () => _openEditTodo(context, todo.id),
                                  onDelete: () async {
                                    final deletedItem = todo;
                                    final deletedIndex = await provider.deleteTodo(todo.id);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Deleted "${deletedItem.title}"'),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          textColor: const Color(0xFF67E8F9),
                                          onPressed: () {
                                            provider.insertTodoAt(deletedIndex, deletedItem);
                                          },
                                        ),
                                        duration: const Duration(seconds: 4),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTodo(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildStatusTab(
    BuildContext context,
    String label,
    TodoFilterStatus status,
  ) {
    final provider = context.watch<TodoProvider>();
    final isSelected = provider.filterStatus == status;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => provider.setFilterStatus(status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : (isDark ? const Color(0xFF334155) : Colors.grey.shade200),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            ),
          ),
        ),
      ),
    );
  }
}
