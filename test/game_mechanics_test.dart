import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_async/fake_async.dart';
import 'package:taptapchef/controllers/game_controller.dart';
import 'package:taptapchef/models/staff.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('combo decreases gradually after inactivity', () {
    SharedPreferences.setMockInitialValues({});
    fakeAsync((async) {
      final controller = GameController();

      for (var i = 0; i < 5; i++) {
        controller.cook();
      }

      expect(controller.combo, 5);

      async.elapse(const Duration(seconds: 1));
      expect(controller.combo, 4);

      async.elapse(const Duration(seconds: 3));
      expect(controller.combo, 1);

      async.elapse(const Duration(seconds: 1));
      expect(controller.combo, 0);
      expect(controller.comboTimer, isNull);
    });
  });

  test('frenzy activates immediately and ends after duration', () {
    SharedPreferences.setMockInitialValues({});
    fakeAsync((async) {
      final controller = GameController();

      for (var i = 0; i < GameController.comboMax; i++) {
        controller.cook();
      }

      expect(controller.combo, GameController.comboMax);
      expect(controller.frenzy, isTrue);
      expect(controller.frenzyDurationTimer, isNotNull);

      async.elapse(const Duration(seconds: 5));
      expect(controller.frenzy, isFalse);
      expect(controller.combo, 0);
    });
  });

  test('ad boost countdown expires', () {
    SharedPreferences.setMockInitialValues({});
    fakeAsync((async) {
      final controller = GameController();
      controller.startAdBoost();

      expect(controller.adBoostActive, isTrue);
      expect(controller.adBoostSeconds, 300);

      async.elapse(const Duration(seconds: 5));
      expect(controller.adBoostSeconds, 295);

      async.elapse(const Duration(seconds: 295));
      expect(controller.adBoostActive, isFalse);
      expect(controller.adBoostSeconds, 0);
    });
  });

  test('staff generate passive income over time', () {
    SharedPreferences.setMockInitialValues({});
    fakeAsync((async) {
      final controller = GameController();
      controller.hiredStaff[StaffType.tacoFlipper] = 1;
      controller.start();

      async.elapse(const Duration(seconds: 4));
      expect(controller.game.mealsServed, 1);
      expect(controller.coins, 1);

      controller.hiredStaff[StaffType.tacoFlipper] = 2;
      async.elapse(const Duration(seconds: 5));
      expect(controller.game.mealsServed, 4);
      expect(controller.coins, 4);
      expect(controller.currentTPS, closeTo(0.6, 0.01));
    });
  });
}
