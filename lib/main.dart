import 'package:flutter/material.dart';
import 'dart:async';

import 'models/staff.dart';

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
  final Map<StaffType, int> hiredStaff = {};
  late final Timer _timer;
  double _passiveProgress = 0;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap Tap Chef')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Meals served: $count'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => count++),
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

