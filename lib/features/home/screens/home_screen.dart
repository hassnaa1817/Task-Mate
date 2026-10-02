import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:task_mate/core/services/storage_service.dart';
import 'package:task_mate/core/utils/date_utils.dart';
import 'package:task_mate/core/utils/priority_utils.dart';
import 'package:task_mate/features/calendar/screens/calendar_screen.dart';
import 'package:task_mate/features/profile/screens/profile_screen.dart';
import 'package:task_mate/features/tasks/screens/add_task_screen.dart';
import 'package:task_mate/features/tasks/screens/task_detail_screen.dart';
import 'package:task_mate/features/tasks/screens/task_list_screen.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/features/tasks/widgets/deadline_countdown.dart';
import 'package:task_mate/models/task_model.dart';
import 'package:task_mate/shared/widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.userName});

  final String? userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _navy = Color(0xFF263D62);
  static const _cream = Color(0xFFF6F3E8);
  static const _muted = Color(0xFF71809A);
  static const _green = Color(0xFF85C3A1);
  static const _card = Color(0xFFFFFFFF);

  TaskService get _taskService => TaskService.instance;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _taskService.addListener(_handleTasksChanged);
    _clockTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _handleTasksChanged(),
    );
  }

  @override
  void dispose() {
    _taskService.removeListener(_handleTasksChanged);
    _clockTimer?.cancel();
    super.dispose();
  }

  void _handleTasksChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final todayTasks = _taskService.tasks
        .where(
          (task) =>
              !task.isCompleted &&
              TaskDateUtils.isSameCalendarDate(task.deadline, DateTime.now()),
        )
        .toList()
      ..sort((first, second) => first.deadline.compareTo(second.deadline));

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              _buildProgressCard(),
              const SizedBox(height: 14),
              const _SectionTitle(title: 'Priority Task'),
              const SizedBox(height: 12),
              _buildPriorityCard(),
              const SizedBox(height: 14),
              _SectionTitle(
                title: "Today's Tasks",
                action: 'See All',
                onAction: _openTaskList,
              ),
              const SizedBox(height: 12),
              if (todayTasks.isEmpty)
                const Text(
                  'No active tasks due today.',
                  style: TextStyle(color: _muted, fontSize: 12),
                )
              else
                ...todayTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TaskRow(
                      color: _priorityColor(task.priority),
                      title: task.title,
                      category: task.category,
                      time: task.dueTime,
                      task: task,
                      onTap: () => _openTask(task),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: BottomNavigation(selectedIndex: 0, onTap: _handleNavigation),
      ),
    );
  }

  void _openTaskList() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const TaskListScreen()));
  }

  Future<void> _openPriorityTask() async {
    final task = _priorityTask;
    if (task == null) return;
    await _openTask(task);
  }

  Future<void> _openTask(TaskModel task) async {
    final result = await Navigator.of(context).push<TaskDetailResult>(
      MaterialPageRoute<TaskDetailResult>(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );

    if (result == null || !mounted) return;
    if (result.navigationIndex == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const TaskListScreen()),
      );
    } else if (result.navigationIndex == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()),
      );
    } else if (result.navigationIndex == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CalendarScreen()),
      );
    } else if (result.navigationIndex == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
      );
    }
  }

  TaskModel? get _priorityTask =>
      PriorityUtils.selectPriorityTask(_taskService.tasks);

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xFFEF806D);
      case TaskPriority.medium:
        return const Color(0xFF67A8DD);
      case TaskPriority.low:
        return _green;
    }
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  String _dueDayLabel(int offset) {
    if (offset == 0) return 'Today';
    if (offset == 1) return 'Tomorrow';
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[DateTime.now().add(Duration(days: offset)).weekday - 1];
  }

  void _handleNavigation(int index) {
    if (index == 1) {
      _openTaskList();
    } else if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()));
    } else if (index == 3) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const CalendarScreen()));
    } else if (index == 4) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen()));
    }
  }

  Widget _buildHeader() {
    final today = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final loggedInName =
        (AuthStorage.instance.currentUserName ?? widget.userName ?? '').trim();
    final greetingText = loggedInName.isEmpty
        ? 'Good morning!'
        : 'Good morning, $loggedInName 👋';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingText,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${weekdays[today.weekday - 1]}, ${today.day} ${months[today.month - 1]}',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: _card, shape: BoxShape.circle),
          child: const Icon(Icons.notifications_none, color: _navy, size: 21),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    final tasks = _taskService.tasks;
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final remainingTasks = totalTasks - completedTasks;
    final completion = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    final completionPercent = (completion * 100).round();

    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x160F1C2E),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            height: 112,
            child: CustomPaint(
              painter: _ProgressPainter(progress: completion),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$completionPercent%',
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$completedTasks of $totalTasks complete',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F4EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'ON A ROLL',
                    style: TextStyle(
                      color: _green,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  remainingTasks == 0
                      ? 'All tasks completed! 🎉'
                      : '$remainingTasks tasks remaining',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 19,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  remainingTasks == 0
                      ? '🎉 Great work on completing everything.'
                      : 'Little by little, you’re getting it done.',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityCard() {
    final task = _priorityTask;
    if (task == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'All tasks completed! 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _navy,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    final priorityColor = switch (task.priority) {
      TaskPriority.high => const Color(0xFFEF806D),
      TaskPriority.medium => const Color(0xFF67A8DD),
      TaskPriority.low => _green,
    };
    final countdownColor = task.isOverdue
        ? const Color(0xFFE98B78)
        : priorityColor;

    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _openPriorityTask,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x130F1C2E),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD5D4CC),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      task.title,
                      maxLines: 2,
                      style: TextStyle(
                        color: _navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDDD7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _priorityLabel(task.priority),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 31, top: 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    task.category,
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                ),
              ),
              if (task.isOverdue)
                const Padding(
                  padding: EdgeInsets.only(left: 31, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _OverdueBadge(),
                  ),
                ),
              const SizedBox(height: 9),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 12,
                    color: _muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_dueDayLabel(task.dateOffset)}, ${task.dueTime}',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                  const Spacer(),
                  DeadlineCountdown(
                    deadline: task.deadline,
                    isCompleted: task.isCompleted,
                    fontSize: 10,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    task.reminderEnabled
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    size: 13,
                    color: task.reminderEnabled ? priorityColor : _muted,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(task.progress * 100).round()}%',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: task.progress,
                  minHeight: 5,
                  backgroundColor: Color(0xFFF0EDE5),
                  valueColor: AlwaysStoppedAnimation(countdownColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _HomeScreenState._navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                color: Color(0xFF5793D0),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.color,
    required this.title,
    required this.category,
    required this.time,
    required this.task,
    this.onTap,
  });

  final Color color;
  final String title;
  final String category;
  final String time;
  final TaskModel task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _HomeScreenState._card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _HomeScreenState._navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: const TextStyle(
                        color: _HomeScreenState._muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: _HomeScreenState._muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  DeadlineCountdown(
                    deadline: task.deadline,
                    isCompleted: task.isCompleted,
                    showOverdueBadge: true,
                    fontSize: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverdueBadge extends StatelessWidget {
  const _OverdueBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE98B78).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'OVERDUE',
        style: TextStyle(
          color: Color(0xFFE98B78),
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    final background = Paint()
      ..color = const Color(0xFFDAD9D1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    final progressPaint = Paint()
      ..color = _HomeScreenState._green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 9;
    canvas.drawCircle(center, radius, background);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
