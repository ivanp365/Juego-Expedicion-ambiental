import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/bin_type.dart';
import '../models/waste_item.dart';
import 'safe_image.dart';

class BinTarget extends StatelessWidget {
  final BinType bin;
  final ValueChanged<WasteItem> onAccept;
  final bool? lastAnswerCorrect;
  final bool isLastTarget;

  const BinTarget({
    super.key,
    required this.bin,
    required this.onAccept,
    this.lastAnswerCorrect,
    this.isLastTarget = false,
  });

  @override
  Widget build(BuildContext context) {
    final success = isLastTarget && lastAnswerCorrect == true;
    final failure = isLastTarget && lastAnswerCorrect == false;
    final binColor = _color;

    return DragTarget<WasteItem>(
      onAcceptWithDetails: (details) {
        HapticFeedback.heavyImpact();
        onAccept(details.data);
      },
      builder: (context, candidate, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: success
              ? LinearGradient(
                  colors: [
                    const Color(0xffB9F6CA),
                    const Color(0xff84E89C),
                  ],
                )
              : failure
                  ? LinearGradient(
                      colors: [
                        const Color(0xffFFCDD2),
                        const Color(0xffE57373),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.85),
                      ],
                    ),
          border: Border.all(
            color: candidate.isNotEmpty ? binColor : binColor.withValues(alpha: 0.6),
            width: candidate.isNotEmpty ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (success ? Colors.green : failure ? Colors.red : binColor)
                  .withValues(alpha: success || failure ? 0.5 : 0.2),
              blurRadius: success || failure ? 28 : candidate.isNotEmpty ? 16 : 8,
              spreadRadius: success ? 4 : failure ? 2 : 0,
              offset: Offset(0, success || failure ? 2 : 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      binColor.withValues(alpha: 0.08),
                      binColor.withValues(alpha: 0.04),
                    ],
                  ),
                ),
              ),
            ),
            SafeImage(assetPath: bin.image, fit: BoxFit.contain),
          ],
        ),
      )
          .animate(target: success || failure ? 1 : 0)
          .scale(end: success ? const Offset(1.08, 1.08) : const Offset(1, 1))
          .shake(hz: failure ? 6.0 : 0.0),
    );
  }

  Color get _color => switch (bin.type) {
    WasteType.recyclable => const Color(0xff64748B),
    WasteType.organic => const Color(0xff22C55E),
    WasteType.nonRecyclable => const Color(0xff8B5CF6),
    WasteType.hazardous => const Color(0xffEF4444),
  };
}

