import 'dart:async';

import 'package:flutter/material.dart';

import 'models/game_state.dart';
import 'models/staff.dart';
import 'models/upgrade.dart';
import 'services/storage.dart';
import 'widgets/upgrade_panel.dart';

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
  final GameState game = GameState();

  int coins = 0;
  int perTap = 1;
  late List<Upgrade> upgrades;

  final Map<StaffType, int> hiredStaff = {};
  late final Timer _timer;
  double _passiveProgress = 0;
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    upgrades = [
      Upgrade(name: 'Better Stove', cost: 10, effect: 1),
      Upgrade(name: 'Sous Chef', cost: 50, effect: 2),
      Upgrade(name: 'Quantum Oven', cost: 250, effect: 5),
      Upgrade(name: 'Transdimensional Delivery', cost: 1000, effect: 10),
    ];
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickPassive());
  }

  Future<void> _load() async {
    final loaded = await _storage.loadGame();
    setState(() => game.mealsServed = loaded);
  }

  Future<void> _cook() async {
    setState(() {
      for (int i = 0; i < perTap; i++) {
        game.cook();
      }
      coins += perTap;
    });
    await _storage.saveGame(game.mealsServed);
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
      setState(() {
        for (int i = 0; i < whole; i++) {
          game.cook();
        }
        coins += perTap * whole;
      });
    }
  }

  void _hireStaff(StaffType type) {
    final staff = staffOptions[type]!;
    if (coins >= staff.cost) {
      setState(() {
        coins -= staff.cost;
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
            final affordable = coins >= staff.cost;
            return ListTile(
              title: Text('${staff.name} ($owned hired)'),
              subtitle: Text(
                'Cost: ${staff.cost} \u2014 ${staff.tapsPerSecond} taps/s',
              ),
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

  @override
  void dispose() {
    _timer.cancel();
    _storage.saveGame(game.mealsServed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap Tap Chef')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Meals served: ${game.mealsServed}'),
            Text('Stage: ${game.currentMilestone}'),
            Text('Prestige Points: ${game.prestige.points}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cook,
              child: Text('Cook (+$perTap)'),
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
