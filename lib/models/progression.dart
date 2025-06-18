class ProgressionTier {
  final String name;
  final int unlockRequirement; // meals served needed
  final String reward;

  const ProgressionTier({
    required this.name,
    required this.unlockRequirement,
    required this.reward,
  });
}

const List<ProgressionTier> progressionTiers = [
  ProgressionTier(
    name: 'Street Food',
    unlockRequirement: 0,
    reward: 'Base tapper + 3 upgrades',
  ),
  ProgressionTier(
    name: 'Local Diner',
    unlockRequirement: 300,
    reward: 'Hire staff, new backgrounds',
  ),
  ProgressionTier(
    name: 'Chain Store',
    unlockRequirement: 3000,
    reward: 'Idle income boosts + ad system',
  ),
  ProgressionTier(
    name: 'Global Brand',
    unlockRequirement: 15000,
    reward: 'Prestige system, new tech upgrades',
  ),
  ProgressionTier(
    name: 'Space Empire',
    unlockRequirement: 60000,
    reward: 'Intergalactic cuisine, absurd boosts',
  ),
  ProgressionTier(
    name: 'Endgame',
    unlockRequirement: 300000,
    reward: 'Black hole catering, existential AI',
  ),
  ProgressionTier(
    name: 'Time Warp Kitchen',
    unlockRequirement: 600000,
    reward: 'Temporal upgrades, time-loop menus',
  ),
  ProgressionTier(
    name: 'Multiverse Franchise',
    unlockRequirement: 1200000,
    reward: 'Reality-hopping logistics',
  ),
  ProgressionTier(
    name: 'Quantum Cafeteria',
    unlockRequirement: 2400000,
    reward: 'Particles serve themselves',
  ),
  ProgressionTier(
    name: 'Cosmic Supperclub',
    unlockRequirement: 4800000,
    reward: 'Guests arrive from lightyears away',
  ),
  ProgressionTier(
    name: 'Omniversal Eatery',
    unlockRequirement: 9600000,
    reward: 'Reality itself is on the menu',
  ),
];
