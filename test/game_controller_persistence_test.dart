import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptapchef/controllers/game_controller.dart';
import 'package:taptapchef/models/staff.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saved game restores coins, staff and upgrades', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = GameController();
    controller.coins = 42;
    controller.perTap = 3;
    controller.game.milestoneIndex = 2;
    controller.game.mealsServed = 5;
    controller.hiredStaff[StaffType.tacoFlipper] = 2;
    controller.upgrades.first.owned = 1;
    await controller.save();

    final controller2 = GameController();
    await controller2.load();

    expect(controller2.coins, 42);
    expect(controller2.perTap, 3);
    expect(controller2.hiredStaff[StaffType.tacoFlipper], 2);
    expect(controller2.upgrades.first.owned, 1);
    expect(controller2.game.milestoneIndex, 2);
    expect(controller2.game.mealsServed, 5);
  });

  test('rewardSpecial persists coin reward', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = GameController();
    await controller.rewardSpecial(2); // adds 20 coins

    final controller2 = GameController();
    await controller2.load();

    expect(controller2.coins, 20);
  });
}

