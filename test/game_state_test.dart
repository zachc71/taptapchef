import 'package:flutter_test/flutter_test.dart';
import 'package:taptapchef/models/game_state.dart';

void main() {
  test('milestone progresses when goal reached', () {
    final game = GameState();
    for (var i = 0; i < GameState.milestoneGoals[0]; i++) {
      game.cook();
    }
    expect(game.milestoneIndex, 1);
    expect(game.mealsServed, 0);
  });
}
