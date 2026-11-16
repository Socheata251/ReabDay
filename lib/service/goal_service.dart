import '../model/goal.dart';

class GoalService {
  final List<Goal> _goals = [];
  int _nextId = 1;
  final DateTime Function() _now;

  GoalService({DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  List<Goal> get goals => List.unmodifiable(_goals);

  // Business rule: a goal needs a title.
  Goal createGoal({
    required String title,
    String note = '',
    Category category = Category.study,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Goal title cannot be empty');
    }
    final goal = Goal(
      id: 'g${_nextId++}',
      title: title.trim(),
      note: note,
      category: category,
      createdAt: _now(),
    );
    _goals.add(goal);
    return goal;
  }

  Goal getGoal(String goalId) {
    return _goals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => throw StateError('Goal not found: $goalId'),
    );
  }

  // Deleting a goal also deletes all its tasks (and their reminders).
  void deleteGoal(String goalId) {
    final goal = getGoal(goalId);
    goal.tasks.clear();
    _goals.remove(goal);
  }

  // Example: "3 / 5 (60%)"
  String progressText(String goalId) {
    final goal = getGoal(goalId);
    return '${goal.doneTasks} / ${goal.totalTasks} (${goal.percent}%)';
  }
}
