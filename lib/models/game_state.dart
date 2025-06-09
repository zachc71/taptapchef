import 'package:flutter/foundation.dart';

import 'prestige.dart';
import 'franchise_location.dart';
import 'prestige_upgrade.dart';

class GameState extends ChangeNotifier {
  int mealsServed;
  int milestoneIndex;
  final Prestige prestige;
  int franchiseTokens = 0;
  int currentLocationIndex = 0;
  Map<String, int> purchasedPrestigeUpgrades = {};

  FranchiseLocation get currentLocation =>
      franchiseProgression[currentLocationIndex];

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
    4800,
    24000,
    72000,
    144000,
    288000,
    480000,
    960000,
    2400000
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
      int tokensEarned = 1 + (mealsServed ~/ 1000);
      franchiseTokens += tokensEarned;
      currentLocationIndex =
          (currentLocationIndex + 1) % franchiseProgression.length;
      resetProgress();
    }
  }

  void purchasePrestigeUpgrade(String upgradeId) {
    final upgrade = prestigeUpgrades[upgradeId];
    if (upgrade == null) return;
    final currentLevel = purchasedPrestigeUpgrades[upgradeId] ?? 0;
    final cost = upgrade.getCost(currentLevel);
    if (cost == -1 || franchiseTokens < cost) return;
    franchiseTokens -= cost;
    purchasedPrestigeUpgrades[upgradeId] = currentLevel + 1;
    notifyListeners();
  }
}
