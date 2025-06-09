import 'package:flutter/material.dart';
import '../models/staff.dart';
import 'pulse.dart';
import '../util/format.dart';

/// A panel for hiring staff using the same layout as [UpgradePanel].
class StaffPanel extends StatelessWidget {
  final Map<StaffType, Staff> staff;
  final Map<StaffType, int> hired;
  final int coins;
  final void Function(StaffType, int) onHire;
  final String title;

  const StaffPanel({
    super.key,
    required this.staff,
    required this.hired,
    required this.coins,
    required this.onHire,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...staff.keys.map((type) {
          final s = staff[type]!;
          final owned = hired[type] ?? 0;
          final bool affordable = coins >= s.cost;
          final bool affordable10 = coins >= s.cost * 10;
          final bool affordable100 = coins >= s.cost * 100;
          final int maxAffordable = coins ~/ s.cost;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(s.name,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Chip(label: Text('Hired: $owned')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16),
                      const SizedBox(width: 4),
                      Text(formatNumber(s.cost)),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer, size: 16),
                      const SizedBox(width: 4),
                      Text('${s.tapsPerSecond} tps'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Pulse(
                        active: affordable,
                        child: ElevatedButton(
                          onPressed: affordable ? () => onHire(type, 1) : null,
                          child: const Text('1'),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: affordable10 ? () => onHire(type, 10) : null,
                        child: const Text('10'),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed:
                            affordable100 ? () => onHire(type, 100) : null,
                        child: const Text('100'),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: maxAffordable > 0
                            ? () => onHire(type, maxAffordable)
                            : null,
                        child: const Text('MAX'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
