import 'package:test/test.dart';

import '../lib/service/reminder_service.dart';

void main() {
  test('NORMAL: create reminder with task id and time', () {
    final reminderService = ReminderService();
    final time = DateTime(2026, 12, 1, 9, 0);

    final reminder = reminderService.createReminder(
      taskId: 't1',
      time: time,
    );

    expect(reminder.taskId, 't1');
    expect(reminder.time, time);
    expect(reminderService.reminders.length, 1);
  });

  test('NORMAL: get reminder by id', () {
    final reminderService = ReminderService();
    final time = DateTime(2026, 12, 1, 9, 0);

    final reminder = reminderService.createReminder(
      taskId: 't1',
      time: time,
    );

    final found = reminderService.getReminder(reminder.id);
    expect(found.id, reminder.id);
  });

  test('INVALID: get reminder that does not exist', () {
    final reminderService = ReminderService();

    expect(() => reminderService.getReminder('r999'), throwsException);
  });

  test('NORMAL: get reminder by task id', () {
    final reminderService = ReminderService();
    final time = DateTime(2026, 12, 1, 9, 0);

    reminderService.createReminder(
      taskId: 't1',
      time: time,
    );

    final found = reminderService.getReminderByTaskId('t1');
    expect(found, isNotNull);
    expect(found!.taskId, 't1');
  });

  test('NORMAL: update reminder time', () {
    final reminderService = ReminderService();
    final oldTime = DateTime(2026, 12, 1, 9, 0);
    final newTime = DateTime(2026, 12, 2, 10, 0);

    final reminder = reminderService.createReminder(
      taskId: 't1',
      time: oldTime,
    );

    final updated = reminderService.updateReminder(reminder.id, newTime);
    expect(updated.time, newTime);
  });

  test('NORMAL: delete reminder by id', () {
    final reminderService = ReminderService();

    final reminder = reminderService.createReminder(
      taskId: 't1',
      time: DateTime(2026, 12, 1),
    );

    reminderService.deleteReminder(reminder.id);
    expect(reminderService.reminders.isEmpty, true);
  });

  test('NORMAL: delete reminder by task id', () {
    final reminderService = ReminderService();

    reminderService.createReminder(
      taskId: 't1',
      time: DateTime(2026, 12, 1),
    );

    reminderService.deleteReminderByTaskId('t1');
    expect(reminderService.reminders.isEmpty, true);
  });
}
