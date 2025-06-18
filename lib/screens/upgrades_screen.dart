import 'package:flutter/material.dart';
import '../widgets/upgrade_panel.dart';
import '../widgets/staff_panel.dart';
import '../controllers/game_controller.dart';
import '../constants/panels.dart';
import '../models/staff.dart';
import "../models/upgrade.dart";

/// Screen containing upgrade and staff purchase panels under two tabs.
class UpgradesScreen extends StatefulWidget {
  final GameController controller;
  final void Function(Upgrade upgrade, int qty) onPurchase;
  final void Function(StaffType type, int qty) onHire;

  const UpgradesScreen({
    super.key,
    required this.controller,
    required this.onPurchase,
    required this.onHire,
  });

  @override
  State<UpgradesScreen> createState() => _UpgradesScreenState();
}

class _UpgradesScreenState extends State<UpgradesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableStaff =
        staffByTier[widget.controller.game.milestoneIndex] ?? {};
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Kitchen'),
            Tab(text: 'Staff'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: UpgradePanel(
                  upgrades: widget.controller.upgrades,
                  currency: widget.controller.coins,
                  onPurchase: widget.onPurchase,
                  title: upgradePanelTitles[
                      widget.controller.game.milestoneIndex],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: StaffPanel(
                  staff: availableStaff,
                  hired: widget.controller.hiredStaff,
                  coins: widget.controller.coins,
                  onHire: widget.onHire,
                  title: hirePanelTitles[
                      widget.controller.game.milestoneIndex],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
