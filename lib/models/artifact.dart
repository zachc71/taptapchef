// Defines Artifact data model and list of game artifacts.

enum ArtifactEffectType {
  // Positive Effects
  tapValueMultiplier,
  staffSpeedMultiplier,
  passiveIncomeMultiplier,
  offlineEarningsMultiplier,
  upgradeCostMultiplier,
  eventRewardMultiplier,
  goldenMealChance,
  goldenMealMultiplier,
  firstPurchasesFree,
  tapTriggerPassiveSeconds,

  // Negative Effects (or additional multipliers)
  tapValueDebuff,
  staffCostMultiplier,
  purchaseCostMultiplier,
  staffEffectivenessDebuff,
  singleStaffTypeOnly,
}

class ArtifactEffect {
  final ArtifactEffectType type;
  final double value;

  const ArtifactEffect({required this.type, required this.value});
}

class Artifact {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final ArtifactEffect bonus;
  final ArtifactEffect drawback;

  const Artifact({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.bonus,
    required this.drawback,
  });
}

final Map<String, Artifact> gameArtifacts = {
  'quantum_oven': const Artifact(
    id: 'quantum_oven',
    name: 'Quantum Oven',
    description:
        'Cooks faster than the speed of light, but requires expensive maintenance contracts.',
    iconAsset: 'assets/icons/quantum_oven.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.staffSpeedMultiplier, value: 1.5),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.staffCostMultiplier, value: 1.25),
  ),
  'bottomless_pot': const Artifact(
    id: 'bottomless_pot',
    name: 'Bottomless Pot',
    description: 'Endless stew means endless profits... if you never tap again.',
    iconAsset: 'assets/icons/bottomless_pot.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.passiveIncomeMultiplier, value: 3.0),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.tapValueDebuff, value: 0.0),
  ),
  'ever_sharp_knife': const Artifact(
    id: 'ever_sharp_knife',
    name: 'Ever-Sharp Knife',
    description:
        'Slices through ingredients and expectations alike, but leaves the crew sluggish.',
    iconAsset: 'assets/icons/ever_sharp_knife.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.tapValueMultiplier, value: 2.0),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.staffSpeedMultiplier, value: 0.5),
  ),
  'golden_spatula': const Artifact(
    id: 'golden_spatula',
    name: 'Golden Spatula',
    description:
        'Occasionally flips a meal worth a fortune, but weighs down your usual flips.',
    iconAsset: 'assets/icons/golden_spatula.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.goldenMealChance, value: 0.01),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.tapValueDebuff, value: 0.75),
  ),
  'caffeinated_coffee_machine': const Artifact(
    id: 'caffeinated_coffee_machine',
    name: 'Caffeinated Coffee Machine',
    description: 'Your crew never sleeps, but they demand triple overtime pay.',
    iconAsset: 'assets/icons/caffeinated_coffee_machine.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.staffSpeedMultiplier, value: 2.0),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.staffCostMultiplier, value: 2.0),
  ),
  'minimalist_menu': const Artifact(
    id: 'minimalist_menu',
    name: 'Minimalist Menu',
    description:
        'Streamlined offerings save on upgrades, but limit your hiring choices.',
    iconAsset: 'assets/icons/minimalist_menu.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.upgradeCostMultiplier, value: 0.5),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.singleStaffTypeOnly, value: 1),
  ),
  'suppliers_handshake': const Artifact(
    id: 'suppliers_handshake',
    name: "Supplier's Handshake",
    description:
        'A friendly deal gives early freebies, but costs rise afterward.',
    iconAsset: 'assets/icons/suppliers_handshake.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.firstPurchasesFree, value: 10),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.purchaseCostMultiplier, value: 1.15),
  ),
  'time_dilation_pantry': const Artifact(
    id: 'time_dilation_pantry',
    name: 'Time-Dilation Pantry',
    description:
        'Stores ingredients across timelines while slowing current productivity.',
    iconAsset: 'assets/icons/time_dilation_pantry.png',
    bonus: ArtifactEffect(
        type: ArtifactEffectType.offlineEarningsMultiplier, value: 3.0),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.tapValueMultiplier, value: 0.7),
  ),
  'lucky_ladle': const Artifact(
    id: 'lucky_ladle',
    name: 'Lucky Ladle',
    description:
        'Stirs up richer events but siphons a portion of your slow simmer.',
    iconAsset: 'assets/icons/lucky_ladle.png',
    bonus:
        ArtifactEffect(type: ArtifactEffectType.eventRewardMultiplier, value: 1.5),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.passiveIncomeMultiplier, value: 0.8),
  ),
  'head_chef_loudspeaker': const Artifact(
    id: 'head_chef_loudspeaker',
    name: "Head Chef's Loudspeaker",
    description:
        'Motivates the kitchen with periodic windfalls, but tapping alone earns nothing.',
    iconAsset: 'assets/icons/head_chef_loudspeaker.png',
    bonus: ArtifactEffect(
        type: ArtifactEffectType.tapTriggerPassiveSeconds, value: 300),
    drawback:
        ArtifactEffect(type: ArtifactEffectType.tapValueDebuff, value: 0.0),
  ),
};
