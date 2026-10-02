import 'package:task_mate/models/task_model.dart';

export 'package:task_mate/models/task_model.dart';

DateTime _seedDeadline(int dayOffset, int hour, int minute) {
  final now = DateTime.now();
  final date = now.add(Duration(days: dayOffset));
  return DateTime(date.year, date.month, date.day, hour, minute);
}

DateTime _seedCreatedAt(int ageInSeconds) =>
    DateTime.now().subtract(Duration(seconds: ageInSeconds));

final List<TaskModel> dummyTasks = [
  TaskModel(
    title: 'Psychology research outline',
    description: 'Plan and draft the research outline for PSY 214.',
    category: 'PSY 214 · Assignment',
    deadline: _seedDeadline(0, 16, 0),
    createdAt: _seedCreatedAt(1),
    priority: TaskPriority.high,
    reminderEnabled: true,
    subtasks: [
      'Review assignment brief',
      'Collect five peer-reviewed sources',
      'Create thesis statement',
      'Draft section headings',
      'Write introduction',
    ],
    completedSubtasks: [true, true, true, false, false],
  ),
  TaskModel(
    title: 'Calculus problem set 6',
    description: 'Complete the assigned calculus problem set.',
    category: 'MATH 201 · Problem Set',
    deadline: _seedDeadline(1, 10, 0),
    createdAt: _seedCreatedAt(2),
    priority: TaskPriority.medium,
    reminderEnabled: true,
    subtasks: [
      'Review the chapter examples',
      'Solve the first five questions',
      'Double-check the final answers',
    ],
  ),
  TaskModel(
    title: 'Student society budget',
    description: 'Prepare the student society budget summary.',
    category: 'Campus Life · Treasurer',
    deadline: _seedDeadline(2, 18, 0),
    createdAt: _seedCreatedAt(3),
    priority: TaskPriority.low,
    reminderEnabled: true,
    subtasks: [
      'Collect student reimbursement requests',
      'Review event spending totals',
      'Prepare summary for committee',
    ],
  ),
  TaskModel(
    title: 'Literature response journal',
    description: 'Write a response journal entry for this week’s reading.',
    category: 'LIT 110 · Reading',
    deadline: _seedDeadline(4, 23, 59),
    createdAt: _seedCreatedAt(4),
    priority: TaskPriority.medium,
    reminderEnabled: true,
    subtasks: [
      'Read the assigned chapter',
      'Note three key arguments',
      'Write the reflection paragraph',
    ],
  ),
  TaskModel(
    title: 'Programming assignment submission',
    description: 'Complete the programming assignment for CS 101.',
    category: 'CS 101 · Assignment',
    deadline: _seedDeadline(5, 15, 0),
    createdAt: _seedCreatedAt(5),
    priority: TaskPriority.high,
    reminderEnabled: true,
    subtasks: [
      'Read the assigned chapter',
      'Note three key arguments',
      'Write the reflection paragraph',
    ],
  ),

  // --latihan push (ikam)--
  TaskModel(
    title: 'History essay draft',
    description: 'Draft the essay for HIST 202.',
    category: 'HIST 202 · Essay',
    deadline: _seedDeadline(6, 12, 0),
    createdAt: _seedCreatedAt(6),
    priority: TaskPriority.medium,
    reminderEnabled: true,
    subtasks: [
      'Research primary sources',
      'Outline the essay structure',
      'Write the first draft',
    ],
  ),

  TaskModel(
    title: 'Artificial Intelligence project proposal',
    description: 'Draft the project proposal for CS 201.',
    category: 'CS 201 · Project',
    deadline: _seedDeadline(6, 12, 0),
    createdAt: _seedCreatedAt(6),
    priority: TaskPriority.medium,
    reminderEnabled: true,
    subtasks: [
      'Research primary sources',
      'Outline the essay structure',
      'Write the first draft',
    ],
  ),
];
