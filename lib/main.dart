// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/staff.dart';
import 'models/upgrade.dart';
import 'controllers/game_controller.dart';
import 'providers/game_controller_provider.dart';
import 'widgets/offline_earnings_dialog.dart';
import 'widgets/ad_reward_sheet.dart';
import 'widgets/prestige_sheet.dart';
import 'widgets/upgrade_panel.dart';
import 'widgets/staff_panel.dart';
import 'widgets/mini_game_dialog.dart';
import 'widgets/frenzy_overlay.dart';
import 'widgets/milestone_overlay.dart';
import 'models/franchise_location.dart';
import 'widgets/franchise_hq.dart';
import 'widgets/artifact_pantry.dart';
import 'widgets/progression_sheet.dart';
import 'constants/milestones.dart';
import 'constants/panels.dart';
import 'models/game_state.dart';
import 'util/format.dart';
import 'services/effect_service.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tap Tap Chef',
      home: CounterPage(),
    );
  }
}

class CounterPage extends ConsumerStatefulWidget {
  const CounterPage({super.key});

  @override
  ConsumerState<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends ConsumerState<CounterPage>
    with SingleTickerProviderStateMixin {
  late final GameController controller;
  late EffectService _effectService;
  late final AnimationController _frenzyController;
  Offset _frenzyOffset = Offset.zero;
  int _prevMilestone = 0;

  @override
  void initState() {
    super.initState();
    controller = ref.read(gameControllerProvider);
    _effectService = EffectService(controller.game);
    _frenzyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        if (controller.frenzy) {
          setState(() {
            _frenzyOffset = Offset(
              sin(_frenzyController.value * 2 * pi) * 2,
              cos(_frenzyController.value * 2 * pi) * 2,
            );
          });
        }
      });
    controller.load().then((result) async {
      if (result.earned > 0) {
        await _showOfflineEarningsDialog(result.earned);
      }
    });
    controller.start();
    _prevMilestone = controller.lastMilestoneIndex;
    controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {
      if (controller.frenzy && !_frenzyController.isAnimating) {
        _frenzyController.repeat();
      } else if (!controller.frenzy && _frenzyController.isAnimating) {
        _frenzyController.stop();
        _frenzyOffset = Offset.zero;
      }
    });
    if (_prevMilestone != controller.lastMilestoneIndex) {
      _prevMilestone = controller.lastMilestoneIndex;
      HapticFeedback.heavyImpact();
      final art = milestoneArt[controller.game.milestoneIndex];
      final dialogue = milestoneDialogues[controller.game.milestoneIndex];
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'milestone',
        barrierColor: Colors.black87,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: MilestoneOverlay(
              title: 'Milestone: ${controller.game.currentMilestone}',
              art: art,
              dialogue: dialogue,
              onContinue: () => Navigator.pop(context),
            ),
          );
        },
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(dialogue)));
    }
  }

  void _hireStaff(StaffType type, int quantity) {
    HapticFeedback.mediumImpact();
    controller.hireStaff(type, quantity);
  }

  void _cook() {
    HapticFeedback.lightImpact();
    controller.cook();
  }

  void _purchase(Upgrade upgrade, int quantity) {
    HapticFeedback.mediumImpact();
    controller.purchase(upgrade, quantity);
  }

  void _onSpecialTap() async {
    controller.hideSpecial();
    final taps = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const MiniGameDialog(),
        ) ??
        0;
    await controller.rewardSpecial(taps);
  }

  Future<void> _showOfflineEarningsDialog(int earned) async {
    HapticFeedback.selectionClick();
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'offline',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
          child: OfflineEarningsDialog(
            earned: earned,
            onClose: () => Navigator.pop(context),
            onDouble: () async {
              final doubled = await controller.watchAd();
              if (doubled) controller.addCoins(earned);
              if (mounted) Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _showAdRewardSheet() async {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => AdRewardSheet(
        onFiveMin: () async {
          Navigator.pop(context);
          final ok = await controller.watchAd();
          if (ok) controller.startAdBoost();
        },
        onCoins: () async {
          Navigator.pop(context);
          final ok = await controller.watchAd();
          if (ok) controller.addCoins(100);
        },
      ),
    );
  }

  void _showHireSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final availableStaff =
            staffByTier[controller.game.milestoneIndex] ?? {};
        final title = hirePanelTitles[controller.game.milestoneIndex];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: StaffPanel(
            staff: availableStaff,
            hired: controller.hiredStaff,
            coins: controller.coins,
            title: title,
            onHire: (type, qty) {
              Navigator.pop(context);
              _hireStaff(type, qty);
            },
          ),
        );
      },
    );
  }

  void _showPrestigeSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => PrestigeSheet(
        upgrades: controller.game.prestige.upgrades,
        points: controller.game.prestige.points,
        onPurchase: (id) {
          HapticFeedback.mediumImpact();
          controller.game.prestige.purchase(id);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showFranchiseHQ() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => FranchiseHQ(
        game: controller.game,
        onPurchase: (id) {
          controller.game.purchasePrestigeUpgrade(id);
          Navigator.pop(context);
          setState(() {});
        },
      ),
    );
  }

  void _showPantry() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => ArtifactPantry(game: controller.game),
    ).then((_) => setState(() {}));
  }

  void _showProgressionSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => ProgressionSheet(
        currentTier: controller.game.milestoneIndex,
        currentProgress: controller.game.mealsServed,
      ),
    );
  }

  Future<void> _resetGame() async {
    await controller.resetGame();
  }

  Future<void> _confirmReset() async {
    HapticFeedback.selectionClick();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Game?'),
        content: const Text('Are you sure you want to erase your progress?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _resetGame();
    }
  }

  Future<void> _confirmFranchiseDeal() async {
    HapticFeedback.selectionClick();
    final tokens = 1 + (controller.game.mealsServed ~/ 1000);
    final nextIndex =
        (controller.game.locationSetIndex + 1) % franchiseLocationSets.length;
    final nextName = franchiseLocationSets[nextIndex][0].name;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Franchise Deal?'),
        content: Text(
            'Earn $tokens Franchise Tokens and move to $nextName.\nYour current restaurant progress will be reset.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => controller.game.prestigeUp());
    }
  }

  void _startRipMode() {
    HapticFeedback.lightImpact();
    controller.startRipMode();
  }

  @override
  void dispose() {
    controller.removeListener(_controllerListener);
    controller.dispose();
    _frenzyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool finalStage = controller.game.atFinalMilestone;
    final int goal =
        finalStage ? 0 : controller.game.currentMilestoneGoal;
    final double progress =
        finalStage ? 1 : controller.game.mealsServed / goal;
    final String nextName = finalStage
        ? 'Completed'
        : GameState.milestones[controller.game.milestoneIndex + 1];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tap Tap Chef'),
          leading: PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'reset') _confirmReset();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'reset',
                child: Text('Reset Game'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _startRipMode,
              child: const Text('Rip a Joint',
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
        body: Transform.translate(
          offset: _frenzyOffset,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Location: ${controller.game.currentLocation.name}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Franchise Tokens: ${formatNumber(controller.game.franchiseTokens)}'),
                      const SizedBox(height: 8),
                      Text('Meals served: ${formatNumber(controller.game.mealsServed)}'),
                      Text('Stage: ${controller.game.currentMilestone}'),
                      LinearProgressIndicator(value: progress),
                      Text(finalStage
                          ? 'Final milestone reached'
                          : '${(progress * 100).toStringAsFixed(0)}% to $nextName'),
                      Text('Prestige Points: ${controller.game.prestige.points}'),
                      ElevatedButton(
                        onPressed: _showFranchiseHQ,
                        child: const Text('Franchise HQ'),
                      ),
                      Text('Passive taps/s: ${controller.currentTPS.toStringAsFixed(1)}'),
                      const SizedBox(height: 8),
                      Text('Combo: ${controller.combo}  x${controller.currentMultiplier}'),
                      if (controller.adBoostActive)
                        Text(
                            'Ad boost: ${(controller.adBoostSeconds ~/ 60).toString().padLeft(2, '0')}:${(controller.adBoostSeconds % 60).toString().padLeft(2, '0')}'),
                      LinearProgressIndicator(value: controller.combo / GameController.comboMax),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _cook,
                            child: Text('Cook (+${controller.perTap})'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _showHireSheet,
                            child: const Text('Hire Staff'),
                          ),
                        ],
                      ),
                      if (controller.game.atFinalMilestone)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            onPressed: _confirmFranchiseDeal,
                            child: const Text('Sign Franchise Deal'),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text('Coins: ${formatNumber(controller.coins)}'),
                      const SizedBox(height: 16),
                      UpgradePanel(
                        upgrades: controller.upgrades,
                        currency: controller.coins,
                        onPurchase: _purchase,
                        title: upgradePanelTitles[controller.game.milestoneIndex],
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _showAdRewardSheet,
                        child: const Text('Watch Ad for Rewards'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _showPantry,
                        child: const Text('The Pantry'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _showProgressionSheet,
                        child: const Text('Progression'),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.specialVisible)
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: GestureDetector(
                    onTap: _onSpecialTap,
                    child:
                        const Icon(Icons.star, size: 48, color: Colors.purple),
                  ),
                ),
              if (controller.frenzy)
                const Positioned.fill(
                  child: FrenzyOverlay(),
                ),
              if (controller.ripMode)
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: controller.ripColor.withOpacity(0.3),
                    child: Transform.rotate(
                      angle: controller.ripRotation,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
