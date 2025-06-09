class PrestigeUpgrade {
  final String id;
  final String name;
  final String description;
  final int maxLevel;
  final int baseCost;
  final double costMultiplier;

  PrestigeUpgrade({
    required this.id,
    required this.name,
    required this.description,
    this.maxLevel = 10,
    this.baseCost = 1,
    this.costMultiplier = 1.5,
  });

  int getCost(int currentLevel) {
    if (currentLevel >= maxLevel) return -1;
    return (baseCost * (costMultiplier * currentLevel)).ceil() + baseCost;
  }
}

final Map<String, PrestigeUpgrade> prestigeUpgrades = {
  'michelin_star': PrestigeUpgrade(
    id: 'michelin_star',
    name: 'Michelin Star Training',
    description: '+10% to all profits per level.',
    maxLevel: 20,
    baseCost: 1,
    costMultiplier: 1.2,
  ),
  'celeb_endorsement': PrestigeUpgrade(
    id: 'celeb_endorsement',
    name: 'Celebrity Chef Endorsement',
    description: 'Start every new Franchise with the first 2 staff members already hired.',
    maxLevel: 1,
    baseCost: 10,
  ),
  'ghost_kitchens': PrestigeUpgrade(
    id: 'ghost_kitchens',
    name: 'Ghost Kitchens',
    description: 'Retain 5% of your previous Franchise\'s passive income per level.',
    maxLevel: 5,
    baseCost: 5,
    costMultiplier: 2.0,
  ),
};
