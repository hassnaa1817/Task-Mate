import 'package:task_mate/core/utils/date_utils.dart';

enum TaskPriority { high, medium, low }

enum TaskStatus { active, completed }

class TaskModel {
  TaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.deadline,
    DateTime? createdAt,
    required this.priority,
    required this.reminderEnabled,
    required List<String> subtasks,
    List<bool>? completedSubtasks,
    this.status = TaskStatus.active,
    this.progress = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       subtasks = List<String>.of(subtasks),
       completedSubtasks = List<bool>.of(
         completedSubtasks ?? List<bool>.filled(subtasks.length, false),
       ) {
    while (this.completedSubtasks.length < this.subtasks.length) {
      this.completedSubtasks.add(false);
    }
    if (this.completedSubtasks.length > this.subtasks.length) {
      this.completedSubtasks.removeRange(
        this.subtasks.length,
        this.completedSubtasks.length,
      );
    }
    updateSubtaskProgress();
  }

  String title;
  String description;
  String category;
  DateTime deadline;
  final DateTime createdAt;
  TaskPriority priority;
  bool reminderEnabled;
  final List<String> subtasks;
  final List<bool> completedSubtasks;
  TaskStatus status;
  double progress;

  bool get isCompleted => status == TaskStatus.completed;

  bool get isOverdue => !isCompleted && TaskDateUtils.isOverdue(deadline);

  void updateSubtaskProgress() {
    if (subtasks.isEmpty) {
      progress = 0;
      return;
    }
    progress =
        completedSubtasks.where((completed) => completed).length /
        subtasks.length;
  }

  int get dateOffset {
    return TaskDateUtils.calendarDayOffset(deadline);
  }

  String get dueTime {
    final hour = deadline.hour % 12 == 0 ? 12 : deadline.hour % 12;
    final minute = deadline.minute.toString().padLeft(2, '0');
    final period = deadline.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String get timeLeft {
    return TaskDateUtils.formatCountdown(deadline);
  }
}
