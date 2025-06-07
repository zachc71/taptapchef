import 'package:flutter/material.dart';
import '../models/upgrade.dart';

class UpgradePanel extends StatelessWidget {
  final List<Upgrade> upgrades;
  final int currency;
  final ValueChanged<Upgrade> onPurchase;

  const UpgradePanel({
    super.key,
    required this.upgrades,
    required this.currency,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: upgrades.map((u) {
        return ListTile(
          title: Text(u.name),
          subtitle: Text('Cost: \$${u.cost} - Effect: +${u.effect} per tap'),
          trailing: u.purchased
              ? const Text('Purchased')
              : ElevatedButton(
                  onPressed: currency >= u.cost ? () => onPurchase(u) : null,
                  child: const Text('Buy'),
                ),
        );
      }).toList(),
    );
  }
}
