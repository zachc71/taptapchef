import 'package:flutter/material.dart';
import '../models/upgrade.dart';
import 'pulse.dart';


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
      ...upgrades.map((u) {
        final bool affordable = currency >= u.cost;
        final bool affordable10 = currency >= u.cost * 10;
        final bool affordable100 = currency >= u.cost * 100;
        final int maxAffordable = currency ~/ u.cost;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u.name, style: Theme.of(context).textTheme.titleMedium),
                Text(
                    'Cost: \$${u.cost} - Effect: +${u.effect} per tap - Owned: ${u.owned}'),
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
                    ElevatedButton(
                      onPressed: affordable10 ? () => onPurchase(u, 10) : null,
                      child: const Text('10'),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed:
                          affordable100 ? () => onPurchase(u, 100) : null,
                      child: const Text('100'),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: maxAffordable > 0
                          ? () => onPurchase(u, maxAffordable)
                          : null,
                      child: const Text('MAX'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    ]);
  }
}
