import 'package:flutter/material.dart';

/// An overlay used during frenzy mode that animates a vertical gradient
/// from red/orange at the bottom to transparent at the top.
class FrenzyOverlay extends StatefulWidget {
  const FrenzyOverlay({super.key});

  @override
  State<FrenzyOverlay> createState() => _FrenzyOverlayState();
}

class _FrenzyOverlayState extends State<FrenzyOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final height =
              MediaQuery.of(context).size.height * _controller.value;
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
