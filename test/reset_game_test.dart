import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptapchef/controllers/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('resetGame clears temporary state and timers', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = GameController();

    // Simulate various active states
    controller.specialVisible = true;
    controller.startAdBoost();
    controller.ripMode = true;
    controller.ripTimer = Timer(const Duration(seconds: 1), () {});
    controller.cook(); // start combo timer

    await controller.resetGame();

    expect(controller.specialVisible, isFalse);
    expect(controller.combo, 0);
    expect(controller.frenzy, isFalse);
    expect(controller.adBoostActive, isFalse);
    expect(controller.ripMode, isFalse);

    expect(controller.comboTimer, isNull);
    expect(controller.frenzyDurationTimer, isNull);
    expect(controller.adBoostTimer, isNull);
    expect(controller.ripTimer, isNull);
  });
}
