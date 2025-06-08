import 'package:flutter/material.dart';
import '../models/upgrade.dart';

/// Simple pulsing effect to draw attention to actionable buttons.
class Pulse extends StatefulWidget {
  final Widget child;
  final bool active;

  const Pulse({required this.child, required this.active});

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final scale = 1 + 0.05 * _controller.value;
        final glow = 6 * _controller.value;
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.6 * _controller.value),
                  blurRadius: glow,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class UpgradePanel extends StatelessWidget {
  final List<Upgrade> upgrades;
  final int currency;
  final void Function(Upgrade, int) onPurchase;
  final String title;

  const UpgradePanel({
    super.key,
    required this.upgrades,
    required this.currency,
    required this.onPurchase,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...upgrades.map((u) {
        final bool affordable = currency >= u.cost;
        final bool affordable10 = currency >= u.cost * 10;
        final bool affordable100 = currency >= u.cost * 100;
        final int maxAffordable = currency ~/ u.cost;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u.name, style: Theme.of(context).textTheme.titleMedium),
                Text('Cost: \$${u.cost} - Effect: +${u.effect} per tap - Owned: ${u.owned}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Pulse(
                      active: affordable,
                      child: ElevatedButton(
                        onPressed: affordable ? () => onPurchase(u, 1) : null,
                        child: const Text('1'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: affordable10 ? () => onPurchase(u, 10) : null,
                      child: const Text('10'),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: affordable100 ? () => onPurchase(u, 100) : null,
                      child: const Text('100'),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: maxAffordable > 0 ? () => onPurchase(u, maxAffordable) : null,
                      child: const Text('MAX'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ]);
  }
}
