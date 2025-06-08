import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/game_state.dart';
import 'models/staff.dart';
import 'models/upgrade.dart';
import 'services/storage.dart';
import 'widgets/upgrade_panel.dart';
import 'widgets/staff_panel.dart';
import 'widgets/mini_game_dialog.dart';

const List<String> milestoneArt = [
  r'''
  ( )
 /|_|\\
 /___\\
  ''',
  r'''
  |~~~~|
  |DNR |
  |____|
  ''',
  r'''
   _____
  |[ ] |
  |[ ] |
  |____|
  ''',
  r'''
  .----.
 / .--. \\
| |    | |
 \\ '--' /
  `----'
  ''',
  r'''
  .-.
 (o o)
  |=|
 __|__
/_____\\
  ''',
  r'''
  (X_X)
   /|\\
  /_|_\\
  ''',
  r'''
  <\\/>
  (oo)
  /||\\
  ''',
  r'''
   *-|-*
  /o\\
  \\v/
  ''',
];

const List<String> milestoneDialogues = [
  "Street cart fans now chant your menu. This is totally normal.",
  "Your diner draws crowds - and a new existential crisis.",
  "Congrats, you're corporate! Please ignore the accountants in the kitchen.",
  "Entire nations line up. Is this still about food?",
  "Starships detour just to taste your fries. Space smells like success.",
  "You've fed the galaxy. Nothing left but existential hunger.",
  "Time loops around the kitchen. Omelettes now cause deja vu.",
  "The multiverse demands endless specials. Hope you're not out of ideas."
];

const List<String> upgradePanelTitles = [
  'Cart Upgrades',
  'Diner Renovations',
  'Corporate Overhauls',
  'Global Improvements',
  'Galactic Remodels',
  'Endgame Upgrades',
  'Temporal Adjustments',
  'Multiverse Investments',
];

const List<String> hirePanelTitles = [
  'Street Crew',
  'Diner Staff',
  'Corporate Recruits',
  'Global Recruiting',
  'Cosmic Crew',
  'Endgame Operatives',
  'Temporal Staff',
  'Multiverse Talent',
];

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

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final GameState game = GameState();

  int coins = 0;
  int perTap = 1;
  late List<Upgrade> upgrades;

  final Map<StaffType, int> hiredStaff = {};
  late final Timer _timer;
  double _passiveProgress = 0;
  int _lastMilestoneIndex = 0;
  double _currentTPS = 0;
  final StorageService _storage = StorageService();

  bool _ripMode = false;
  Color _ripColor = Colors.transparent;
  double _ripRotation = 0;
  Timer? _ripTimer;

  // Rewarded ad boost state
  bool _adBoostActive = false;
  int _adBoostSeconds = 0;
  Timer? _adBoostTimer;

  // Combo/Frenzy state
  int _combo = 0;
  Timer? _comboTimer;
  static const int _comboMax = 10;
  static const Duration _comboTimeout = Duration(seconds: 2);

  bool _frenzy = false;
  Timer? _frenzyTimer;
  Offset _frenzyOffset = Offset.zero;
  Color _frenzyColor = Colors.transparent;

  // Special customer state
  Timer? _specialTimer;
  bool _specialVisible = false;

  @override
  void initState() {
    super.initState();
    upgrades = upgradesForTier(game.milestoneIndex);
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickPassive());
    _specialTimer =
        Timer.periodic(const Duration(seconds: 20), (_) => _spawnSpecial());
  }

  Future<void> _load() async {
    final result = await _storage.loadGame(idleMultiplier: 0.000833);
    setState(() {
      game.mealsServed = result.count;
      coins += result.earned;
      _lastMilestoneIndex = game.milestoneIndex;
    });
    if (result.earned > 0) {
      await _showOfflineEarningsDialog(result.earned);
      _checkMilestone();
    }
  }

  Future<void> _cook() async {
    _incrementCombo();
    HapticFeedback.lightImpact();
    setState(() {
      for (int i = 0; i < perTap; i++) {
        game.cook();
      }
      coins += perTap * _currentMultiplier;
    });
    _checkMilestone();
    await _storage.saveGame(game.mealsServed);
  }

  void _purchase(Upgrade upgrade, int quantity) {
    if (quantity <= 0) return;
    final int totalCost = upgrade.cost * quantity;
    if (coins >= totalCost) {
      HapticFeedback.mediumImpact();
      setState(() {
        coins -= totalCost;
        perTap += upgrade.effect * quantity;
        upgrade.owned += quantity;
      });
    }
  }

  void _tickPassive() {
    double tapsPerSecond = 0;
    hiredStaff.forEach((type, qty) {
      final staff = staffOptions[type]!;
      tapsPerSecond += staff.tapsPerSecond * qty;
    });
    _passiveProgress += tapsPerSecond;
    final int whole = _passiveProgress.floor();
    _passiveProgress -= whole;
    setState(() {
      _currentTPS = tapsPerSecond;
      if (whole > 0) {
        for (int i = 0; i < whole; i++) {
          game.cook();
        }
        coins += perTap * whole;
      }
    });
    _checkMilestone();
  }

  void _checkMilestone() {
    if (_lastMilestoneIndex != game.milestoneIndex) {
      _lastMilestoneIndex = game.milestoneIndex;
      HapticFeedback.heavyImpact();
      final art = milestoneArt[game.milestoneIndex];
      final dialogue = milestoneDialogues[game.milestoneIndex];
      setState(() {
        upgrades = upgradesForTier(game.milestoneIndex);
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Milestone: ${game.currentMilestone}'),
          content: SingleChildScrollView(child: Text(art)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Nice!'),
            ),
          ],
        ),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(dialogue)));
    }
  }

  void _hireStaff(StaffType type, int quantity) {
    final staff = staffOptions[type]!;
    final int totalCost = staff.cost * quantity;
    if (coins >= totalCost) {
      HapticFeedback.mediumImpact();
      setState(() {
        coins -= totalCost;
        hiredStaff[type] = (hiredStaff[type] ?? 0) + quantity;
      });
    }
  }

  Color _randomColor() {
    final rand = Random();
    return Color.fromARGB(
      255,
      rand.nextInt(256),
      rand.nextInt(256),
      rand.nextInt(256),
    );
  }

  void _spawnSpecial() {
    if (_specialVisible) return;
    if (Random().nextDouble() < 0.5) {
      setState(() => _specialVisible = true);
      Timer(const Duration(seconds: 10), () {
        if (mounted) setState(() => _specialVisible = false);
      });
    }
  }

  Future<void> _onSpecialTap() async {
    setState(() => _specialVisible = false);
    final taps = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const MiniGameDialog(),
        ) ??
        0;
    setState(() => coins += taps * 10);
  }

  int get _currentMultiplier {
    final base = _frenzy ? 5 : 1 + (_combo ~/ 2);
    return _adBoostActive ? base * 2 : base;
  }

  void _incrementCombo() {
    _comboTimer?.cancel();
    _comboTimer = Timer(_comboTimeout, () {
      setState(() => _combo = 0);
    });
    setState(() {
      if (_combo < _comboMax) {
        _combo += 1;
        if (_combo >= _comboMax) _startFrenzyMode();
      }
    });
  }

  void _startFrenzyMode() {
    if (_frenzy) return;
    setState(() {
      _frenzy = true;
      _combo = _comboMax;
    });
    _frenzyTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        _frenzyOffset = Offset(
          Random().nextDouble() * 10 - 5,
          Random().nextDouble() * 10 - 5,
        );
        _frenzyColor = _randomColor();
      });
    });
    Timer(const Duration(seconds: 5), () {
      _frenzyTimer?.cancel();
      _frenzyTimer = null;
      setState(() {
        _frenzy = false;
        _combo = 0;
        _frenzyOffset = Offset.zero;
        _frenzyColor = Colors.transparent;
      });
    });
  }

  void _startRipMode() {
    if (_ripMode) return;
    setState(() {
      _ripMode = true;
      _ripColor = _randomColor();
      _ripRotation = (Random().nextDouble() - 0.5) * 0.2;
    });
    _ripTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() {
        _ripColor = _randomColor();
        _ripRotation = (Random().nextDouble() - 0.5) * 0.2;
      });
    });
    Timer(const Duration(seconds: 10), () {
      _ripTimer?.cancel();
      _ripTimer = null;
      setState(() {
        _ripMode = false;
      });
    });
  }

  void _startAdBoost() {
    _adBoostTimer?.cancel();
    setState(() {
      _adBoostActive = true;
      _adBoostSeconds = 300;
    });
    _adBoostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_adBoostSeconds <= 1) {
        timer.cancel();
        setState(() {
          _adBoostActive = false;
          _adBoostSeconds = 0;
        });
      } else {
        setState(() => _adBoostSeconds--);
      }
    });
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
          child: AlertDialog(
            title: const Text('Welcome Back!'),
            content: Text('You earned $earned coins while you were away.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nice'),
              ),
              TextButton(
                onPressed: () async {
                  final doubled = await _watchAd();
                  if (doubled) {
                    setState(() => coins += earned);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Double for Ad'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _watchAd() async {
    // Placeholder for rewarded ad integration.
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<void> _showAdRewardSheet() async {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Double earnings for 5 minutes'),
              onTap: () async {
                Navigator.pop(context);
                final ok = await _watchAd();
                if (ok) _startAdBoost();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Get 100 coins'),
              onTap: () async {
                Navigator.pop(context);
                final ok = await _watchAd();
                if (ok) setState(() => coins += 100);
              },
            ),
          ],
        );
      },
    );
  }

  void _showHireSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final availableStaff = staffByTier[game.milestoneIndex] ?? {};
        final title = hirePanelTitles[game.milestoneIndex];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: StaffPanel(
            staff: availableStaff,
            hired: hiredStaff,
            coins: coins,
            onHire: (type, qty) {
              Navigator.pop(context);
              _hireStaff(type, qty);
            },
            title: title,
          ),
        );
      },
    );
  }

  void _showPrestigeSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: game.prestige.upgrades.map((upgrade) {
            final canBuy =
                game.prestige.points >= upgrade.cost && !upgrade.purchased;
            return ListTile(
              title: Text(upgrade.name),
              subtitle: Text(
                  '${upgrade.description} - Cost: ${upgrade.cost} PP'),
              trailing: upgrade.purchased
                  ? const Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                      onPressed: canBuy
                          ? () {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                game.prestige.purchase(upgrade.id);
                              });
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Buy'),
                    ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _resetGame() async {
    await _storage.clear();
    setState(() {
      game.resetProgress();
      game.prestige.points = 0;
      coins = 0;
      perTap = 1;
      upgrades = upgradesForTier(game.milestoneIndex);
      for (final p in game.prestige.upgrades) {
        p.purchased = false;
      }
      hiredStaff.clear();
      _passiveProgress = 0;
      _lastMilestoneIndex = 0;
      _currentTPS = 0;
    });
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

  @override
  void dispose() {
    _timer.cancel();
    _ripTimer?.cancel();
    _specialTimer?.cancel();
    _adBoostTimer?.cancel();
    _storage.saveGame(game.mealsServed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool finalStage = game.atFinalMilestone;
    final int goal =
        finalStage ? 0 : GameState.milestoneGoals[game.milestoneIndex];
    final double progress = finalStage ? 1 : game.mealsServed / goal;
    final String nextName = finalStage
        ? 'Completed'
        : GameState.milestones[game.milestoneIndex + 1];

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
            child: const Text('Rip a Joint', style: TextStyle(color: Colors.green)),
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
            Text('Meals served: ${game.mealsServed}'),
            Text('Stage: ${game.currentMilestone}'),
            LinearProgressIndicator(value: progress),
            Text(finalStage
                ? 'Final milestone reached'
                : '${(progress * 100).toStringAsFixed(0)}% to $nextName'),
            Text('Prestige Points: ${game.prestige.points}'),
            TextButton(
              onPressed: _showPrestigeSheet,
              child: const Text('Prestige Upgrades'),
            ),
            Text('Passive taps/s: ${_currentTPS.toStringAsFixed(1)}'),
            const SizedBox(height: 8),
            Text('Combo: $_combo  x$_currentMultiplier'),
            if (_adBoostActive)
              Text('Ad boost: ${(_adBoostSeconds ~/ 60).toString().padLeft(2, '0')}:${(_adBoostSeconds % 60).toString().padLeft(2, '0')}'),
            LinearProgressIndicator(value: _combo / _comboMax),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _cook,
                  child: Text('Cook (+$perTap)'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _showHireSheet,
                  child: const Text('Hire Staff'),
                ),
              ],
            ),
            if (game.atFinalMilestone)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => game.prestigeUp()),
                  child: Text(
                    'Prestige (x${game.prestige.multiplier.toStringAsFixed(1)})',
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text('Coins: $coins'),
            const SizedBox(height: 16),
            UpgradePanel(
              upgrades: upgrades,
              currency: coins,
              onPurchase: _purchase,
              title: upgradePanelTitles[game.milestoneIndex],
            ),
            const SizedBox(height: 16),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _showAdRewardSheet,
            child: const Text('Watch Ad for Rewards'),
          ),
        ],
      ),
    ),
  ),
          if (_specialVisible)
            Positioned(
              bottom: 80,
              right: 20,
              child: GestureDetector(
                onTap: _onSpecialTap,
                child: const Icon(Icons.star, size: 48, color: Colors.purple),
              ),
            ),
          if (_frenzy)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  color: _frenzyColor.withOpacity(0.3),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          if (_ripMode)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: _ripColor.withOpacity(0.5),
                child: Transform.rotate(
                  angle: _ripRotation,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
        ],
      ),
    ));
  }
}
