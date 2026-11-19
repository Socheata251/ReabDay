import 'package:test/test.dart';

import '../lib/service/goal_service.dart';

void main() {
  final now = DateTime(2026, 11, 16, 10, 0);
  late GoalService goalService;

  setUp(() {
    goalService = GoalService(clock: () => now);
  });

  group('GoalService', () {
    test('NORMAL: create a goal with a valid title', () {
      final goal = goalService.createGoal(title: 'Pass Mobile Dev');
      expect(goal.title, 'Pass Mobile Dev');
      expect(goalService.goals.length, 1);
    });

    test('INVALID: empty title is not saved', () {
      expect(() => goalService.createGoal(title: ' '), throwsArgumentError);
      expect(goalService.goals.isEmpty, true);
    });

    test('INVALID: getting a goal that does not exist', () {
      expect(() => goalService.getGoal('g999'), throwsStateError);
    });

    test('SPECIAL: goal with no tasks shows 0 / 0 (0%)', () {
      final goal = goalService.createGoal(title: 'Empty');
      expect(goalService.progressText(goal.id), '0 / 0 (0%)');
    });
  });
}