import 'package:flutter/material.dart';
import '../models/progression.dart';
import '../util/format.dart';

class ProgressionSheet extends StatelessWidget {
  final int currentTier;
  final int currentProgress;

  const ProgressionSheet({
    super.key,
    required this.currentTier,
    required this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: progressionTiers.length,
      itemBuilder: (context, index) {
        final tier = progressionTiers[index];
        final status = index < currentTier
            ? 'Completed'
            : index == currentTier
                ? 'Current'
                : 'Locked';
        double progress = 0;
        if (index == currentTier && tier.unlockRequirement > 0) {
          progress = currentProgress / tier.unlockRequirement;
          if (progress > 1) progress = 1;
        } else if (index < currentTier) {
          progress = 1;
        }
        return ListTile(
          leading: Icon(
            index < currentTier
                ? Icons.check_circle
                : index == currentTier
                    ? Icons.radio_button_checked
                    : Icons.lock,
          ),
          title: Text(tier.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${tier.reward}\nUnlocks at ${formatNumber(tier.unlockRequirement)} meals'),
              LinearProgressIndicator(value: progress),
            ],
          ),
          trailing: Text(status),
        );
      },
    );
  }
}
