import 'progression.dart';

class GameState {
  int mealsServed;
  int _tierIndex;

  GameState({this.mealsServed = 0}) : _tierIndex = 0;

  ProgressionTier get currentTier => progressionTiers[_tierIndex];

  ProgressionTier? get nextTier =>
      _tierIndex + 1 < progressionTiers.length
          ? progressionTiers[_tierIndex + 1]
          : null;

  void cookMeal() {
    mealsServed++;
    _checkForTierUnlock();
  }

  void _checkForTierUnlock() {
    final next = nextTier;
    if (next != null && mealsServed >= next.unlockRequirement) {
      _tierIndex++;
    }
  }
}
