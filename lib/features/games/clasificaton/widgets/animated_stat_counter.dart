import 'package:flutter/material.dart';

/// Animated stat counter for game HUD elements with smooth number transitions
class AnimatedStatCounter extends StatefulWidget {
  final int value;
  final String icon;
  final String label;
  final Color? accentColor;
  final Duration animationDuration;

  const AnimatedStatCounter({
    super.key,
    required this.value,
    required this.icon,
    required this.label,
    this.accentColor,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedStatCounter> createState() => _AnimatedStatCounterState();
}

class _AnimatedStatCounterState extends State<AnimatedStatCounter>
    with SingleTickerProviderStateMixin {
  late int _displayedValue;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _displayedValue = widget.value;
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(AnimatedStatCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _scaleController.forward(from: 0);
      _animateToValue();
    }
  }

  void _animateToValue() {
    final difference = widget.value - _displayedValue;
    final steps = (difference.abs() / 1).ceil();
    final stepValue = difference / steps;

    int currentStep = 0;
    Future<void>.delayed(Duration.zero, () async {
      while (currentStep < steps) {
        await Future<void>.delayed(
            Duration(milliseconds: widget.animationDuration.inMilliseconds ~/ steps));
        if (mounted) {
          setState(() {
            currentStep++;
            _displayedValue = (_displayedValue + stepValue).toInt();
          });
        }
      }
      if (mounted) {
        setState(() => _displayedValue = widget.value);
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.15)
          .animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.icon,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            _displayedValue.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
