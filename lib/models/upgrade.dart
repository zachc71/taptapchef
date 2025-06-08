class Upgrade {
  final String name;
  final int cost;
  final int effect; // how much perTap increases per purchase

  /// Number of times this upgrade has been purchased.
  int owned;

  Upgrade({
    required this.name,
    required this.cost,
    required this.effect,
    this.owned = 0,
  });
}

/// Templates of upgrades available for each progression tier.
///
/// The lists here should not be mutated directly. When a tier is unlocked,
/// create fresh [Upgrade] instances based on these templates so that ownership
/// counts remain local to the player's state.
final Map<int, List<Upgrade>> upgradesByTier = {
  0: [
    Upgrade(name: 'Better Grill', cost: 30, effect: 1),
    Upgrade(name: 'Heat Lamps', cost: 75, effect: 1),
    Upgrade(name: 'Bigger Condiment Station', cost: 150, effect: 2),
  ],
  1: [
    Upgrade(name: 'Jukebox', cost: 300, effect: 2),
    Upgrade(name: 'Milkshake Machine', cost: 600, effect: 3),
    Upgrade(name: 'Comfier Booths', cost: 1200, effect: 2),
  ],
  2: [
    Upgrade(name: 'Corporate Training', cost: 2500, effect: 3),
    Upgrade(name: 'Supply Chain Logistics', cost: 5000, effect: 5),
    Upgrade(name: 'Automated Drive-Thru', cost: 10000, effect: 8),
  ],
};

/// Creates a deep copy of the upgrade list for the given [tier].
List<Upgrade> upgradesForTier(int tier) {
  final templates = upgradesByTier[tier] ?? const [];
  return templates
      .map((u) => Upgrade(name: u.name, cost: u.cost, effect: u.effect))
      .toList();
}
