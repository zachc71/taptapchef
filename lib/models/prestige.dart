/// Types of effects a prestige upgrade can apply.
enum PrestigeUpgradeType { incomeBoost, staffUnlock, upgradeUnlock }

/// Data for a single prestige upgrade node in the tree.
class PrestigeUpgrade {
  final String id;
  final String name;
  final String description;
  final int cost;
  final PrestigeUpgradeType type;

  /// For [PrestigeUpgradeType.incomeBoost] this represents the percent bonus
  /// (e.g. `0.02` for a 2% increase). It is unused for other upgrade types but
  /// kept for potential future logic.
  final double value;

  bool purchased;

  PrestigeUpgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.type,
    this.value = 0,
    this.purchased = false,
  });
}

/// Player prestige state including owned upgrades.
class Prestige {
  int points;
  final double baseMultiplier;
  final double increment;
  final List<PrestigeUpgrade> upgrades;

  Prestige({
    this.points = 0,
    this.baseMultiplier = 1.0,
    this.increment = 0.5,
    List<PrestigeUpgrade>? upgrades,
  }) : upgrades = upgrades ?? _defaultUpgrades();

  /// Overall earnings multiplier taking purchased upgrades into account.
  double get multiplier {
    final upgradeBonus = upgrades
        .where((u) =>
            u.purchased && u.type == PrestigeUpgradeType.incomeBoost)
        .fold<double>(0, (sum, u) => sum + u.value);
    return baseMultiplier + points * increment + upgradeBonus;
  }

  /// Add a prestige point (typically earned by prestiging).
  void gainPoint() => points += 1;

  /// Attempt to purchase the upgrade with [id]. Returns `true` if successful.
  bool purchase(String id) {
    final upgrade = upgrades.firstWhere(
      (u) => u.id == id,
      orElse: () => throw ArgumentError('Unknown upgrade id: $id'),
    );
    if (upgrade.purchased || points < upgrade.cost) return false;
    points -= upgrade.cost;
    upgrade.purchased = true;
    return true;
  }

  /// Convenience getter to check if an upgrade is owned.
  bool hasUpgrade(String id) =>
      upgrades.any((u) => u.id == id && u.purchased);

  static List<PrestigeUpgrade> _defaultUpgrades() => [
        PrestigeUpgrade(
          id: 'income_2_percent',
          name: 'Better Ingredients',
          description: 'Permanent 2% boost to all income.',
          cost: 3,
          type: PrestigeUpgradeType.incomeBoost,
          value: 0.02,
        ),
        PrestigeUpgrade(
          id: 'staff_starters',
          name: 'Experienced Crew',
          description: 'Start with the first two staff members unlocked.',
          cost: 6,
          type: PrestigeUpgradeType.staffUnlock,
        ),
        PrestigeUpgrade(
          id: 'quantum_seasoning',
          name: 'Quantum Seasoning',
          description: 'Unlock the "Quantum Seasoning" upgrade.',
          cost: 15,
          type: PrestigeUpgradeType.upgradeUnlock,
        ),
      ];
}
