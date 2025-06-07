import 'prestige.dart';

class GameState {
  int mealsServed;
  int milestoneIndex;
  final Prestige prestige;

  GameState({this.mealsServed = 0, this.milestoneIndex = 0, Prestige? prestige})
      : prestige = prestige ?? Prestige();

  static const List<String> milestones = [
    'Street Food',
    'Local Diner',
    'Chain Store',
    'Global Brand',
    'Space Empire',
    'Endgame'
  ];

  static const List<int> milestoneGoals = [10, 50, 150, 300, 600, 1000];

  String get currentMilestone => milestones[milestoneIndex];

  bool get atFinalMilestone => milestoneIndex >= milestones.length - 1;

  void cook() {
    mealsServed += prestige.multiplier.ceil();
    if (!atFinalMilestone && mealsServed >= milestoneGoals[milestoneIndex]) {
      milestoneIndex++;
      mealsServed = 0;
    }
  }

  void resetProgress() {
    mealsServed = 0;
    milestoneIndex = 0;
  }

  void prestigeUp() {
    if (atFinalMilestone) {
      prestige.gainPoint();
      resetProgress();
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
