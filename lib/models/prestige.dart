class Prestige {
  int points;
  final double baseMultiplier;
  final double increment;

  Prestige({this.points = 0, this.baseMultiplier = 1.0, this.increment = 0.5});

  double get multiplier => baseMultiplier + points * increment;

  void gainPoint() {
    points += 1;
  }
}
