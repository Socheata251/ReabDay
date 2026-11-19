import 'package:test/test.dart';

import '../lib/model/task.dart';
import '../lib/service/goal_service.dart';
import '../lib/service/reminder_service.dart';
import '../lib/service/task_service.dart';

void main() {
  test('NORMAL: create task with valid title', () {
    final goalService = GoalService();
    final taskService = TaskService(goalService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    final task = taskService.createTask(
      goalId: goal.id,
      title: 'Learn Widgets',
    );

    expect(task.title, 'Learn Widgets');
    expect(taskService.tasks.length, 1);
  });

  test('INVALID: empty title throws error', () {
    final goalService = GoalService();
    final taskService = TaskService(goalService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    expect(
      () => taskService.createTask(goalId: goal.id, title: '  '),
      throwsException,
    );
  });

  test('INVALID: get task that does not exist', () {
    final goalService = GoalService();
    final taskService = TaskService(goalService);

    expect(() => taskService.getTask('t999'), throwsException);
  });

  test(' task with deadline creates reminder', () {
    final goalService = GoalService();
    final reminderService = ReminderService();
    final taskService = TaskService(goalService, reminderService);
    final goal = goalService.createGoal(title: 'Study Flutter');
    final deadline = DateTime(2026, 12, 1);

    final task = taskService.createTask(
      goalId: goal.id,
      title: 'Submit Homework',
      deadline: deadline,
    );

    expect(task.reminderId, isNotNull);
    expect(reminderService.reminders.length, 1);
  });

  test('task without deadline has no reminder', () {
    final goalService = GoalService();
    final reminderService = ReminderService();
    final taskService = TaskService(goalService, reminderService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    final task = taskService.createTask(
      goalId: goal.id,
      title: 'Read Book',
    );

    expect(task.reminderId, isNull);
    expect(reminderService.reminders.isEmpty, true);
  });

  test('toggle task done and undo', () {
    final goalService = GoalService();
    final taskService = TaskService(goalService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    final task = taskService.createTask(goalId: goal.id,title: 'Practice Coding',
    );

    expect(task.isDone, false);

    taskService.toggleTaskDone(task.id);

    expect(task.isDone, true);

    taskService.toggleTaskDone(task.id);

    expect(task.isDone, false);
  });

  test('mark task done removes reminder', () {
    final goalService = GoalService();
    final reminderService = ReminderService();
    final taskService = TaskService(goalService, reminderService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    final task = taskService.createTask(
      goalId: goal.id,
      title: 'Finish Lab',
      deadline: DateTime(2026, 12, 1),
    );

    expect(task.reminderId, isNotNull);
    taskService.toggleTaskDone(task.id);
    expect(task.reminderId, isNull);
    expect(reminderService.reminders.isEmpty, true);
  });

  test('update task title and priority', () {
    final goalService = GoalService();
    final taskService = TaskService(goalService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    final task = taskService.createTask(
      goalId: goal.id,
      title: 'Old Title',
    );

    taskService.updateTask(
      taskId: task.id,
      title: 'New Title',
      priority: Priority.high,
    );

    expect(task.title, 'New Title');
    expect(task.priority, Priority.high);
  });

  test('NORMAL: delete task removes from goal and deletes reminder', () {
    final goalService = GoalService();
    final reminderService = ReminderService();
    final taskService = TaskService(goalService, reminderService);
    final goal = goalService.createGoal(title: 'Study Flutter');

    final task = taskService.createTask(
      goalId: goal.id,
      title: 'Clean Room',
      deadline: DateTime(2026, 12, 1),
    );

    taskService.deleteTask(task.id);
    expect(taskService.tasks.isEmpty, true);
    expect(reminderService.reminders.isEmpty, true);
  });
}
