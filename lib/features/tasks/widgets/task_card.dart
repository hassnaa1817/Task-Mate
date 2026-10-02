import 'package:flutter/material.dart';
import 'package:task_mate/core/utils/date_utils.dart';
import 'package:task_mate/features/tasks/widgets/deadline_countdown.dart';
import 'package:task_mate/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onCompletionChanged,
    required this.onReminderTap,
  });

  final TaskModel task;
  final VoidCallback onTap;
  final ValueChanged<bool> onCompletionChanged;
  final VoidCallback onReminderTap;

  static const _navy = Color(0xFF263D62);
  static const _muted = Color(0xFF71809A);

  @override
  Widget build(BuildContext context) {
    final priorityColor = switch (task.priority) {
      TaskPriority.high => const Color(0xFFEF806D),
      TaskPriority.medium => const Color(0xFF67A8DD),
      TaskPriority.low => const Color(0xFF85C3A1),
    };
    final priorityName = switch (task.priority) {
      TaskPriority.high => 'HIGH',
      TaskPriority.medium => 'MEDIUM',
      TaskPriority.low => 'LOW',
    };

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 11, 11, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120F1C2E),
                blurRadius: 13,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        if (value != null) onCompletionChanged(value);
                      },
                      shape: const CircleBorder(),
                      side: const BorderSide(
                        color: Color(0xFFD9D8D0),
                        width: 1.7,
                      ),
                      activeColor: const Color(0xFF73A9D6),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _navy,
                        fontSize: 13,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  _Pill(
                    label: priorityName,
                    color: priorityColor,
                    background: priorityColor.withValues(alpha: 0.15),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    task.category,
                    style: const TextStyle(color: _muted, fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: _muted,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_dueDayLabel(task.deadline)}, ${task.dueTime}',
                    style: const TextStyle(color: _muted, fontSize: 9),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: DeadlineCountdown(
                      deadline: task.deadline,
                      isCompleted: task.isCompleted,
                      showOverdueBadge: true,
                      fontSize: 9,
                    ),
                  ),
                  IconButton(
                    tooltip: task.reminderEnabled
                        ? 'Turn reminder off'
                        : 'Turn reminder on',
                    onPressed: onReminderTap,
                    icon: Icon(
                      task.reminderEnabled
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined,
                      color: task.reminderEnabled ? priorityColor : _muted,
                      size: 14,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Progress ${(task.progress * 100).round()}%',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: task.progress,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFEAE8E0),
                  valueColor: AlwaysStoppedAnimation(
                    task.isCompleted ? const Color(0xFF85C3A1) : priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dueDayLabel(DateTime deadline) {
    final dayOffset = TaskDateUtils.calendarDayOffset(deadline);
    if (dayOffset == 0) return 'Today';
    if (dayOffset == 1) return 'Tomorrow';
    return '${deadline.month}/${deadline.day}';
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
