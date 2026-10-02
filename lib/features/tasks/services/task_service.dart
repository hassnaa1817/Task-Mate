import 'package:flutter/foundation.dart';
import 'package:task_mate/data/dummy/dummy_tasks.dart';

class TaskService extends ChangeNotifier {
  TaskService._();

  static final TaskService instance = TaskService._();

  List<TaskModel> get tasks => List<TaskModel>.unmodifiable(dummyTasks);

  void addTask(TaskModel task) {
    dummyTasks.insert(0, task);
    notifyListeners();
  }

  void deleteTask(TaskModel task) {
    if (dummyTasks.remove(task)) notifyListeners();
  }

  void updateTask(
    TaskModel task, {
    String? title,
    String? description,
    String? category,
    DateTime? deadline,
    TaskPriority? priority,
    bool? reminderEnabled,
    List<String>? subtasks,
    List<bool>? completedSubtasks,
    TaskStatus? status,
  }) {
    if (!dummyTasks.contains(task)) return;
    if (title != null) task.title = title;
    if (description != null) task.description = description;
    if (category != null) task.category = category;
    if (deadline != null) task.deadline = deadline;
    if (priority != null) task.priority = priority;
    if (reminderEnabled != null) task.reminderEnabled = reminderEnabled;
    if (status != null) task.status = status;
    if (subtasks != null) {
      task.subtasks
        ..clear()
        ..addAll(subtasks);
    }
    if (completedSubtasks != null) {
      task.completedSubtasks
        ..clear()
        ..addAll(completedSubtasks);
    }
    task.updateSubtaskProgress();
    notifyListeners();
  }

  void setCompleted(TaskModel task, bool completed) {
    updateTask(
      task,
      status: completed ? TaskStatus.completed : TaskStatus.active,
    );
  }

  void toggleSubtask(TaskModel task, int index, bool completed) {
    if (!dummyTasks.contains(task) ||
        index < 0 ||
        index >= task.completedSubtasks.length) {
      return;
    }
    task.completedSubtasks[index] = completed;
    task.updateSubtaskProgress();
    notifyListeners();
  }

  void toggleReminder(TaskModel task) {
    updateTask(task, reminderEnabled: !task.reminderEnabled);
  }
}
