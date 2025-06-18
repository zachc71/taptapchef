import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../widgets/franchise_hq.dart';

/// Screen for managing prestige actions and upgrades.
class PrestigeScreen extends StatelessWidget {
  final GameController controller;
  final Future<void> Function() onConfirmDeal;

  const PrestigeScreen({
    super.key,
    required this.controller,
    required this.onConfirmDeal,
  });

  @override
  Widget build(BuildContext context) {
    final canDeal = controller.game.atFinalMilestone;
    final tokens = 1 + (controller.game.mealsServed ~/ 1000);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business),
              const SizedBox(width: 4),
              Text('Tokens: ${controller.game.franchiseTokens}')
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: canDeal ? onConfirmDeal : null,
            child: Text(
              canDeal
                  ? 'Sign Deal for $tokens Tokens'
                  : 'Reach Final Milestone to Unlock',
            ),
          ),
          const Divider(),
          FranchiseHQ(
            game: controller.game,
            onPurchase: (id) {
              controller.game.purchasePrestigeUpgrade(id);
            },
          ),
        ],
      ),
    );
  }
}
