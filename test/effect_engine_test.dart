import 'package:flutter_test/flutter_test.dart';
import 'package:taptapchef/controllers/effect_engine.dart';
import 'package:taptapchef/models/game_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('event rewards are multiplied by equipped artifacts', () {
    final game = GameState();
    game.equippedArtifactIds[0] = 'lucky_ladle';
    final engine = EffectEngine(game);
    expect(engine.calculateEventReward(100), 150);
  });

  test('golden meal effects combine correctly', () {
    final game = GameState();
    game.equippedArtifactIds[0] = 'golden_spatula';
    game.equippedArtifactIds[1] = 'gold_plated_plate';
    final engine = EffectEngine(game);
    expect(engine.adjustGoldenMealChance(0.05), closeTo(0.06, 0.0001));
    expect(engine.calculateGoldenMealReward(10), 20);
  });

  test('first purchases and staff restriction flags', () {
    final game = GameState();
    game.equippedArtifactIds[0] = 'suppliers_handshake';
    game.equippedArtifactIds[1] = 'minimalist_menu';
    final engine = EffectEngine(game);
    expect(engine.totalFreePurchases(), 10);
    expect(engine.singleStaffTypeOnly, isTrue);
  });

  test('tap triggers passive progress seconds', () {
    final game = GameState();
    game.equippedArtifactIds[0] = 'head_chef_loudspeaker';
    final engine = EffectEngine(game);
    expect(engine.calculateTapPassiveSeconds(0), 300);
  });
}
