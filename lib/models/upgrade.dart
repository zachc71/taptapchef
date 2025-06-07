class Upgrade {
  final String name;
  final int cost;
  final int effect; // how much perTap increases
  bool purchased;

  Upgrade({
    required this.name,
    required this.cost,
    required this.effect,
    this.purchased = false,
  });
}
