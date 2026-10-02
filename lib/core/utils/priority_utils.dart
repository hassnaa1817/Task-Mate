import 'package:task_mate/core/utils/date_utils.dart';
import 'package:task_mate/models/task_model.dart';

class PriorityUtils {
  const PriorityUtils._();

  static TaskModel? selectPriorityTask(
    Iterable<TaskModel> tasks, {
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final activeTasks = tasks.where((task) => !task.isCompleted).toList();
    if (activeTasks.isEmpty) return null;

    final overdueTasks = activeTasks
        .where(
          (task) => TaskDateUtils.isOverdue(task.deadline, now: currentTime),
        )
        .toList();
    if (overdueTasks.isNotEmpty) {
      overdueTasks.sort((first, second) {
        final deadlineOrder = first.deadline.compareTo(second.deadline);
        return deadlineOrder != 0
            ? deadlineOrder
            : first.priority.index.compareTo(second.priority.index);
      });
      return overdueTasks.first;
    }

    activeTasks.sort((first, second) {
      final deadlineOrder = first.deadline.compareTo(second.deadline);
      return deadlineOrder != 0
          ? deadlineOrder
          : first.priority.index.compareTo(second.priority.index);
    });

    final closestDeadline = activeTasks.first.deadline;
    final closeCandidates = activeTasks
        .where(
          (task) =>
              task.deadline.difference(closestDeadline) <=
              const Duration(hours: 1),
        )
        .toList()
      ..sort((first, second) {
        final priorityOrder = first.priority.index.compareTo(
          second.priority.index,
        );
        return priorityOrder != 0
            ? priorityOrder
            : first.deadline.compareTo(second.deadline);
      });
    return closeCandidates.first;
  }
}
