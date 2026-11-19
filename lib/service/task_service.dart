import '../model/task.dart';
import 'goal_service.dart';
import 'reminder_service.dart';

class TaskService {
  final GoalService goalService;
  final ReminderService? reminderService;
  int nextId = 1;

  TaskService(this.goalService, [this.reminderService]);

  List<Task> get tasks {

    final List<Task> all = [];

    for (final goal in goalService.goals) {
      for (final task in goal.tasks) {
        all.add(task);
      }
    }

    return all;
  }

  List<Task> getAllTasks() => tasks;

  Task createTask({required String goalId,required String title,DateTime? deadline,Priority priority = Priority.low,
  }) {
   
    if (title.trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }
    
    final goal = goalService.getGoal(goalId);
    
    final task = Task(
      id: 't${nextId++}',
      goalId: goalId,
      title: title,
      deadline: deadline,
      priority: priority,
    );
    if (deadline != null && reminderService != null) {
     
      final reminder = reminderService!.createReminder(taskId: task.id,time: deadline,);
      task.reminderId = reminder.id;
    }
  
    goal.tasks.add(task);
    return task;
  }

  Task getTask(String taskId) {
    for (final goal in goalService.goals) {
      
      for (final task in goal.tasks) {
       
        if (task.id == taskId) {
          
          return task;
        }
      }
    }
    throw Exception('Task not found: $taskId');
  }

  List<Task> getTasksByGoal (String goalId) {

    final goal = goalService.getGoal(goalId);


    return goal.tasks;
  }

  Task updateTask({required String taskId,
    String? title,
    DateTime? deadline,
    Priority? priority,
    bool clearDeadline = false,
  }) {
    final task = getTask(taskId);
    if (title != null) {
      if (title.trim().isEmpty) {
        throw Exception('Task title cannot be empty');
      }
      task.title = title;
    }
    if (priority != null) {
      task.priority = priority;
    }
    if (clearDeadline) {
      task.deadline = null;

      if (reminderService != null && task.reminderId != null) {

        reminderService!.deleteReminder(task.reminderId!);
        task.reminderId = null;
      }
    } else if (deadline != null) {

      task.deadline = deadline;

      if (reminderService != null && !task.isDone) {

        if (task.reminderId != null) {
          reminderService!.updateReminder(task.reminderId!, deadline);

        } else {

          final reminder = reminderService!.createReminder(
            taskId: task.id,
            time: deadline,
          );
          task.reminderId = reminder.id;
        }
      }
    }
    return task;
  }

  Task toggleTaskDone(String taskId) {

    final task = getTask(taskId);

    task.toggleDone();

    if (reminderService != null) {
      
    if (task.isDone && task.reminderId != null) {

        reminderService!.deleteReminder(task.reminderId!);
        
        task.reminderId = null;

  } else if (!task.isDone && task.deadline != null) {

   final reminder = reminderService!.createReminder(taskId: task.id,time: task.deadline!,);
        
        task.reminderId = reminder.id;
      }
    }
    return task;
  }

  void deleteTask(String taskId) {

    final task = getTask(taskId);
    final goal = goalService.getGoal(task.goalId);

 if (reminderService != null && task.reminderId != null) {

      reminderService!.deleteReminder(task.reminderId!);
      task.reminderId = null;
    }
    goal.tasks.remove(task);
  }
}
