import 'package:flutter/foundation.dart';

import 'prestige.dart';

class GameState extends ChangeNotifier {
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
    'Endgame',
    'Time Warp Kitchen',
    'Multiverse Franchise'
  ];

  static const List<int> milestoneGoals = [
    300,
    1500,
    4500,
    9000,
    18000,
    30000,
    60000,
    150000
  ];

  String get currentMilestone => milestones[milestoneIndex];

  bool get atFinalMilestone => milestoneIndex >= milestones.length - 1;

  void cook() {
    mealsServed += prestige.multiplier.ceil();
    if (!atFinalMilestone && mealsServed >= milestoneGoals[milestoneIndex]) {
      milestoneIndex++;
      mealsServed = 0;
    }
    notifyListeners();
  }

  void resetProgress() {
    mealsServed = 0;
    milestoneIndex = 0;
    notifyListeners();
  }

  void prestigeUp() {
    if (atFinalMilestone) {
      prestige.gainPoint();
      resetProgress();
    }
  }
}
