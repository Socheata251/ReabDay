import 'task.dart';

enum Category { study, personal }

class Goal {
  final String id;
  String title;
  String note;
  Category category;
  final DateTime createdAt;
  final List<Task> tasks = [];

  Goal({
    required this.id,
    required this.title,
    this.note = '',
    this.category = Category.study,
    required this.createdAt,
  });

  int get totalTasks => tasks.length;
  int get doneTasks => tasks.where((t) => t.isDone).length;
  int get percent =>
      totalTasks == 0 ? 0 : ((doneTasks / totalTasks) * 100).round();
}
