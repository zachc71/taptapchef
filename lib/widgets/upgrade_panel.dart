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
  final ValueChanged<Upgrade> onPurchase;

  const UpgradePanel({
    super.key,
    required this.upgrades,
    required this.currency,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: upgrades.map((u) {
        return ListTile(
          title: Text(u.name),
          subtitle: Text('Cost: \$${u.cost} - Effect: +${u.effect} per tap'),
          trailing: u.purchased
              ? const Text('Purchased')
              : Pulse(
                  active: currency >= u.cost,
                  child: ElevatedButton(
                    onPressed: currency >= u.cost ? () => onPurchase(u) : null,
                    child: const Text('Buy'),
                  ),
                ),
        );
      }).toList(),
    );
  }
}
