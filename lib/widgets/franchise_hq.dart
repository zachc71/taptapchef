import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/franchise_location.dart';
import '../models/prestige_upgrade.dart';
import '../util/format.dart';

class FranchiseHQ extends StatelessWidget {
  final GameState game;
  final void Function(String id) onPurchase;

  const FranchiseHQ({
    super.key,
    required this.game,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final upgrades = prestigeUpgrades.values.toList();
    final locations =
        franchiseLocationSets[game.locationSetIndex % franchiseLocationSets.length];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location Progression', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...locations.map((loc) {
            final index = locations.indexOf(loc);
            String status;
            if (index < game.locationTierIndex) {
              status = 'Completed';
            } else if (index == game.locationTierIndex) {
              status = 'Current';
            } else {
              status = 'Upcoming';
            }
            return ListTile(
              leading: Image.asset(loc.artAsset, width: 40, height: 40, errorBuilder: (_, __, ___) => const SizedBox(width: 40, height: 40)),
              title: Text(loc.name),
              subtitle: Text('${loc.tierName} - $status'),
            );
          }),
          const Divider(),
          Text('Prestige Upgrades', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...upgrades.map((u) {
            final level = game.purchasedPrestigeUpgrades[u.id] ?? 0;
            final cost = u.getCost(level);
            final maxed = cost == -1;
            final canBuy = !maxed && game.franchiseTokens >= cost;
            return ListTile(
              title: Text(u.name),
              subtitle: Text('${u.description}\nLevel: $level/${u.maxLevel} - Cost: ${maxed ? 'MAX' : formatNumber(cost)}'),
              trailing: maxed
                  ? const Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                      onPressed: canBuy ? () => onPurchase(u.id) : null,
                      child: const Text('Buy'),
                    ),
            );
          })
        ],
      ),
    );
  }
}
