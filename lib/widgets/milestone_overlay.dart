import 'package:flutter/material.dart';

class MilestoneOverlay extends StatelessWidget {
  final String title;
  final String art;
  final VoidCallback onContinue;

  const MilestoneOverlay({
    super.key,
    required this.title,
    required this.art,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onContinue,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              art,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              child: const Text('Open new restaurant milestone'),
            ),
          ],
        ),
      ),
    );
  }
}
