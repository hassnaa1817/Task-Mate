import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_mate/core/utils/date_utils.dart';
import 'package:task_mate/core/utils/priority_utils.dart';
import 'package:task_mate/features/tasks/screens/task_list_screen.dart';
import 'package:task_mate/features/tasks/services/task_service.dart';
import 'package:task_mate/models/task_model.dart';

TaskModel _task({
  required String title,
  required DateTime deadline,
  TaskPriority priority = TaskPriority.medium,
  TaskStatus status = TaskStatus.active,
}) {
  return TaskModel(
    title: title,
    description: '',
    category: 'Test',
    deadline: deadline,
    priority: priority,
    reminderEnabled: true,
    subtasks: ['First step', 'Second step'],
    status: status,
  );
}

void main() {
  group('TaskDateUtils overdue calculations', () {
    final now = DateTime(2026, 9, 30, 12);

    test('formats future countdowns without negative values', () {
      expect(
        TaskDateUtils.formatCountdown(
          now.add(const Duration(hours: 8, minutes: 24)),
          now: now,
        ),
        '08h 24m left',
      );
      expect(
        TaskDateUtils.remainingTime(
          now.subtract(const Duration(minutes: 5)),
          now: now,
        ),
        Duration.zero,
      );
    });

    test('formats overdue duration and treats the deadline as not overdue', () {
      expect(
        TaskDateUtils.formatCountdown(
          now.subtract(const Duration(days: 3)),
          now: now,
        ),
        '3 days overdue',
      );
      expect(TaskDateUtils.formatCountdown(now, now: now), '00h 00m left');
    });
  });

  test('priority selection chooses oldest active overdue task', () {
    final now = DateTime(2026, 9, 30, 12);
    final completedOld = _task(
      title: 'Completed oldest',
      deadline: now.subtract(const Duration(days: 8)),
      priority: TaskPriority.high,
      status: TaskStatus.completed,
    );
    final oldOverdue = _task(
      title: 'Old overdue',
      deadline: now.subtract(const Duration(days: 5)),
      priority: TaskPriority.low,
    );
    final recentOverdue = _task(
      title: 'Recent overdue',
      deadline: now.subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
    );
    final future = _task(
      title: 'Future',
      deadline: now.add(const Duration(hours: 1)),
    );

    expect(
      PriorityUtils.selectPriorityTask([
        completedOld,
        recentOverdue,
        future,
        oldOverdue,
      ], now: now)?.title,
      'Old overdue',
    );
  });

  test('subtask completion does not complete task; manual completion preserves data', () {
    final service = TaskService.instance;
    final task = _task(
      title: 'Manual completion',
      deadline: DateTime.now().subtract(const Duration(days: 2)),
    );
    final originalDeadline = task.deadline;
    service.addTask(task);
    addTearDown(() => service.deleteTask(task));

    service.toggleSubtask(task, 0, true);
    service.toggleSubtask(task, 1, true);
    expect(task.progress, 1);
    expect(task.isCompleted, isFalse);

    service.setCompleted(task, true);
    expect(task.isCompleted, isTrue);
    expect(task.isOverdue, isFalse);
    expect(task.deadline, originalDeadline);
    expect(task.subtasks, ['First step', 'Second step']);
    expect(task.completedSubtasks, [true, true]);
  });

  test('editing a deadline recalculates overdue without changing priority', () {
    final service = TaskService.instance;
    final task = _task(
      title: 'Deadline edit',
      deadline: DateTime.now().subtract(const Duration(hours: 2)),
      priority: TaskPriority.high,
    );
    service.addTask(task);
    addTearDown(() => service.deleteTask(task));
    expect(task.isOverdue, isTrue);

    service.updateTask(
      task,
      deadline: DateTime.now().add(const Duration(days: 1)),
    );
    expect(task.isOverdue, isFalse);
    expect(task.priority, TaskPriority.high);

    service.updateTask(
      task,
      deadline: DateTime.now().subtract(const Duration(days: 1)),
    );
    expect(task.isOverdue, isTrue);
  });

  testWidgets('overdue task stays active until marked complete', (
    WidgetTester tester,
  ) async {
    final service = TaskService.instance;
    final task = _task(
      title: 'Overdue sample task',
      deadline: DateTime.now().subtract(const Duration(days: 3)),
    );
    service.addTask(task);
    addTearDown(() => service.deleteTask(task));

    await tester.pumpWidget(const MaterialApp(home: TaskListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Overdue sample task'), findsOneWidget);
    expect(find.text('OVERDUE'), findsWidgets);
    expect(find.text('3 days overdue'), findsOneWidget);

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(find.text('Overdue sample task'), findsNothing);
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();
    expect(find.text('Overdue sample task'), findsNothing);
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Overdue sample task'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Overdue sample task'));
    await tester.pumpAndSettle();
    expect(find.text('Mark Complete'), findsOneWidget);
    expect(find.text('3 days overdue'), findsOneWidget);

    await tester.tap(find.text('Mark Complete'));
    await tester.pumpAndSettle();
    expect(task.isCompleted, isTrue);
    expect(task.isOverdue, isFalse);
    expect(task.deadline.isBefore(DateTime.now()), isTrue);
    expect(find.text('Overdue sample task'), findsOneWidget);
    expect(find.text('OVERDUE'), findsNothing);
  });
}
