import 'dart:math';
import 'package:flutter/material.dart';
import '../models/upgrade.dart';
import 'pulse.dart';
import '../util/format.dart';


class UpgradePanel extends StatelessWidget {
  final List<Upgrade> upgrades;
  final int currency;
  final void Function(Upgrade, int) onPurchase;
  final String title;

  const UpgradePanel({
    super.key,
    required this.upgrades,
    required this.currency,
    required this.onPurchase,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      int costFor(Upgrade u, int qty) {
        double total = 0;
        for (int i = 0; i < qty; i++) {
          total += u.baseCost * pow(1.15, u.owned + i);
        }
        return total.ceil();
      }
      ...upgrades.map((u) {
        final int cost = costFor(u, 1);
        final bool affordable = currency >= cost;
        final bool affordable10 = currency >= costFor(u, 10);
        final bool affordable100 = currency >= costFor(u, 100);
        final bool highlightCard = affordable10 || affordable100;
        final card = Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: highlightCard ? Colors.green[50] : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(u.name,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Chip(label: Text('Owned: ${u.owned}')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16),
                    const SizedBox(width: 4),
                    Text(formatNumber(cost)),
                    const SizedBox(width: 12),
                    const Icon(Icons.upgrade, size: 16),
                    const SizedBox(width: 4),
                    Text('+${u.effect}/tap'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Pulse(
                      active: affordable,
                      child: ElevatedButton(
                        onPressed: affordable ? () => onPurchase(u, 1) : null,
                        child: const Text('1'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Pulse(
                      active: affordable10,
                      child: ElevatedButton(
                        onPressed: affordable10 ? () => onPurchase(u, 10) : null,
                        child: const Text('10'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Pulse(
                      active: affordable100,
                      child: ElevatedButton(
                        onPressed:
                            affordable100 ? () => onPurchase(u, 100) : null,
                        child: const Text('100'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        return TweenAnimationBuilder<double>(
          key: ValueKey(u.name),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) =>
              Opacity(opacity: value, child: child),
          child: card,
        );
      }),
    ]);
  }
}
