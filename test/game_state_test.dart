import 'package:flutter_test/flutter_test.dart';
import 'package:taptapchef/models/game_state.dart';

void main() {
  test('milestone progresses when goal reached', () {
    final game = GameState();
    for (var i = 0; i < game.milestoneGoalAt(0); i++) {
      game.cook();
    }
    expect(game.milestoneIndex, 1);
    expect(game.mealsServed, 0);
  });

  test('milestone goals scale down after franchising', () {
    final game = GameState();
    game.franchiseTokens = 1;

    final baseGoal = GameState.baseMilestoneGoals.first;
    expect(game.milestoneGoalAt(0), (baseGoal * 0.5).ceil());

    final lastBaseGoal = GameState.baseMilestoneGoals.last;
    expect(game.milestoneGoalAt(GameState.baseMilestoneGoals.length - 1),
        (lastBaseGoal * 0.5).ceil());
  });
}
