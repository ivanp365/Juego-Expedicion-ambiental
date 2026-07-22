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
      builder: (context, candidate, _) {
        final isDraggingOver = candidate.isNotEmpty;

        return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              // ═══════════════════════════════════════════════════════════════
              // ═══════════════════════════════════════════════════════════════
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                // Sin color de fondo, sin gradiente, sin tarjeta
                color: Colors.transparent,
                // Borde SOLO cuando se arrastra encima, o en feedback
                border: Border.all(
                  color: success
                      ? Colors.green
                      : failure
                      ? Colors.red
                      : isDraggingOver
                      ? binColor
                      : Colors.transparent, // ← Invisible por defecto
                  width: isDraggingOver || success || failure ? 2.5 : 0,
                ),
                borderRadius: BorderRadius.circular(20),
                // ═══════════════════════════════════════════════════════════════
                // SIN BOXSHADOW: Elimina el halo que parece "fondo gris"
                // ═══════════════════════════════════════════════════════════════
                // Si quieres un efecto sutil SOLO al drag, usa esto:
                boxShadow: isDraggingOver
                    ? [
                        BoxShadow(
                          color: binColor.withValues(alpha: 0.25),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ═══════════════════════════════════════════════════════════════
                  // ═══════════════════════════════════════════════════════════════
                  SafeImage(
                    assetPath: bin.image,
                    fit: BoxFit.contain, // Mantiene proporción de la PNG
                  ),
                  // Indicador de éxito/fraceso superpuesto
                  if (success || failure)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: (success ? Colors.green : Colors.red)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          success
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: success ? Colors.green : Colors.red,
                          size: 48,
                        ),
                      ),
                    ),
                ],
              ),
            )
            .animate(
              target: success
                  ? 1
                  : failure
                  ? 1
                  : 0,
            )
            .scale(
              end: success ? const Offset(1.06, 1.06) : const Offset(1, 1),
              curve: Curves.easeOutBack,
            )
            .shake(hz: failure ? 5.0 : 0.0);
      },
    );
  }

  Color get _color => switch (bin.type) {
    WasteType.recyclable => const Color(0xff64748B),
    WasteType.organic => const Color(0xff22C55E),
    WasteType.nonRecyclable => const Color(0xff8B5CF6),
    WasteType.hazardous => const Color(0xffEF4444),
  };
}
