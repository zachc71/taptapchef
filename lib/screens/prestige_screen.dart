import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../widgets/franchise_hq.dart';
import '../widgets/progression_sheet.dart';

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
          const Text(
            'Prestige resets your restaurant in exchange for Franchise Tokens, which unlock permanent upgrades.',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.business),
              const SizedBox(width: 4),
              Text('Tokens: ${controller.game.franchiseTokens}'),
              const SizedBox(width: 4),
              const Tooltip(
                message:
                    'Franchise Tokens unlock permanent upgrades that persist after prestiging.',
                child: Icon(Icons.info_outline, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 400,
                  child: ProgressionSheet(
                    currentTier: controller.game.milestoneIndex,
                    currentProgress: controller.game.mealsServed,
                  ),
                ),
              );
            },
            child: const Text('View Progression'),
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
