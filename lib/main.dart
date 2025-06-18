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
import 'screens/kitchen_screen.dart';
import 'screens/upgrades_screen.dart';
import 'screens/prestige_screen.dart';
import 'screens/boosts_screen.dart';
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
  int _navIndex = 0;

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
      await controller.franchise();
      setState(() {});
    }
  }

  void _showSettings() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) => ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('Reset Game'),
        onTap: () {
          Navigator.pop(context);
          _confirmReset();
        },
      ),
    );
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
        body: Stack(
          children: [
            IndexedStack(
              index: _navIndex,
              children: [
                KitchenScreen(
                  controller: controller,
                  hireStaff: _hireStaff,
                  purchaseUpgrade: _purchase,
                  onAdReward: _showAdRewardSheet,
                  onPantry: () {},
                  onSettings: _showSettings,
                ),
                UpgradesScreen(
                  controller: controller,
                  onPurchase: _purchase,
                  onHire: _hireStaff,
                ),
                PrestigeScreen(
                  controller: controller,
                  onConfirmDeal: _confirmFranchiseDeal,
                ),
                BoostsScreen(
                  controller: controller,
                  watchAd: controller.watchAd,
                ),
              ],
            ),
            if (controller.specialVisible)
              Positioned(
                bottom: 80,
                right: 20,
                child: GestureDetector(
                  onTap: _onSpecialTap,
                  child: const Icon(Icons.star, size: 48, color: Colors.purple),
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_fire_department), label: "Kitchen"),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_upward), label: "Upgrades"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border), label: "Prestige"),
            BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch), label: "Boosts"),
          ],
        ));
  }
}
