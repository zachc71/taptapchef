import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap Tap Chef')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}

