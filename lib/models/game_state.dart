import 'package:flutter/foundation.dart';

import 'prestige.dart';
import 'franchise_location.dart';
import 'prestige_upgrade.dart';

class GameState extends ChangeNotifier {
  int mealsServed;
  int milestoneIndex;
  final Prestige prestige;
  int franchiseTokens = 0;
  int locationSetIndex = 0;
  Map<String, int> purchasedPrestigeUpgrades = {};
  List<String> ownedArtifactIds = [];
  List<String?> equippedArtifactIds = [null, null, null];

  int get locationTierIndex =>
      (milestoneIndex * franchiseTiers.length) ~/ milestones.length;

  FranchiseLocation get currentLocation => franchiseLocationSets[
          locationSetIndex % franchiseLocationSets.length]
      [locationTierIndex];

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

  static const List<int> baseMilestoneGoals = [
    4800,
    24000,
    72000,
    144000,
    288000,
    480000,
    960000,
    2400000
  ];

  /// Returns the milestone goal for [index] taking prestige bonuses into
  /// account. After the player has franchised at least once, goals are
  /// dramatically reduced to allow very quick progress through early tiers.
  int milestoneGoalAt(int index) {
    final base = baseMilestoneGoals[index];
    final scale = franchiseTokens > 0 ? 0.02 : 1.0;
    return (base * scale).ceil();
  }

  int get currentMilestoneGoal => milestoneGoalAt(milestoneIndex);

  String get currentMilestone => milestones[milestoneIndex];

  bool get atFinalMilestone => milestoneIndex >= milestones.length - 1;

  void cook() {
    mealsServed += prestige.multiplier.ceil();
    if (!atFinalMilestone && mealsServed >= currentMilestoneGoal) {
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
      locationSetIndex =
          (locationSetIndex + 1) % franchiseLocationSets.length;
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

  void equipArtifact(String artifactId, int slotIndex) {
    if (ownedArtifactIds.contains(artifactId) &&
        slotIndex < equippedArtifactIds.length) {
      if (equippedArtifactIds.contains(artifactId)) return;
      equippedArtifactIds[slotIndex] = artifactId;
      notifyListeners();
    }
  }

  void unequipArtifact(int slotIndex) {
    if (slotIndex < equippedArtifactIds.length) {
      equippedArtifactIds[slotIndex] = null;
      notifyListeners();
    }
  }
}
