import 'dart:math';

class Upgrade {
  final String name;
  final int baseCost;
  final int effect; // how much perTap increases per purchase

  /// Number of times this upgrade has been purchased.
  int owned;

  Upgrade({
    required this.name,
    required this.baseCost,
    required this.effect,
    this.owned = 0,
  });

  int get cost => (baseCost * pow(1.15, owned)).ceil();
}

/// Templates of upgrades available for each progression tier.
///
/// The lists here should not be mutated directly. When a tier is unlocked,
/// create fresh [Upgrade] instances based on these templates so that ownership
/// counts remain local to the player's state.
final Map<int, List<Upgrade>> upgradesByTier = {
 0: [
    Upgrade(name: 'Better Grill', baseCost: 150, effect: 2),
    Upgrade(name: 'Heat Lamps', baseCost: 375, effect: 2),
    Upgrade(name: 'Bigger Condiment Station', baseCost: 750, effect: 4),
  ],
  1: [
    Upgrade(name: 'Jukebox', baseCost: 1500, effect: 4),
    Upgrade(name: 'Milkshake Machine', baseCost: 3000, effect: 6),
    Upgrade(name: 'Comfier Booths', baseCost: 6000, effect: 4),
  ],
  2: [
    Upgrade(name: 'Corporate Training', baseCost: 12500, effect: 6),
    Upgrade(name: 'Supply Chain Logistics', baseCost: 25000, effect: 10),
    Upgrade(name: 'Automated Drive-Thru', baseCost: 50000, effect: 16),
  ],
  3: [
    Upgrade(name: 'Global Advertising', baseCost: 100000, effect: 20),
    Upgrade(name: 'Celebrity Chef Partnership', baseCost: 200000, effect: 24),
    Upgrade(name: 'International Logistics', baseCost: 400000, effect: 30),
  ],
  4: [
    Upgrade(name: 'Zero-G Kitchens', baseCost: 750000, effect: 40),
    Upgrade(name: 'Alien Ingredient Contracts', baseCost: 1500000, effect: 60),
    Upgrade(name: 'Hyperdrive Delivery', baseCost: 3000000, effect: 90),
  ],
  5: [
    Upgrade(name: 'Singularity Stove', baseCost: 5000000, effect: 120),
    Upgrade(name: 'Quantum Spice Rack', baseCost: 7500000, effect: 160),
    Upgrade(name: 'AI Gourmet Designer', baseCost: 10000000, effect: 200),
  ],
  6: [
    Upgrade(name: 'Time Dilation Oven', baseCost: 12500000, effect: 240),
    Upgrade(name: 'Chrono Shift Staff', baseCost: 17500000, effect: 320),
    Upgrade(name: 'Paradox Inventory', baseCost: 25000000, effect: 400),
  ],
  7: [
    Upgrade(name: 'Dimensional Dining Room', baseCost: 40000000, effect: 500),
    Upgrade(name: 'Infinite Menu Generator', baseCost: 50000000, effect: 600),
    Upgrade(name: 'Reality Distortion Service', baseCost: 60000000, effect: 700),
  ],
  8: [
    Upgrade(name: 'Quantum Entanglement Oven', baseCost: 70000000, effect: 800),
    Upgrade(name: 'Dark Matter Marinade', baseCost: 90000000, effect: 900),
    Upgrade(name: 'Teleport Delivery', baseCost: 110000000, effect: 1000),
  ],
  9: [
    Upgrade(name: 'Cosmic Catering', baseCost: 140000000, effect: 1100),
    Upgrade(name: 'Galaxy Infusion Lab', baseCost: 170000000, effect: 1200),
    Upgrade(name: 'Gravity-Free Dining', baseCost: 200000000, effect: 1300),
  ],
  10: [
    Upgrade(name: 'Reality Rewrite Kitchen', baseCost: 250000000, effect: 1400),
    Upgrade(name: 'Omniversal Reservations', baseCost: 300000000, effect: 1600),
    Upgrade(name: 'Existence Flavour Enhancer', baseCost: 375000000, effect: 1800),
  ],
};

/// Creates a deep copy of the upgrade list for the given [tier].
List<Upgrade> upgradesForTier(int tier) {
  final templates = upgradesByTier[tier] ?? const [];
  return templates
      .map((u) => Upgrade(name: u.name, baseCost: u.baseCost, effect: u.effect))
      .toList();
}
