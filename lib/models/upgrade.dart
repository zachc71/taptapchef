import 'dart:math';

/// Represents a player‑purchasable upgrade that increases the tap value.
///
/// Each upgrade now has a configurable [growthRate] that controls how
/// dramatically its cost increases with each purchase. Early tiers can use
/// smaller growth rates (e.g. 1.07) for smoother early progression, while
/// later tiers may use larger values (e.g. 1.14–1.15) to slow late‑game
/// progress. This makes tuning the economy as simple as adjusting the
/// growthRate values in the [upgradesByTier] map below.
class Upgrade {
  final String name;
  final int baseCost;
  final int effect; // how much perTap increases per purchase
  final double growthRate;

  /// Number of times this upgrade has been purchased.
  int owned;

  Upgrade({
    required this.name,
    required this.baseCost,
    required this.effect,
    this.growthRate = 1.15,
    this.owned = 0,
  });

  /// Calculates the cost of the next purchase using an exponential curve.
  ///
  /// The cost grows according to [growthRate] raised to the power of
  /// [owned], multiplied by [baseCost]. Costs are rounded up to the nearest
  /// integer. See 【450356708172989†L207-L219】 for why exponential cost curves
  /// help maintain a satisfying idle‑game progression.
  int get cost => (baseCost * pow(growthRate, owned)).ceil();
}

/// Templates of upgrades available for each progression tier.
///
/// Each entry defines the upgrade name, base cost, tap increase and a
/// growth rate. Growth rates start low in the early game and gradually
/// increase in later tiers to slow down progression. Adjust these values
/// during balancing to fine‑tune the game’s pacing.
final Map<int, List<Upgrade>> upgradesByTier = {
  0: [
    Upgrade(name: 'Better Grill', baseCost: 150, effect: 2, growthRate: 1.07),
    Upgrade(name: 'Heat Lamps', baseCost: 375, effect: 2, growthRate: 1.07),
    Upgrade(name: 'Bigger Condiment Station', baseCost: 750, effect: 4, growthRate: 1.07),
  ],
  1: [
    Upgrade(name: 'Jukebox', baseCost: 1500, effect: 4, growthRate: 1.08),
    Upgrade(name: 'Milkshake Machine', baseCost: 3000, effect: 6, growthRate: 1.08),
    Upgrade(name: 'Comfier Booths', baseCost: 6000, effect: 4, growthRate: 1.08),
  ],
  2: [
    Upgrade(name: 'Corporate Training', baseCost: 12500, effect: 6, growthRate: 1.09),
    Upgrade(name: 'Supply Chain Logistics', baseCost: 25000, effect: 10, growthRate: 1.09),
    Upgrade(name: 'Automated Drive-Thru', baseCost: 50000, effect: 16, growthRate: 1.09),
  ],
  3: [
    Upgrade(name: 'Global Advertising', baseCost: 100000, effect: 20, growthRate: 1.10),
    Upgrade(name: 'Celebrity Chef Partnership', baseCost: 200000, effect: 24, growthRate: 1.10),
    Upgrade(name: 'International Logistics', baseCost: 400000, effect: 30, growthRate: 1.10),
  ],
  4: [
    Upgrade(name: 'Zero-G Kitchens', baseCost: 750000, effect: 40, growthRate: 1.11),
    Upgrade(name: 'Alien Ingredient Contracts', baseCost: 1500000, effect: 60, growthRate: 1.11),
    Upgrade(name: 'Hyperdrive Delivery', baseCost: 3000000, effect: 90, growthRate: 1.11),
  ],
  5: [
    Upgrade(name: 'Singularity Stove', baseCost: 5000000, effect: 120, growthRate: 1.12),
    Upgrade(name: 'Quantum Spice Rack', baseCost: 7500000, effect: 160, growthRate: 1.12),
    Upgrade(name: 'AI Gourmet Designer', baseCost: 10000000, effect: 200, growthRate: 1.12),
  ],
  6: [
    Upgrade(name: 'Time Dilation Oven', baseCost: 12500000, effect: 240, growthRate: 1.13),
    Upgrade(name: 'Chrono Shift Staff', baseCost: 17500000, effect: 320, growthRate: 1.13),
    Upgrade(name: 'Paradox Inventory', baseCost: 25000000, effect: 400, growthRate: 1.13),
  ],
  7: [
    Upgrade(name: 'Dimensional Dining Room', baseCost: 40000000, effect: 500, growthRate: 1.14),
    Upgrade(name: 'Infinite Menu Generator', baseCost: 50000000, effect: 600, growthRate: 1.14),
    Upgrade(name: 'Reality Distortion Service', baseCost: 60000000, effect: 700, growthRate: 1.14),
  ],
  8: [
    Upgrade(name: 'Quantum Entanglement Oven', baseCost: 70000000, effect: 800, growthRate: 1.15),
    Upgrade(name: 'Dark Matter Marinade', baseCost: 90000000, effect: 900, growthRate: 1.15),
    Upgrade(name: 'Teleport Delivery', baseCost: 110000000, effect: 1000, growthRate: 1.15),
  ],
  9: [
    Upgrade(name: 'Cosmic Catering', baseCost: 140000000, effect: 1100, growthRate: 1.15),
    Upgrade(name: 'Galaxy Infusion Lab', baseCost: 170000000, effect: 1200, growthRate: 1.15),
    Upgrade(name: 'Gravity-Free Dining', baseCost: 200000000, effect: 1300, growthRate: 1.15),
  ],
  10: [
    Upgrade(name: 'Reality Rewrite Kitchen', baseCost: 250000000, effect: 1400, growthRate: 1.15),
    Upgrade(name: 'Omniversal Reservations', baseCost: 300000000, effect: 1600, growthRate: 1.15),
    Upgrade(name: 'Existence Flavour Enhancer', baseCost: 375000000, effect: 1800, growthRate: 1.15),
  ],
};

/// Creates a deep copy of the upgrade list for the given [tier].
///
/// This prevents modifications to the template definitions when upgrades are
/// purchased. Each copy carries over the same name, baseCost, effect and
/// growthRate fields but resets the `owned` count to zero.
List<Upgrade> upgradesForTier(int tier) {
  final templates = upgradesByTier[tier] ?? const [];
  return templates
      .map((u) => Upgrade(
            name: u.name,
            baseCost: u.baseCost,
            effect: u.effect,
            growthRate: u.growthRate,
          ))
      .toList();
}
