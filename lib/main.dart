import 'package:flutter/material.dart';
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
  int count = 0;
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Meals served: ${game.mealsServed}'),
            Text('Current milestone: ${game.currentTier.name}'),
            if (game.nextTier != null)
              Text('Next: ${game.nextTier!.name} at ${game.nextTier!.unlockRequirement} meals'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => game.cookMeal()),
              child: const Text('Cook!'),
            ),
          ],
        ),
      ),
    );
  }
}

