import 'package:flutter/material.dart';

import 'models/upgrade.dart';
import 'widgets/upgrade_panel.dart';
import 'dart:async';

import 'models/staff.dart';

import 'services/storage.dart';
import 'models/game_state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Tap Chef',
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final GameState state = GameState();
  int count = 0;
  int coins = 0;
  int perTap = 1;
  late List<Upgrade> upgrades;

  final Map<StaffType, int> hiredStaff = {};
  late final Timer _timer;
  double _passiveProgress = 0;
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    upgrades = [
      Upgrade(name: 'Better Stove', cost: 10, effect: 1),
      Upgrade(name: 'Sous Chef', cost: 50, effect: 2),
    ];
  }

  void _purchase(Upgrade upgrade) {
    if (coins >= upgrade.cost && !upgrade.purchased) {
      setState(() {
        coins -= upgrade.cost;
        perTap += upgrade.effect;
        upgrade.purchased = true;
      });
    }
  }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickPassive());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _tickPassive() {
    double tapsPerSecond = 0;
    hiredStaff.forEach((type, qty) {
      final staff = staffOptions[type]!;
      tapsPerSecond += staff.tapsPerSecond * qty;
    });
    _passiveProgress += tapsPerSecond;
    final int whole = _passiveProgress.floor();
    if (whole > 0) {
      _passiveProgress -= whole;
      setState(() => count += whole);
    }
  }

  void _hireStaff(StaffType type) {
    final staff = staffOptions[type]!;
    if (count >= staff.cost) {
      setState(() {
        count -= staff.cost;
        hiredStaff[type] = (hiredStaff[type] ?? 0) + 1;
      });
    }
  }

  void _showHireSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: StaffType.values.map((type) {
            final staff = staffOptions[type]!;
            final owned = hiredStaff[type] ?? 0;
            final affordable = count >= staff.cost;
            return ListTile(
              title: Text('${staff.name} ($owned hired)'),
              subtitle: Text('Cost: ${staff.cost} \u2014 ${staff.tapsPerSecond} taps/s'),
              trailing: ElevatedButton(
                onPressed: affordable
                    ? () {
                        Navigator.pop(context);
                        _hireStaff(type);
                      }
                    : null,
                child: const Text('Hire'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

    _load();
  }

  Future<void> _load() async {
    final loaded = await _storage.loadGame();
    setState(() => count = loaded);
  }

  Future<void> _increment() async {
    setState(() => count++);
    await _storage.saveGame(count);
  }

  @override
  void dispose() {
    _storage.saveGame(count);
    super.dispose();
  }

  final GameState game = GameState();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap Tap Chef')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Meals served: ${state.mealsServed}'),
            Text('Stage: ${state.currentMilestone}'),
            Text('Prestige Points: ${state.prestige.points}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => state.cook()),
              child: const Text('Cook!'),
            ),
            if (state.atFinalMilestone)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => state.prestigeUp()),
                  child: Text('Prestige (x${state.prestige.multiplier.toStringAsFixed(1)})'),
                ),
              ),
            Text('Meals served: $count'),
            Text('Coins: $coins'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {
                count += perTap;
                coins += perTap;
              }),
              child: Text('Cook (+$perTap)'),
            ),
            const SizedBox(height: 24),
            UpgradePanel(
              upgrades: upgrades,
              currency: coins,
              onPurchase: _purchase,

            Text('Meals served: ${game.mealsServed}'),
            Text('Current milestone: ${game.currentTier.name}'),
            if (game.nextTier != null)
              Text('Next: ${game.nextTier!.name} at ${game.nextTier!.unlockRequirement} meals'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => game.cookMeal()),
              child: const Text('Cook!'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showHireSheet,
              child: const Text('Hire Staff'),
            ),
          ],
        ),
      ),
    );
  }
}

