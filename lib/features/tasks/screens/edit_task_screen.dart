import 'package:flutter/material.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});

  final TaskModel task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  static const _navy = Color(0xFF263D62);
  static const _cream = Color(0xFFF6F3E8);
  static const _muted = Color(0xFF71809A);

  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late DateTime _deadline;
  late TaskPriority _priority;
  late bool _reminderEnabled;
  String? _titleError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _categoryController = TextEditingController(text: widget.task.category);
    _deadline = widget.task.deadline;
    _priority = widget.task.priority;
    _reminderEnabled = widget.task.reminderEnabled;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDeadline =
        '${_deadline.month}/${_deadline.day}/${_deadline.year} · '
        '${_dueTime(_deadline)}';
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        title: const Text('Edit task'),
        foregroundColor: _navy,
        backgroundColor: _cream,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Task name',
                errorText: _titleError,
              ),
              onChanged: (_) {
                if (_titleError != null) setState(() => _titleError = null);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 18),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_month_outlined, color: _navy),
              title: const Text('Deadline'),
              subtitle: Text(
                formattedDeadline,
                style: const TextStyle(color: _muted),
              ),
              trailing: const Icon(Icons.chevron_right, color: _muted),
              onTap: _selectDeadline,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: const [
                DropdownMenuItem(value: TaskPriority.high, child: Text('High')),
                DropdownMenuItem(
                  value: TaskPriority.medium,
                  child: Text('Medium'),
                ),
                DropdownMenuItem(value: TaskPriority.low, child: Text('Low')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _priority = value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reminder'),
              value: _reminderEnabled,
              activeTrackColor: const Color(0xFF85C3A1),
              onChanged: (value) => setState(() => _reminderEnabled = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Save'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(_deadline.year, _deadline.month, _deadline.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline),
    );
    if (time == null || !mounted) return;
    setState(() {
      _deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Enter a task name.');
      return;
    }

    TaskService.instance.updateTask(
      widget.task,
      title: title,
      category: _categoryController.text.trim().isEmpty
          ? 'Personal'
          : _categoryController.text.trim(),
      deadline: _deadline,
      priority: _priority,
      reminderEnabled: _reminderEnabled,
    );
    Navigator.of(context).pop();
  }

  String _dueTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }
}
