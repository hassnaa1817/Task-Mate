import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_mate/core/utils/date_utils.dart';
import 'package:task_mate/features/calendar/screens/calendar_screen.dart';
import 'package:task_mate/features/home/screens/home_screen.dart';
import 'package:task_mate/features/profile/screens/profile_screen.dart';
import 'package:task_mate/features/tasks/screens/add_task_screen.dart';
import 'package:task_mate/features/tasks/screens/task_detail_screen.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/features/tasks/widgets/task_card.dart';
import 'package:task_mate/models/task_model.dart';
import 'package:task_mate/shared/widgets/bottom_navigation.dart';

enum _TaskFilter { all, today, upcoming, completed }

enum _TaskSort { newest, deadline, priority, title }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, this.showAddTaskOnStart = false});

  final bool showAddTaskOnStart;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  static const _navy = Color(0xFF263D62);
  static const _cream = Color(0xFFF6F3E8);
  static const _muted = Color(0xFF71809A);
  static const _blue = Color(0xFF73A9D6);
  static const _card = Colors.white;

  final _newTaskController = TextEditingController();
  final _newCategoryController = TextEditingController();
  TaskService get _taskService => TaskService.instance;
  List<TaskModel> get _tasks => _taskService.tasks;
  Timer? _clockTimer;

  _TaskFilter _selectedFilter = _TaskFilter.all;
  _TaskSort _selectedSort = _TaskSort.newest;

  @override
  void initState() {
    super.initState();
    _taskService.addListener(_handleTasksChanged);
    _clockTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _handleTasksChanged(),
    );
    if (widget.showAddTaskOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showAddTaskDialog();
      });
    }
  }

  @override
  void dispose() {
    _taskService.removeListener(_handleTasksChanged);
    _clockTimer?.cancel();
    _newTaskController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _handleTasksChanged() {
    if (mounted) setState(() {});
  }

  List<TaskModel> get _visibleTasks {
    final tasks = _tasks.where((task) {
      switch (_selectedFilter) {
        case _TaskFilter.all:
          return !task.isCompleted;
        case _TaskFilter.today:
          return !task.isCompleted &&
              TaskDateUtils.isSameCalendarDate(task.deadline, DateTime.now());
        case _TaskFilter.upcoming:
          return !task.isCompleted && task.deadline.isAfter(DateTime.now());
        case _TaskFilter.completed:
          return task.isCompleted;
      }
    }).toList();

    switch (_selectedSort) {
      case _TaskSort.newest:
        tasks.sort(
          (first, second) => second.createdAt.compareTo(first.createdAt),
        );
      case _TaskSort.deadline:
        tasks.sort(
          (first, second) => first.deadline.compareTo(second.deadline),
        );
      case _TaskSort.priority:
        tasks.sort(
          (first, second) =>
              first.priority.index.compareTo(second.priority.index),
        );
      case _TaskSort.title:
        tasks.sort((first, second) => first.title.compareTo(second.title));
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = _tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(activeTasks),
                        const SizedBox(height: 17),
                        _buildFilters(),
                        const SizedBox(height: 13),
                        if (_visibleTasks.isEmpty)
                          _buildEmptyState()
                        else
                          ..._visibleTasks.map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildTaskCard(task),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: BottomNavigation(selectedIndex: 1, onTap: _handleNavigation),
      ),
    );
  }

  Widget _buildHeader(int activeTasks) {
    final weekCount = _tasks
        .where(
          (task) =>
              !task.isCompleted &&
              task.deadline.isAfter(DateTime.now()) &&
              task.deadline.isBefore(DateTime.now().add(const Duration(days: 7))),
        )
        .length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Tasks',
                style: TextStyle(
                  color: _navy,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$activeTasks tasks · $weekCount due this week',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: _card,
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: 'Sort tasks',
            onPressed: _showSortOptions,
            icon: const Icon(Icons.tune_rounded, color: _navy, size: 19),
            constraints: const BoxConstraints.tightFor(width: 38, height: 38),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    const filters = [
      _TaskFilter.all,
      _TaskFilter.today,
      _TaskFilter.upcoming,
      _TaskFilter.completed,
    ];
    const labels = ['All', 'Today', 'Upcoming', 'Completed'];

    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          final selected = _selectedFilter == filters[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filters[index]),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? _blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: selected ? Colors.white : _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return TaskCard(
      task: task,
      onTap: () => _openTask(task),
      onCompletionChanged: (completed) =>
          _taskService.setCompleted(task, completed),
      onReminderTap: () => _taskService.toggleReminder(task),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 62),
      child: Column(
        children: [
          const Icon(Icons.task_alt_rounded, color: _blue, size: 42),
          const SizedBox(height: 10),
          Text(
            _selectedFilter == _TaskFilter.completed
                ? 'No completed tasks yet'
                : 'No tasks in this view',
            style: const TextStyle(
              color: _navy,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Check off a task when you finish it.',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _showSortOptions() async {
    final sort = await showModalBottomSheet<_TaskSort>(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sort tasks by',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            _sortOption(context, _TaskSort.newest, 'Newest'),
            _sortOption(context, _TaskSort.deadline, 'Deadline'),
            _sortOption(context, _TaskSort.priority, 'Priority'),
            _sortOption(context, _TaskSort.title, 'Title'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (sort != null) {
      setState(() => _selectedSort = sort);
    }
  }

  Widget _sortOption(BuildContext context, _TaskSort sort, String label) {
    return ListTile(
      dense: true,
      title: Text(label, style: const TextStyle(color: _navy)),
      trailing: _selectedSort == sort
          ? const Icon(Icons.check, color: _blue)
          : null,
      onTap: () => Navigator.of(context).pop(sort),
    );
  }

  Future<void> _showAddTaskDialog() async {
    _newTaskController.clear();
    _newCategoryController.clear();
    var validationMessage = '';

    final taskDetails = await showDialog<(String, String)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _card,
          title: const Text(
            'Add a task',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newTaskController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Task name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newCategoryController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Course or category',
                  border: OutlineInputBorder(),
                ),
              ),
              if (validationMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    validationMessage,
                    style: const TextStyle(color: Color(0xFFE77968)),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = _newTaskController.text.trim();
                if (title.isEmpty) {
                  setDialogState(
                    () => validationMessage = 'Enter a task name.',
                  );
                  return;
                }
                Navigator.of(dialogContext)
                    .pop((title, _newCategoryController.text.trim()));
              },
              child: const Text('Add task'),
            ),
          ],
        ),
      ),
    );

    if (taskDetails == null || !mounted) return;
    _taskService.addTask(
      TaskModel(
        title: taskDetails.$1,
        description: '',
        category: taskDetails.$2.isEmpty ? 'Personal' : taskDetails.$2,
        deadline: DateTime.now().add(const Duration(days: 1)),
        priority: TaskPriority.medium,
        reminderEnabled: true,
        subtasks: [
          'Break the task into steps',
          'Work through each step',
          'Review the result',
        ],
      ),
    );
    setState(() {
      _selectedFilter = _TaskFilter.all;
      _selectedSort = _TaskSort.newest;
    });
  }

  Future<void> _openTask(TaskModel task) async {
    final result = await Navigator.of(context).push<TaskDetailResult>(
      MaterialPageRoute<TaskDetailResult>(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {
      _selectedFilter = task.isCompleted
          ? _TaskFilter.completed
          : _TaskFilter.all;
    });

    switch (result.navigationIndex) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        );
      case 2:
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()));
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const CalendarScreen()),
        );
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
        );
    }
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()));
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CalendarScreen()),
      );
    } else if (index == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
      );
    }
  }

}
