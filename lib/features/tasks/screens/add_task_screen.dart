import 'package:flutter/material.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/models/task_model.dart';
import 'package:task_mate/features/calendar/screens/calendar_screen.dart';
import 'package:task_mate/features/home/screens/home_screen.dart';
import 'package:task_mate/features/profile/screens/profile_screen.dart';
import 'package:task_mate/features/tasks/screens/task_list_screen.dart';
import 'package:task_mate/shared/widgets/bottom_navigation.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static const _navy = Color(0xFF2C415E);
  static const _cream = Color(0xFFF7F1E6);
  static const _muted = Color(0xFF78859A);
  static const _line = Color(0xFFD9D0C5);
  static const _blue = Color(0xFF73A9D6);
  static const _green = Color(0xFF8DBA9A);
  static const _card = Colors.white;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = const [
    'Academic',
    'Project',
    'Meeting',
    'Presentation',
    'Personal',
    'Quiz',
    'Examination',
  ];

  final List<String> _subtasks = ['Draft introduction'];

  String _selectedCategory = 'Academic';
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 1));
  String _selectedPriority = 'Medium';
  bool _reminderEnabled = true;
  bool _isSaving = false;
  String? _titleError;
  String? _deadlineError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Add Task',
                            style: TextStyle(
                              color: _navy,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(Icons.close, color: _navy, size: 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Turn a big assignment into small steps',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('Title'),
                    _buildTextField(
                      controller: _titleController,
                      hintText: 'e.g. Finish lab report',
                      prefixIcon: Icons.edit_outlined,
                      errorText: _titleError,
                      onChanged: (_) {
                        if (_titleError != null) {
                          setState(() => _titleError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildFieldLabel('Description'),
                    _buildTextField(
                      controller: _descriptionController,
                      hintText: 'Add helpful notes, links or requirements...',
                      minLines: 2,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Category'),
                              _buildDropdown(
                                value: _selectedCategory,
                                items: _categories,
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() => _selectedCategory = value);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Deadline'),
                              GestureDetector(
                                onTap: _pickDeadline,
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _card,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _deadlineError == null
                                          ? _line.withAlpha(180)
                                          : const Color(0xFFE77968),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _formatDeadline(_selectedDeadline),
                                          style: TextStyle(
                                            color: _navy,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color: _navy,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_deadlineError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _deadlineError!,
                                    style: const TextStyle(
                                      color: Color(0xFFE77968),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('Priority'),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedPriority = 'Low'),
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _selectedPriority == 'Low'
                                    ? Colors.white
                                    : const Color(0xFFE9E1D5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedPriority == 'Low'
                                      ? _line
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                'Low',
                                style: TextStyle(
                                  color: _selectedPriority == 'Low'
                                      ? _navy
                                      : _muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedPriority = 'Medium'),
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _selectedPriority == 'Medium'
                                    ? _blue
                                    : const Color(0xFFE9E1D5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Medium',
                                style: TextStyle(
                                  color: _selectedPriority == 'Medium'
                                      ? Colors.white
                                      : _navy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedPriority = 'High'),
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _selectedPriority == 'High'
                                    ? Colors.white
                                    : const Color(0xFFE9E1D5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedPriority == 'High'
                                      ? const Color(0xFFE8B8B1)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                'High',
                                style: TextStyle(
                                  color: _selectedPriority == 'High'
                                      ? const Color(0xFFE56B5C)
                                      : _muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm_outlined,
                          color: _navy,
                          size: 25,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Reminder',
                            style: TextStyle(
                              color: _navy,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '1 day before • 5:00 PM',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: _reminderEnabled,
                          onChanged: (value) =>
                              setState(() => _reminderEnabled = value),
                          activeThumbColor: _green,
                          activeTrackColor: _green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFD9D9D9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtasks',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addSubtask,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add subtask'),
                          style: TextButton.styleFrom(
                            foregroundColor: _blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._subtasks.asMap().entries.map(
                      (entry) => Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _line.withAlpha(180)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.drag_indicator_rounded,
                                color: _muted,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    color: _navy,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Add subtask',
                                onPressed: _addSubtask,
                                icon: const Icon(
                                  Icons.add,
                                  color: _blue,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _createTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSaving ? 'Creating...' : 'Create Task',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.check, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: BottomNavigation(selectedIndex: 2, onTap: _handleNavigation),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: _navy,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final localContext = context;
    if (!localContext.mounted) return;

    final date = await showDatePicker(
      context: localContext,
      initialDate: _selectedDeadline,
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      helpText: 'Select deadline date',
    );
    if (!localContext.mounted || date == null) return;

    final time = await showTimePicker(
      context: localContext,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
      helpText: 'Select deadline time',
    );
    if (!localContext.mounted) return;

    if (time != null) {
      setState(() {
        _selectedDeadline = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _deadlineError = null;
      });
      return;
    }

    setState(() {
      _selectedDeadline = DateTime(date.year, date.month, date.day);
      _deadlineError = null;
    });
  }

  String _formatDeadline(DateTime dateTime) {
    final month = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][dateTime.month - 1];
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final hour12 = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    return '$month ${dateTime.day} • $hour12:$minute $period';
  }

  Future<void> _addSubtask() async {
    final controller = TextEditingController();
    final subtask = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _card,
        title: const Text(
          'Add subtask',
          style: TextStyle(color: _navy, fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Enter a subtask',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            final text = value.trim();
            if (text.isNotEmpty) Navigator.of(dialogContext).pop(text);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) Navigator.of(dialogContext).pop(text);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || subtask == null || subtask.isEmpty) return;
    setState(() => _subtasks.add(subtask));
  }

  Future<void> _createTask() async {
    if (_isSaving) return;

    final title = _titleController.text.trim();
    final isDeadlinePast = !_selectedDeadline.isAfter(DateTime.now());
    setState(() {
      _titleError = title.isEmpty ? 'Enter a task title.' : null;
      _deadlineError = isDeadlinePast ? 'Choose a future deadline.' : null;
    });
    if (title.isEmpty || isDeadlinePast) return;

    setState(() => _isSaving = true);
    TaskService.instance.addTask(
      TaskModel(
        title: title,
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        deadline: _selectedDeadline,
        priority: switch (_selectedPriority) {
          'High' => TaskPriority.high,
          'Low' => TaskPriority.low,
          _ => TaskPriority.medium,
        },
        reminderEnabled: _reminderEnabled,
        subtasks: List<String>.of(_subtasks),
      ),
    );

    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const TaskListScreen()),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    int minLines = 1,
    int maxLines = 1,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line.withAlpha(180)),
      ),
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
        style: const TextStyle(color: Color(0xFF2E415D), fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: _muted, fontSize: 14),
          errorText: errorText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: _muted, size: 18)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line.withAlpha(180)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _navy),
          style: TextStyle(
            color: _navy,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
      return;
    }

    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const TaskListScreen()),
      );
      return;
    }

    if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CalendarScreen()),
      );
      return;
    }

    if (index == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
      );
    }
  }
}
