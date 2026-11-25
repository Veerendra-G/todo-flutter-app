import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/todo_item.dart';
import '../models/priority.dart';
import '../models/category.dart';
import '../providers/todo_provider.dart';

class AddEditTodoScreen extends StatefulWidget {
  final TodoItem? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  late Priority _selectedPriority;
  late TaskCategory _selectedCategory;
  DateTime? _selectedDueDate;

  bool get isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descController = TextEditingController(text: widget.todo?.description ?? '');
    _selectedPriority = widget.todo?.priority ?? Priority.medium;
    _selectedCategory = widget.todo?.category ?? TaskCategory.personal;
    _selectedDueDate = widget.todo?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDueDate ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null && mounted) {
      final initialTime = _selectedDueDate != null
          ? TimeOfDay(hour: _selectedDueDate!.hour, minute: _selectedDueDate!.minute)
          : const TimeOfDay(hour: 12, minute: 0);

      final pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      } else {
        setState(() {
          _selectedDueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            23,
            59,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TodoProvider>();

    if (isEditing) {
      final updated = widget.todo!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDueDate,
        clearDueDate: _selectedDueDate == null,
      );
      provider.updateTodo(updated);
    } else {
      provider.addTodo(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDueDate,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              tooltip: 'Delete Task',
              onPressed: () {
                context.read<TodoProvider>().deleteTodo(widget.todo!.id);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              Text(
                'Task Title *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                autofocus: !isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. Complete Flutter presentation',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description Field
              Text(
                'Notes & Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Add details, subtasks, or links...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Priority Section
              Text(
                'Priority',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: Priority.values.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? priority.color
                                : (isDark ? const Color(0xFF1E293B) : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? priority.color
                                  : (isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                priority.icon,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : priority.color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                priority.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.grey.shade200 : Colors.grey.shade800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Category Selector
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TaskCategory.values
                    .where((c) => c != TaskCategory.all)
                    .map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    avatar: Icon(
                      category.icon,
                      size: 16,
                      color: isSelected ? Colors.white : category.color,
                    ),
                    label: Text(category.label),
                    selected: isSelected,
                    selectedColor: category.color,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.grey.shade200 : Colors.grey.shade800),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Due Date & Time Picker
              Text(
                'Due Date & Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDueDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDueDate == null
                              ? 'No deadline set'
                              : DateFormat('EEE, MMM d, yyyy - h:mm a').format(_selectedDueDate!),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _selectedDueDate == null
                                ? (isDark ? Colors.grey.shade500 : Colors.grey.shade400)
                                : (isDark ? Colors.white : Colors.grey.shade900),
                          ),
                        ),
                      ),
                      if (_selectedDueDate != null)
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            setState(() {
                              _selectedDueDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Save Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _saveTask,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Create Task',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
}
}
