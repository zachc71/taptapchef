import 'dart:async';
import 'package:flutter/material.dart';

/// A simple 5 second tap challenge. The dialog displays the remaining
/// time and the current tap count. It returns the total taps when the
/// timer finishes.
class MiniGameDialog extends StatefulWidget {
  const MiniGameDialog({super.key});

  @override
  State<MiniGameDialog> createState() => _MiniGameDialogState();
}

class _MiniGameDialogState extends State<MiniGameDialog> {
  static const int _duration = 5;
  int _remaining = _duration;
  int _taps = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _remaining -= 1;
        if (_remaining <= 0) {
          Navigator.of(context).pop(_taps);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tap! $_remaining s left'),
      content: GestureDetector(
        onTap: () => setState(() => _taps++),
        child: SizedBox(
          height: 120,
          width: 120,
          child: Center(
            child: Text(
              'Taps: $_taps',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
