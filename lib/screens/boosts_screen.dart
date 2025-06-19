import 'package:flutter/material.dart';
import '../widgets/artifact_pantry.dart';
import '../widgets/ad_reward_sheet.dart';
import '../controllers/game_controller.dart';

/// Screen for ad rewards and artifact management.
class BoostsScreen extends StatefulWidget {
  final GameController controller;
  final Future<bool> Function() watchAd;

  const BoostsScreen({
    super.key,
    required this.controller,
    required this.watchAd,
  });

  @override
  State<BoostsScreen> createState() => _BoostsScreenState();
}

class _BoostsScreenState extends State<BoostsScreen>
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

  Future<void> _rewardFiveMin() async {
    final ok = await widget.watchAd();
    if (ok) widget.controller.startAdBoost();
  }

  Future<void> _rewardCoins() async {
    final ok = await widget.watchAd();
    if (ok) widget.controller.addCoins(100);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Rewards'),
            Tab(text: 'The Pantry'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                children: [
                  AdRewardSheet(
                    onFiveMin: _rewardFiveMin,
                    onCoins: _rewardCoins,
                  ),
                  ListTile(
                    leading: const Icon(Icons.mood),
                    title: const Text('Rip a Joint'),
                    onTap: widget.controller.startRipMode,
                  ),
                ],
              ),
              ArtifactPantry(game: widget.controller.game),
            ],
          ),
        ),
      ],
    ));
  }
}
