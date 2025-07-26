import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../services/effect_service.dart';
import '../models/game_state.dart';
import '../services/storage.dart';
import 'game_controller.dart' as base;

/// Extended game controller that adds golden meal support on top of the
/// existing TapTapChef logic.  It schedules golden meal spawns at the
/// same interval as the regular special event and rewards players with
/// large payouts when the golden meal is tapped.
class GameControllerWithGoldenMeal extends base.GameController {
  GameControllerWithGoldenMeal({GameState? state, StorageService? storage})
      : super(state: state, storage: storage);

  /// Whether a golden meal is currently visible on screen.  The UI should
  /// react to this by showing a special icon or overlay.
  bool goldenMealVisible = false;

  /// Override the standard start method to schedule golden meal spawns in
  /// addition to existing timers.  Golden meals share the same 20 second
  /// interval as the normal star event but use a much smaller probability.
  @override
  void start() {
    super.start();
    // Reuse the special timer to periodically attempt spawning a golden meal.
    // A separate timer could also be used if a different cadence is desired.
    _goldenMealTimer = Timer.periodic(const Duration(seconds: 20), (_) => _spawnGoldenMeal());
  }

  Timer? _goldenMealTimer;
  /// Spawn a golden meal with a small base probability plus bonuses from
  /// equipped artifacts.  The chance is clamped between 0 and 1.  Only one
  /// special event (star or golden meal) may be visible at a time.
  void _spawnGoldenMeal() {
    if (goldenMealVisible || specialVisible) return;
    // Base 1 % chance plus artifact bonuses.
    final baseChance = 0.01;
    final totalChance = (baseChance + effectService.goldenMealChance).clamp(0.0, 1.0);
    if (Random().nextDouble() < totalChance) {
      goldenMealVisible = true;
      // Hide the golden meal after 10 seconds if not tapped.
      Timer(const Duration(seconds: 10), () {
        goldenMealVisible = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  /// Called when the player taps the golden meal.  Grants a large coin
  /// reward based on the tap value and the golden meal multiplier.  Hides
  /// the golden meal afterwards.
  void rewardGoldenMeal() {
    if (!goldenMealVisible) return;
    // Compute base reward as 100 times the current tap value.
    final baseReward = effectService.calculateTapValue(perTap.toDouble()) * 100;
    final reward = (baseReward * effectService.goldenMealMultiplier).toInt();
    addCoins(reward);
    goldenMealVisible = false;
    notifyListeners();
  }

  /// Clean up timers when disposing the controller.
  @override
  void dispose() {
    _goldenMealTimer?.cancel();
    super.dispose();
  }
}
