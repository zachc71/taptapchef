import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptapchef/controllers/game_controller.dart';
import 'package:taptapchef/models/game_state.dart';
import 'package:taptapchef/models/staff.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('franchise resets progress and grants artifact', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = GameController();
    controller.game.milestoneIndex = GameState.milestones.length - 1;
    controller.coins = 100;
    controller.perTap = 10;
    controller.hiredStaff[StaffType.tacoFlipper] = 2;
    controller.upgrades.first.owned = 1;

    await controller.franchise();

    expect(controller.coins, 0);
    expect(controller.perTap, 1);
    expect(controller.hiredStaff, isEmpty);
    expect(controller.upgrades.every((u) => u.owned == 0), isTrue);
    expect(controller.game.milestoneIndex, 0);
    expect(controller.game.ownedArtifactIds.length, 1);
  });
}
