import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/waste_item.dart';
import 'safe_image.dart';

class DraggableWaste extends StatefulWidget {
  final WasteItem waste;
  final double size;

  const DraggableWaste({super.key, required this.waste, this.size = 200});

  @override
  State<DraggableWaste> createState() => _DraggableWasteState();
}

class _DraggableWasteState extends State<DraggableWaste> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final image = SafeImage(assetPath: widget.waste.image, fit: BoxFit.contain);
    final feedbackSize = widget.size.clamp(140.0, 200.0).toDouble();

    return Draggable<WasteItem>(
      data: widget.waste,
      onDragStarted: () => setState(() => _isDragging = true),
      onDragEnd: (_) => setState(() => _isDragging = false),
      onDraggableCanceled: (_, _) => setState(() => _isDragging = false),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: feedbackSize,
          height: feedbackSize,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff79E5B0).withValues(alpha: 0.6),
                blurRadius: 32,
                spreadRadius: 8,
              ),
            ],
          ),
          child: image,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: SizedBox(width: widget.size, height: widget.size, child: image),
      ),
      child: Semantics(
        label: 'Arrastra ${widget.waste.name} al contenedor correcto',
        enabled: true,
        child: GestureDetector(
          child:
              AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.size,
                    height: widget.size,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.95),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _isDragging
                              ? const Color(0xff79E5B0).withValues(alpha: 0.5)
                              : Colors.black.withValues(alpha: 0.25),
                          blurRadius: _isDragging ? 40 : 24,
                          spreadRadius: _isDragging ? 6 : 2,
                          offset: Offset(0, _isDragging ? 2 : 8),
                        ),
                      ],
                      border: Border.all(
                        color: _isDragging
                            ? const Color(0xff79E5B0).withValues(alpha: 0.8)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsing background ring effect
                        if (!_isDragging)
                          Positioned.fill(
                            child:
                                Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            const Color(
                                              0xff79E5B0,
                                            ).withValues(alpha: 0.1),
                                            const Color(
                                              0xff79E5B0,
                                            ).withValues(alpha: 0.02),
                                          ],
                                        ),
                                      ),
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(),
                                    )
                                    .scale(
                                      begin: const Offset(0.9, 0.9),
                                      end: const Offset(1.1, 1.1),
                                      duration: 2000.ms,
                                      curve: Curves.easeInOut,
                                    )
                                    .fadeOut(duration: 1000.ms),
                          ),
                        image,
                      ],
                    ),
                  )
                  .animate(key: ValueKey(widget.waste.id))
                  .fadeIn()
                  .scale(
                    begin: const Offset(0.72, 0.72),
                    curve: Curves.elasticOut,
                  ),
        ),
      ),
    );
  }
}
