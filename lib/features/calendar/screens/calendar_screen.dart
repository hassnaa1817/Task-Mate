import 'package:flutter/material.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/features/tasks/widgets/deadline_countdown.dart';
import 'package:task_mate/models/task_model.dart';
import 'package:task_mate/features/home/screens/home_screen.dart';
import 'package:task_mate/features/profile/screens/profile_screen.dart';
import 'package:task_mate/features/tasks/screens/add_task_screen.dart';
import 'package:task_mate/features/tasks/screens/task_detail_screen.dart';
import 'package:task_mate/features/tasks/screens/task_list_screen.dart';
import 'package:task_mate/shared/widgets/bottom_navigation.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _navy = Color(0xFF2C415E);
  static const _cream = Color(0xFFF7F1E6);
  static const _muted = Color(0xFF77849C);
  static const _blue = Color(0xFF73A9D6);
  static const _card = Colors.white;
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  TaskService get _taskService => TaskService.instance;

  @override
  void initState() {
    super.initState();
    _taskService.addListener(_handleTasksChanged);
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _taskService.removeListener(_handleTasksChanged);
    super.dispose();
  }

  void _handleTasksChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay =
        _taskService.tasks
            .where(
              (task) => _isSameDay(task.deadline, _selectedDate),
            )
            .toList()
          ..sort((first, second) => first.deadline.compareTo(second.deadline));
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final firstWeekday = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
    ).weekday;
    final leadingDays = firstWeekday % 7;
    final dayCells = <DateTime?>[
      ...List<DateTime?>.filled(leadingDays, null),
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(_displayedMonth.year, _displayedMonth.month, day),
    ];
    while (dayCells.length % 7 != 0) {
      dayCells.add(null);
    }

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Calendar',
                                style: TextStyle(
                                  color: _navy,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${_monthName(_displayedMonth.month)} • ${_tasksInMonth().length} tasks planned',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: _card,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: 'Add task',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const AddTaskScreen(),
                              ),
                            ),
                            icon: const Icon(
                              Icons.add_box_outlined,
                              color: _navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x120F1C2E),
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Previous month',
                                onPressed: () => _changeMonth(-1),
                                icon: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: _navy,
                                ),
                                splashRadius: 20,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '${_monthName(_displayedMonth.month)} ${_displayedMonth.year}',
                                    style: const TextStyle(
                                      color: _navy,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Next month',
                                onPressed: () => _changeMonth(1),
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: _navy,
                                ),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              for (final weekday in _weekdays)
                                Expanded(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 6,
                                        top: 2,
                                      ),
                                      child: Text(
                                        weekday,
                                        style: const TextStyle(
                                          color: _muted,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 2,
                                  childAspectRatio: 1.13,
                                ),
                            itemCount: dayCells.length,
                            itemBuilder: (context, index) {
                              final date = dayCells[index];
                              if (date == null) {
                                return const SizedBox.shrink();
                              }

                              final selected = _isSameDay(date, _selectedDate);
                              final dayTasks = _taskService.tasks
                                  .where(
                                    (task) => _isSameDay(task.deadline, date),
                                  )
                                  .toList();
                              return Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () =>
                                      setState(() => _selectedDate = date),
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 160,
                                          ),
                                          width: 30,
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? _blue
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                          child: Text(
                                            '${date.day}',
                                            style: TextStyle(
                                              color: selected
                                                  ? Colors.white
                                                  : _navy,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: dayTasks
                                              .take(3)
                                              .map(
                                                (task) => Container(
                                                  width: 4,
                                                  height: 4,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _priorityColor(
                                                      task.priority,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDateLabel(_selectedDate),
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${tasksForSelectedDay.length} ${tasksForSelectedDay.length == 1 ? 'task' : 'tasks'}',
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (tasksForSelectedDay.isEmpty)
                      _buildEmptyDay()
                    else
                      ...tasksForSelectedDay.map(_buildTaskCard),
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
        child: BottomNavigation(selectedIndex: 3, onTap: _handleNavigation),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final priorityColor = switch (task.priority) {
      TaskPriority.high => const Color(0xFFEF806D),
      TaskPriority.medium => const Color(0xFF67A8DD),
      TaskPriority.low => const Color(0xFF85C3A1),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F1C2E),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openTask(task),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.article_outlined,
                    color: priorityColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      task.dueTime,
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    DeadlineCountdown(
                      deadline: task.deadline,
                      isCompleted: task.isCompleted,
                      showOverdueBadge: true,
                      fontSize: 9,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'No tasks scheduled for this day.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 12),
      ),
    );
  }

  Future<void> _openTask(TaskModel task) async {
    final result = await Navigator.of(context).push<TaskDetailResult>(
      MaterialPageRoute<TaskDetailResult>(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    );
    if (result == null || !mounted) return;

    setState(() {});
    if (result.navigationIndex == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    } else if (result.navigationIndex == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const TaskListScreen()),
      );
    } else if (result.navigationIndex == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()),
      );
    } else if (result.navigationIndex == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
      );
    }

  }

  List<TaskModel> _tasksInMonth() => _taskService.tasks
      .where(
        (task) =>
            task.deadline.year == _displayedMonth.year &&
            task.deadline.month == _displayedMonth.month,
      )
      .toList();

  void _changeMonth(int offset) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + offset,
      );
      _selectedDate = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    });
  }

  bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  String _selectedDateLabel(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${_monthName(date.month)}';
  }

  String _monthName(int month) => const [
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
  ][month - 1];

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xFFEF806D);
      case TaskPriority.medium:
        return const Color(0xFF67A8DD);
      case TaskPriority.low:
        return const Color(0xFF85C3A1);
    }
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

    if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()),
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
