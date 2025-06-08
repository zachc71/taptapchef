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
