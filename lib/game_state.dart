import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central game data managed via Riverpod using [ChangeNotifier].
class GameState extends ChangeNotifier {
  int mealsServed;
  double cash;
  int currentTier;
  int prestigePoints;

  GameState({
    this.mealsServed = 0,
    this.cash = 0,
    this.currentTier = 0,
    this.prestigePoints = 0,
  });

  /// Increment the number of meals served.
  void incrementMeals([int amount = 1]) {
    mealsServed += amount;
    notifyListeners();
  }

  /// Add [amount] of in-game currency.
  void addCash(double amount) {
    cash += amount;
    notifyListeners();
  }

  /// Spend [amount] if available.
  void spendCash(double amount) {
    if (cash >= amount) {
      cash -= amount;
      notifyListeners();
    }
  }

  /// Update the current tier.
  void setTier(int tier) {
    currentTier = tier;
    notifyListeners();
  }

  /// Increase prestige points.
  void addPrestigePoints(int points) {
    prestigePoints += points;
    notifyListeners();
  }
}

/// Global [ChangeNotifierProvider] for accessing and subscribing to
/// the [GameState] throughout the widget tree.
final ChangeNotifierProvider<GameState> gameStateProvider =
    ChangeNotifierProvider<GameState>((ref) => GameState());
