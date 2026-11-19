import '../model/reminder.dart';

class ReminderService {
  final List<Reminder> _reminders = [];
  int _nextId = 1;

  List<Reminder> get reminders => List.unmodifiable(_reminders);

  List<Reminder> getAllReminders() => reminders;

  Reminder createReminder({
    required String taskId,
    required DateTime time,
  }) {
    final reminder = Reminder(
      id: 'r${_nextId++}',
      taskId: taskId,
      time: time,
    );
    _reminders.add(reminder);
    return reminder;
  }

  Reminder getReminder(String reminderId) {
    for (final reminder in _reminders) {
      if (reminder.id == reminderId) {
        return reminder;
      }
    }
    throw Exception('Reminder not found: $reminderId');
  }

  Reminder? getReminderByTaskId(String taskId) {
    for (final reminder in _reminders) {
      if (reminder.taskId == taskId) {
        return reminder;
      }
    }
    return null;
  }

  Reminder updateReminder(String reminderId, DateTime newTime) {
    for (int i = 0; i < _reminders.length; i++) {
      if (_reminders[i].id == reminderId) {
        final updated = Reminder(
          id: reminderId,
          taskId: _reminders[i].taskId,
          time: newTime,
        );
        _reminders[i] = updated;
        return updated;
      }
    }
    throw Exception('Reminder not found: $reminderId');
  }

  void deleteReminder(String reminderId) {
    final reminder = getReminder(reminderId);
    _reminders.remove(reminder);
  }

  void deleteReminderByTaskId(String taskId) {
    _reminders.removeWhere((r) => r.taskId == taskId);
  }
}
