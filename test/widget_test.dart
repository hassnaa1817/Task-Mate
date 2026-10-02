import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_mate/core/services/storage_service.dart';
import 'package:task_mate/data/dummy/dummy_tasks.dart';
import 'package:task_mate/features/home/screens/home_screen.dart';
import 'package:task_mate/features/onboarding/screens/onboarding_screen.dart';
import 'package:task_mate/features/onboarding/screens/welcome_screen.dart';
import 'package:task_mate/main.dart';

void main() {
  testWidgets('Welcome and onboarding fit compact screens and stay navigable', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Task Mate'), findsOneWidget);
    expect(find.text('Meet Task Mate'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    final welcomeButtonSize = tester.getSize(
      find.ancestor(
        of: find.text('Get Started'),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Keep tasks\norganized'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    final onboardingButtonSize = tester.getSize(
      find.ancestor(
        of: find.text('Next'),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(onboardingButtonSize.width, welcomeButtonSize.width);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Never miss a\ndeadline'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(find.text('See your progress'), findsOneWidget);
    expect(find.text('Let’s Begin'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Let’s Begin'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Home dashboard renders task summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(initialScreen: HomeScreen(userName: 'Budi')),
    );

    expect(find.text('Good morning, Budi 👋'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('Priority Task'), findsOneWidget);
    expect(find.text('Psychology research outline'), findsWidgets);
    expect(find.text("Today's Tasks"), findsOneWidget);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Psychology research outline').first);
    await tester.pumpAndSettle();
    expect(find.text('Task Details'), findsOneWidget);
    expect(find.text('Review assignment brief'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
  });

  testWidgets('Calendar dates and task cards are interactive', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MyApp(initialScreen: HomeScreen(userName: 'Budi')),
    );

    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();

    expect(find.text('Calendar'), findsWidgets);
    expect(find.text('M'), findsWidgets);
    expect(find.text('T'), findsWidgets);
    expect(find.text('W'), findsOneWidget);

    await tester.tap(find.text('Psychology research outline'));
    await tester.pumpAndSettle();
    expect(find.text('Task Details'), findsOneWidget);
    expect(find.text('Review assignment brief'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Add Task saves and displays a new task in the task list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(initialScreen: HomeScreen(userName: 'Budi')),
    );

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('Psychology research outline'), findsOneWidget);
    expect(find.text('Calculus problem set 6'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Today').first);
    await tester.pumpAndSettle();
    expect(find.text('Psychology research outline'), findsOneWidget);
    expect(find.text('Calculus problem set 6'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Psychology research outline'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Add Task'), findsOneWidget);
    await tester.ensureVisible(find.text('Create Task'));
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a task title.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Plan study session');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Review notes and plan the next study session.',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(ElevatedButton).last);
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle();
    expect(find.text('Plan study session'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Plan study session'), findsOneWidget);
  });

  testWidgets('Completing every subtask does not complete the parent task', (
    WidgetTester tester,
  ) async {
    final task = dummyTasks.firstWhere(
      (task) => task.title == 'Calculus problem set 6',
    );
    task.status = TaskStatus.active;
    task.completedSubtasks
      ..clear()
      ..addAll(List<bool>.filled(task.subtasks.length, false));
    task.updateSubtaskProgress();

    await tester.pumpWidget(
      const MyApp(initialScreen: HomeScreen(userName: 'Budi')),
    );
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calculus problem set 6'));
    await tester.pumpAndSettle();

    for (final subtask in task.subtasks) {
      await tester.tap(find.byKey(ValueKey('subtask-toggle-$subtask')));
      await tester.pumpAndSettle();
    }

    expect(
      find.text('${task.subtasks.length} of ${task.subtasks.length}'),
      findsOneWidget,
    );
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Mark Complete'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(task.status, TaskStatus.active);
    expect(find.text('Calculus problem set 6'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Completing a task preserves subtasks and moves it to Completed',
    (WidgetTester tester) async {
      final task = dummyTasks.firstWhere(
        (task) => task.title == 'Psychology research outline',
      );
      task.status = TaskStatus.active;
      task.completedSubtasks
        ..clear()
        ..addAll([true, true, true, false, false]);
      task.updateSubtaskProgress();

      await tester.pumpWidget(
        const MyApp(initialScreen: HomeScreen(userName: 'Budi')),
      );

      await tester.tap(find.text('Tasks'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Psychology research outline').first);
      await tester.pumpAndSettle();

      expect(find.text('Task Details'), findsOneWidget);
      expect(find.text('3 of 5'), findsOneWidget);
      expect(find.text('Review assignment brief'), findsOneWidget);
      expect(find.text('60%'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Reminder set'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reminder set'));
      await tester.pumpAndSettle();
      expect(find.text('Reminder off'), findsOneWidget);

      await tester.ensureVisible(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'Updated psychology paper',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Updated psychology paper'), findsOneWidget);

      await tester.ensureVisible(find.text('Mark Complete'));
      await tester.tap(find.text('Mark Complete'));
      await tester.pumpAndSettle();

      expect(find.text('My Tasks'), findsOneWidget);
      expect(find.text('Updated psychology paper'), findsOneWidget);
      expect(find.text('Completed'), findsWidgets);
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(find.text('Updated psychology paper'), findsNothing);
      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect(find.text('Updated psychology paper'), findsOneWidget);

      await tester.tap(find.text('Updated psychology paper'));
      await tester.pumpAndSettle();
      expect(find.text('Task Details'), findsOneWidget);
      expect(find.text('3 of 5'), findsOneWidget);
      expect(find.text('60%'), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('20%'), findsOneWidget);
      expect(find.text('1 of 5 complete'), findsOneWidget);
      expect(find.text('4 tasks remaining'), findsOneWidget);
      expect(find.text('Updated psychology paper'), findsNothing);
      expect(find.text('Calculus problem set 6'), findsOneWidget);
      expect(find.text('All tasks completed! 🎉'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Profile opens from navbar and settings respond to changes', (
    WidgetTester tester,
  ) async {
    final authStorage = AuthStorage.instance;
    expect(
      authStorage.registerUser(
        name: 'Budi Student',
        email: 'budi.student@example.com',
        password: 'test-password',
      ),
      isTrue,
    );
    expect(
      authStorage.login(
        email: 'budi.student@example.com',
        password: 'test-password',
      ),
      isNotNull,
    );
    addTearDown(authStorage.logout);

    await tester.pumpWidget(
      const MyApp(initialScreen: HomeScreen(userName: 'Budi')),
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Your Task Mate space'), findsOneWidget);
    expect(find.text('Budi Student'), findsOneWidget);
    expect(find.text('budi.student@example.com'), findsOneWidget);
    expect(find.text('Notification settings'), findsOneWidget);
    expect(find.text('Group task updates'), findsOneWidget);
    expect(find.text('Help & feedback'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Budi Updated');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Budi Updated'), findsOneWidget);
    expect(authStorage.currentUser?.name, 'Budi Updated');
    expect(find.text('budi.student@example.com'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Good morning, Budi Updated 👋'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).at(2));
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch).at(2)).value, isTrue);

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('My Tasks'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
