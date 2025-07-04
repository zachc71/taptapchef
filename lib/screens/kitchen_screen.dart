import 'package:flutter/material.dart';
import "../models/game_state.dart";
import '../controllers/game_controller.dart';
import '../util/format.dart';
import '../constants/theme.dart';

/// Main gameplay screen for tapping and viewing progress.
class KitchenScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback onAdReward;
  final VoidCallback onSettings;
  final Offset frenzyOffset;

  const KitchenScreen({
    super.key,
    required this.controller,
    required this.onAdReward,
    required this.onSettings,
    this.frenzyOffset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final bool finalStage = controller.game.atFinalMilestone;
    final int goal = finalStage ? 0 : controller.game.currentMilestoneGoal;
    final double progress =
        finalStage ? 1 : controller.game.mealsServed / goal;
    final String nextName = finalStage
        ? 'Completed'
        : GameState.milestones[controller.game.milestoneIndex + 1];

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              controller.game.currentBackground,
              key: ValueKey(controller.game.currentBackground),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Tooltip(
                          message: 'Cash',
                          child: Icon(Icons.attach_money, size: 20)),
                      const SizedBox(width: 4),
                      Text(formatNumber(controller.coins)),
                    ],
                  ),
                  Text(
                    'Idle: ${formatNumber(controller.idleIncomePerSecond.round())}/sec',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: [
                  const Tooltip(
                      message: 'Tokens', child: Icon(Icons.token, size: 20)),
                  const SizedBox(width: 4),
                  Text(formatNumber(controller.game.franchiseTokens)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: onSettings,
              ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Current Location: ${controller.game.currentLocation.name}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress),
                Text(finalStage
                    ? 'Final milestone reached'
                    : '${formatNumber(controller.game.mealsServed)}/${formatNumber(goal)} meals - ${(progress * 100).toStringAsFixed(0)}% to $nextName'),
                const SizedBox(height: 16),
                Text('Meals Served: ${formatNumber(controller.game.mealsServed)}'),
                Text('Income per Tap: ${controller.perTap}'),
            const SizedBox(height: 16),
            Center(
              child: Transform.translate(
                offset: frenzyOffset,
                child: ElevatedButton(
                  style: cookButtonStyle,
                  onPressed: controller.cook,
                  child: const Text('Cook!'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Combo: ${controller.combo}  x${controller.currentMultiplier}'),
            LinearProgressIndicator(value: controller.combo / GameController.comboMax),
            if (controller.adBoostActive)
              Text(
                  'Ad boost: ${(controller.adBoostSeconds ~/ 60).toString().padLeft(2, '0')}:${(controller.adBoostSeconds % 60).toString().padLeft(2, '0')}'),
            ElevatedButton(
              onPressed: onAdReward,
              child: const Text('Watch Ad for Rewards'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
          )],
  ),
),
      ],
    );
  }
}
