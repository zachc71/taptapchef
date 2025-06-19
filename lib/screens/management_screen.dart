import 'package:flutter/material.dart';
import '../models/upgrade.dart';
import '../models/staff.dart';
import '../controllers/game_controller.dart';
import '../widgets/upgrade_panel.dart';
import '../widgets/staff_panel.dart';
import '../constants/panels.dart';

/// Screen for purchasing upgrades and hiring staff.
class ManagementScreen extends StatelessWidget {
  final GameController controller;
  final void Function(Upgrade, int) purchaseUpgrade;
  final void Function(StaffType, int) hireStaff;

  const ManagementScreen({
    super.key,
    required this.controller,
    required this.purchaseUpgrade,
    required this.hireStaff,
  });

  @override
  Widget build(BuildContext context) {
    final availableStaff =
        staffByTier[controller.game.milestoneIndex] ?? {};
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpgradePanel(
              upgrades: controller.upgrades,
              currency: controller.coins,
              onPurchase: purchaseUpgrade,
              title: upgradePanelTitles[controller.game.milestoneIndex],
            ),
            const SizedBox(height: 16),
            StaffPanel(
              staff: availableStaff,
              hired: controller.hiredStaff,
              coins: controller.coins,
              onHire: hireStaff,
              title: hirePanelTitles[controller.game.milestoneIndex],
            ),
          ],
        ),
      ),
    );
  }
}
