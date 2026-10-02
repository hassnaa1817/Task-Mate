import 'package:flutter/material.dart';
import 'package:task_mate/core/utils/date_utils.dart';
import 'package:task_mate/features/tasks/screens/edit_task_screen.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/features/tasks/widgets/deadline_countdown.dart';
import 'package:task_mate/models/task_model.dart';
import 'package:task_mate/shared/widgets/bottom_navigation.dart';

class TaskDetailResult {
  const TaskDetailResult({
    required this.title,
    required this.category,
    required this.isCompleted,
    required this.reminderEnabled,
    required this.subtasks,
    required this.completedSubtasks,
    this.isDeleted = false,
    this.navigationIndex,
  });

  final String title;
  final String category;
  final bool isCompleted;
  final bool reminderEnabled;
  final List<String> subtasks;
  final List<bool> completedSubtasks;
  final bool isDeleted;
  final int? navigationIndex;
}

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  static const _navy = Color(0xFF263D62);
  static const _cream = Color(0xFFF6F3E8);
  static const _muted = Color(0xFF71809A);
  static const _blue = Color(0xFF73A9D6);
  static const _green = Color(0xFF85C3A1);
  static const _coral = Color(0xFFEF806D);
  static const _card = Colors.white;

  late String _title;
  late String _category;
  late bool _isCompleted;
  late bool _reminderEnabled;
  late List<String> _subtasks;
  late List<bool> _completedSubtasks;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = task.title;
    _category = task.category;
    _isCompleted = task.isCompleted;
    _reminderEnabled = task.reminderEnabled;
    _subtasks = List<String>.of(task.subtasks);
    _completedSubtasks = List<bool>.of(task.completedSubtasks);
    while (_completedSubtasks.length < _subtasks.length) {
      _completedSubtasks.add(false);
    }
    if (_completedSubtasks.length > _subtasks.length) {
      _completedSubtasks = _completedSubtasks.take(_subtasks.length).toList();
    }
    TaskService.instance.addListener(_handleTaskChanged);
  }

  @override
  void dispose() {
    TaskService.instance.removeListener(_handleTaskChanged);
    super.dispose();
  }

  void _handleTaskChanged() {
    if (!mounted) return;
    setState(() {
      _title = widget.task.title;
      _category = widget.task.category;
      _isCompleted = widget.task.isCompleted;
      _reminderEnabled = widget.task.reminderEnabled;
      _subtasks = List<String>.of(widget.task.subtasks);
      _completedSubtasks = List<bool>.of(widget.task.completedSubtasks);
    });
  }

  double get _progress {
    if (_subtasks.isEmpty) return widget.task.progress;
    return _completedSubtasks.where((done) => done).length / _subtasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _completedSubtasks.where((done) => done).length;
    final progressPercent = (_progress * 100).round();

    return PopScope<TaskDetailResult>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _close();
      },
      child: Scaffold(
        backgroundColor: _cream,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTaskSummary(),
                      const SizedBox(height: 12),
                      _buildProgress(progressPercent),
                      const SizedBox(height: 10),
                      _buildSubtasksHeader(completedCount),
                      const SizedBox(height: 8),
                      if (_subtasks.isEmpty)
                        _buildNoSubtasks()
                      else
                        _buildSubtaskList(),
                      const SizedBox(height: 10),
                      _buildReminder(),
                      const SizedBox(height: 10),
                      _buildSecondaryActions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(18, 0, 18, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 6),
                child: _buildCompleteButton(),
              ),
              BottomNavigation(selectedIndex: 1, onTap: _handleNavigation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          const SizedBox(width: 20),
          _roundAction(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            onPressed: _close,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Task Details',
                style: TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          _roundAction(
            icon: Icons.more_horiz_rounded,
            label: 'More options',
            onPressed: _showTaskOptions,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _roundAction({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: _card,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(icon, color: _navy, size: 20),
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildTaskSummary() {
    final priorityColor = _priorityColor;
    final categoryLabel = _category.isEmpty ? 'Personal' : _category;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F1C2E),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${_priorityLabel.toUpperCase()} PRIORITY',
              style: TextStyle(
                color: priorityColor,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            _title,
            style: const TextStyle(
              color: _navy,
              fontSize: 20,
              height: 1.08,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            categoryLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _description,
            style: const TextStyle(color: _muted, fontSize: 9, height: 1.35),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: _blue, size: 14),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deadline',
                      style: TextStyle(color: _muted, fontSize: 8),
                    ),
                    Text(
                      '$_dueDayLabel · ${widget.task.dueTime}',
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.timer_outlined, color: _coral, size: 14),
              const SizedBox(width: 5),
              DeadlineCountdown(
                deadline: widget.task.deadline,
                isCompleted: _isCompleted,
                showOverdueBadge: true,
                fontSize: 9,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _description {
    if (widget.task.priority == TaskPriority.high) {
      return 'Build a clear argument and source map for the cognitive bias research paper.';
    }
    return 'Make steady progress and keep all the details for this task in one place.';
  }

  Color get _priorityColor {
    switch (widget.task.priority) {
      case TaskPriority.high:
        return _coral;
      case TaskPriority.low:
        return const Color(0xFF72AD8C);
      case TaskPriority.medium:
        return _blue;
    }
  }

  String get _priorityLabel => switch (widget.task.priority) {
    TaskPriority.high => 'High',
    TaskPriority.medium => 'Medium',
    TaskPriority.low => 'Low',
  };

  String get _dueDayLabel {
    final deadline = widget.task.deadline;
    final now = DateTime.now();
    if (TaskDateUtils.isSameCalendarDate(deadline, now)) return 'Today';
    if (TaskDateUtils.isSameCalendarDate(
      deadline,
      now.add(const Duration(days: 1)),
    )) {
      return 'Tomorrow';
    }
    return '${deadline.month}/${deadline.day}/${deadline.year}';
  }

  Widget _buildProgress(int progressPercent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0E6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  color: _navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '$progressPercent%',
                style: const TextStyle(
                  color: _green,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: _progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: const Color(0xFFD6D9D0),
              valueColor: const AlwaysStoppedAnimation(_green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksHeader(int completedCount) {
    return Row(
      children: [
        const Text(
          'Subtasks',
          style: TextStyle(
            color: _navy,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Text(
          '$completedCount of ${_subtasks.length}',
          style: const TextStyle(
            color: _blue,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        IconButton(
          tooltip: 'Add subtask',
          onPressed: _addSubtask,
          icon: const Icon(Icons.add_circle_outline, color: _blue, size: 19),
          constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSubtaskList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _subtasks.length,
      onReorderItem: (oldIndex, newIndex) {
        setState(() {
          final title = _subtasks.removeAt(oldIndex);
          final completed = _completedSubtasks.removeAt(oldIndex);
          _subtasks.insert(newIndex, title);
          _completedSubtasks.insert(newIndex, completed);
        });
        TaskService.instance.updateTask(
          widget.task,
          subtasks: _subtasks,
          completedSubtasks: _completedSubtasks,
        );
      },
      itemBuilder: (context, index) => Padding(
        key: ValueKey('subtask-$index-${_subtasks[index]}'),
        padding: const EdgeInsets.only(bottom: 6),
        child: _buildSubtaskRow(index),
      ),
    );
  }

  Widget _buildSubtaskRow(int index) {
    final complete = _completedSubtasks[index];
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          GestureDetector(
            key: ValueKey('subtask-toggle-${_subtasks[index]}'),
            onTap: () {
              final completed = !_completedSubtasks[index];
              setState(() => _completedSubtasks[index] = completed);
              TaskService.instance.toggleSubtask(
                widget.task,
                index,
                completed,
              );
            },
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: complete ? _green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: complete ? _green : const Color(0xFFD7D6CF),
                  width: 1.2,
                ),
              ),
              child: complete
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _subtasks[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _navy,
                fontSize: 9,
                decoration: complete ? TextDecoration.lineThrough : null,
                decorationColor: _muted,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Remove ${_subtasks[index]}',
            onPressed: () {
              setState(() {
                _subtasks.removeAt(index);
                _completedSubtasks.removeAt(index);
              });
              TaskService.instance.updateTask(
                widget.task,
                subtasks: _subtasks,
                completedSubtasks: _completedSubtasks,
              );
            },
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Color(0xFFD2D1C9),
              size: 16,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 25, height: 25),
          ),
          ReorderableDragStartListener(
            index: index,
            child: const SizedBox(
              width: 18,
              child: Icon(
                Icons.drag_indicator,
                color: Color(0xFFD2D1C9),
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubtasks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'No subtasks yet. Add one to break this task into steps.',
        style: TextStyle(color: _muted, fontSize: 10),
      ),
    );
  }

  Widget _buildReminder() {
    return Material(
      color: const Color(0xFFF9E1DC),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          TaskService.instance.toggleReminder(widget.task);
          setState(() => _reminderEnabled = widget.task.reminderEnabled);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 8, 9, 8),
          child: Row(
            children: [
              Icon(
                _reminderEnabled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                color: _reminderEnabled ? _coral : _muted,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _reminderEnabled ? 'Reminder set' : 'Reminder off',
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _reminderEnabled ? 'Today at 2:00 PM' : 'Tap to enable',
                      style: const TextStyle(color: _muted, fontSize: 8),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _coral, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: 'Edit',
            icon: Icons.edit_outlined,
            color: _blue,
            background: const Color(0xFFDFEDF8),
            onPressed: _editTask,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _actionButton(
            label: 'Delete',
            icon: Icons.delete_outline,
            color: _coral,
            background: const Color(0xFFF9E1DC),
            onPressed: _confirmDelete,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 36,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 10)),
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: color,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: FilledButton.icon(
        onPressed: _toggleCompletion,
        icon: Icon(
          _isCompleted ? Icons.undo_rounded : Icons.check_circle_outline,
          size: 16,
        ),
        label: Text(
          _isCompleted ? 'Mark as active' : 'Mark Complete',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  void _toggleCompletion() {
    TaskService.instance.setCompleted(widget.task, !_isCompleted);
    setState(() => _isCompleted = widget.task.isCompleted);
    _close();
  }

  Future<void> _showTaskOptions() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: _blue),
              title: const Text('Edit task'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: _coral),
              title: const Text('Delete task'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'edit') {
      _editTask();
    } else if (action == 'delete') {
      _confirmDelete();
    }
  }

  Future<void> _editTask() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => EditTaskScreen(task: widget.task),
      ),
    );
  }

  Future<void> _addSubtask() async {
    var subtaskValue = '';
    var validationMessage = '';
    final subtask = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _card,
          title: const Text(
            'Add subtask',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) => subtaskValue = value,
                decoration: const InputDecoration(
                  labelText: 'Subtask',
                  border: OutlineInputBorder(),
                ),
              ),
              if (validationMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      validationMessage,
                      style: const TextStyle(color: _coral, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (subtaskValue.trim().isEmpty) {
                  setDialogState(() => validationMessage = 'Enter a subtask.');
                  return;
                }
                Navigator.pop(dialogContext, subtaskValue.trim());
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
    if (subtask == null || !mounted) return;
    setState(() {
      _subtasks.add(subtask);
      _completedSubtasks.add(false);
    });
    TaskService.instance.updateTask(
      widget.task,
      subtasks: _subtasks,
      completedSubtasks: _completedSubtasks,
    );
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _card,
        title: const Text('Delete task?'),
        content: const Text('This task will be removed from your task list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _coral),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true && mounted) {
      TaskService.instance.deleteTask(widget.task);
      _close(isDeleted: true);
    }
  }

  TaskDetailResult _result({bool isDeleted = false, int? navigationIndex}) {
    return TaskDetailResult(
      title: _title,
      category: _category,
      isCompleted: _isCompleted,
      reminderEnabled: _reminderEnabled,
      subtasks: List<String>.of(_subtasks),
      completedSubtasks: List<bool>.of(_completedSubtasks),
      isDeleted: isDeleted,
      navigationIndex: navigationIndex,
    );
  }

  void _close({bool isDeleted = false, int? navigationIndex}) {
    Navigator.of(context)
        .pop(_result(isDeleted: isDeleted, navigationIndex: navigationIndex));
  }

  void _handleNavigation(int index) {
    _close(navigationIndex: index);
  }
}
