import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class LevelIntroPage extends StatefulWidget {
  final int level;
  final String imagePath;

  const LevelIntroPage({
    super.key,
    required this.level,
    required this.imagePath,
  });

  @override
  State<LevelIntroPage> createState() => _LevelIntroPageState();
}

class _LevelIntroPageState extends State<LevelIntroPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      context.go('/clasificaton');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 900),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.asset(widget.imagePath, fit: BoxFit.contain)
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .scale(begin: const Offset(.85, .85))
                  .then()
                  .shimmer(duration: 1200.ms),
            ),
          ),
        ),
      ),
    );
  }
}
