import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({super.key, required this.onComplete});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _step = 0;

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'title': 'Tap "Cook!"',
        'msg': 'Tap here to cook meals and earn cash!'
      },
      {
        'title': 'Upgrades',
        'msg': 'Spend cash to improve income per tap.'
      },
      {
        'title': 'Staff',
        'msg': 'Hire staff to cook automatically.'
      },
    ];
    final data = steps[_step];
    return Material(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['title']!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  data['msg']!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_step < 2 ? 'Next' : 'Done'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
