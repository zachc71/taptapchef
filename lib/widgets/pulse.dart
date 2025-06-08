import 'package:flutter/material.dart';

/// Simple pulsing effect to draw attention to actionable buttons.
class Pulse extends StatefulWidget {
  final Widget child;
  final bool active;

  const Pulse({super.key, required this.child, required this.active});

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
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
    );
  }
}
