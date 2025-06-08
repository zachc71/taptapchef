import 'package:flutter/material.dart';
import '../models/prestige.dart';

class PrestigeSheet extends StatelessWidget {
  final List<PrestigeUpgrade> upgrades;
  final void Function(String id) onPurchase;
  final int points;

  const PrestigeSheet({
    super.key,
    required this.upgrades,
    required this.onPurchase,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: upgrades.map((upgrade) {
        final canBuy = points >= upgrade.cost && !upgrade.purchased;
        return ListTile(
          title: Text(upgrade.name),
          subtitle: Text('${upgrade.description} - Cost: ${upgrade.cost} PP'),
          trailing: upgrade.purchased
              ? const Icon(Icons.check, color: Colors.green)
              : ElevatedButton(
                  onPressed: canBuy ? () => onPurchase(upgrade.id) : null,
                  child: const Text('Buy'),
                ),
        );
      }).toList(),
    );
  }
}
