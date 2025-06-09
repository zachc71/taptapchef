import 'package:flutter/material.dart';

class MilestoneOverlay extends StatefulWidget {
  final String title;
  final String art;
  final String dialogue;
  final VoidCallback onContinue;

  const MilestoneOverlay({
    super.key,
    required this.title,
    required this.art,
    required this.dialogue,
    required this.onContinue,
  });

  @override
  State<MilestoneOverlay> createState() => _MilestoneOverlayState();
}

class _MilestoneOverlayState extends State<MilestoneOverlay> {
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _canContinue = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _canContinue ? widget.onContinue : null,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.art,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            Text(
              widget.dialogue,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _canContinue ? widget.onContinue : null,
              child: Text(
                _canContinue
                    ? 'Open new restaurant milestone'
                    : 'Please wait...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
