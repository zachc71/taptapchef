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
  3: [
    Upgrade(name: 'Global Advertising', cost: 20000, effect: 10),
    Upgrade(name: 'Celebrity Chef Partnership', cost: 40000, effect: 12),
    Upgrade(name: 'International Logistics', cost: 80000, effect: 15),
  ],
  4: [
    Upgrade(name: 'Zero-G Kitchens', cost: 150000, effect: 20),
    Upgrade(name: 'Alien Ingredient Contracts', cost: 300000, effect: 30),
    Upgrade(name: 'Hyperdrive Delivery', cost: 600000, effect: 45),
  ],
  5: [
    Upgrade(name: 'Singularity Stove', cost: 1000000, effect: 60),
    Upgrade(name: 'Quantum Spice Rack', cost: 1500000, effect: 80),
    Upgrade(name: 'AI Gourmet Designer', cost: 2000000, effect: 100),
  ],
  6: [
    Upgrade(name: 'Time Dilation Oven', cost: 2500000, effect: 120),
    Upgrade(name: 'Chrono Shift Staff', cost: 3500000, effect: 160),
    Upgrade(name: 'Paradox Inventory', cost: 5000000, effect: 200),
  ],
  7: [
    Upgrade(name: 'Dimensional Dining Room', cost: 8000000, effect: 250),
    Upgrade(name: 'Infinite Menu Generator', cost: 10000000, effect: 300),
    Upgrade(name: 'Reality Distortion Service', cost: 12000000, effect: 350),
  ],
  8: [
    Upgrade(name: 'Quantum Entanglement Oven', cost: 14000000, effect: 400),
    Upgrade(name: 'Dark Matter Marinade', cost: 18000000, effect: 450),
    Upgrade(name: 'Teleport Delivery', cost: 22000000, effect: 500),
  ],
  9: [
    Upgrade(name: 'Cosmic Catering', cost: 28000000, effect: 550),
    Upgrade(name: 'Galaxy Infusion Lab', cost: 34000000, effect: 600),
    Upgrade(name: 'Gravity-Free Dining', cost: 40000000, effect: 650),
  ],
 10: [
    Upgrade(name: 'Reality Rewrite Kitchen', cost: 50000000, effect: 700),
    Upgrade(name: 'Omniversal Reservations', cost: 60000000, effect: 800),
    Upgrade(name: 'Existence Flavour Enhancer', cost: 75000000, effect: 900),
  ],
};

/// Creates a deep copy of the upgrade list for the given [tier].
List<Upgrade> upgradesForTier(int tier) {
  final templates = upgradesByTier[tier] ?? const [];
  return templates
      .map((u) => Upgrade(name: u.name, cost: u.cost, effect: u.effect))
      .toList();
}
