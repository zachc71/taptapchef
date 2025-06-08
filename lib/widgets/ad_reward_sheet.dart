import 'package:flutter/material.dart';

class AdRewardSheet extends StatelessWidget {
  final VoidCallback onFiveMin;
  final VoidCallback onCoins;

  const AdRewardSheet({
    super.key,
    required this.onFiveMin,
    required this.onCoins,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.timer),
          title: const Text('Double earnings for 5 minutes'),
          onTap: onFiveMin,
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Get 100 coins'),
          onTap: onCoins,
        ),
      ],
    );
  }
}
