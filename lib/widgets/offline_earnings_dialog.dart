import 'package:flutter/material.dart';
import '../util/format.dart';

class OfflineEarningsDialog extends StatelessWidget {
  final int earned;
  final VoidCallback onClose;
  final VoidCallback onDouble;

  const OfflineEarningsDialog({
    super.key,
    required this.earned,
    required this.onClose,
    required this.onDouble,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Welcome Back!'),
      content: Text('You earned ${formatNumber(earned)} coins while you were away.'),
      actions: [
        TextButton(onPressed: onClose, child: const Text('Nice')),
        TextButton(onPressed: onDouble, child: const Text('Double for Ad')),
      ],
    );
  }
}
