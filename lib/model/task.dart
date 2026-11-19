enum Priority { high, medium, low }

class Task {
  final String id;
  final String goalId;
  String title;
  DateTime? deadline;
  Priority priority;
  bool isDone;
  String? reminderId;

  Task({
    required this.id,
    required this.goalId,
    required this.title,
    this.deadline,
    this.priority = Priority.low,
    this.isDone = false,
    this.reminderId,
  });

  bool get hasDeadline => deadline != null;

  void toggleDone() {
    isDone = !isDone;
  }

  bool isLate([DateTime? now]) {
    if (isDone || deadline == null) return false;
    final current = now ?? DateTime.now();
    return deadline!.isBefore(current);
  }
}
