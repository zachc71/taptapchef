import 'package:flutter/material.dart';
import 'models/upgrade.dart';
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
  int count = 0;
  int coins = 0;
  int perTap = 1;
  late List<Upgrade> upgrades;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap Tap Chef')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            ),
          ],
        ),
      ),
    );
  }
}

