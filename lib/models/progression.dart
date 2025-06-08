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
];
