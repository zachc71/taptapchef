import 'package:flutter_test/flutter_test.dart';
import 'package:taptapchef/models/prestige.dart';

void main() {
  test('purchase succeeds with enough points', () {
    final prestige = Prestige(points: 5);
    final success = prestige.purchase('income_2_percent');
    expect(success, isTrue);
    expect(prestige.points, 2); // cost is 3
    expect(prestige.hasUpgrade('income_2_percent'), isTrue);
  });

  test('purchase fails when insufficient points', () {
    final prestige = Prestige(points: 0);
    final success = prestige.purchase('income_2_percent');
    expect(success, isFalse);
    expect(prestige.points, 0);
    expect(prestige.hasUpgrade('income_2_percent'), isFalse);
  });
}
