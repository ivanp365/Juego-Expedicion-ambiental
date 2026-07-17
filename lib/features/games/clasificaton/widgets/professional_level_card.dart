import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'safe_image.dart';

/// Professional level card with stars, completion %, and play button
class ProfessionalLevelCard extends StatefulWidget {
  final int level;
  final String imagePath;
  final String subtitle;
  final int starsEarned; // 0-3
  final int completionPercent; // 0-100
  final ValueChanged<int> onPlay;
  final bool isLocked;

  const ProfessionalLevelCard({
    super.key,
    required this.level,
    required this.imagePath,
    required this.subtitle,
    required this.starsEarned,
    required this.completionPercent,
    required this.onPlay,
    this.isLocked = false,
  });

  @override
  State<ProfessionalLevelCard> createState() => _ProfessionalLevelCardState();
}

class _ProfessionalLevelCardState extends State<ProfessionalLevelCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.isLocked) setState(() => _isPressed = true);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.isLocked ? null : () {
          HapticFeedback.selectionClick();
          widget.onPlay(widget.level);
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 200),
          child: Hero(
            tag: 'level_${widget.level}',
            transitionOnUserGestures: true,
            child: Container(
              height: 280,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: (_isHovered || _isPressed)
                        ? const Color(0xff79E5B0).withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: (_isHovered || _isPressed) ? 24 : 16,
                    spreadRadius: (_isHovered || _isPressed) ? 4 : 0,
                    offset: Offset(0, (_isHovered || _isPressed) ? 4 : 8),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  SafeImage(
                    assetPath: widget.imagePath,
                    fit: BoxFit.cover,
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),

                  // Lock overlay if locked
                  if (widget.isLocked)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_rounded,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                  // Content
                  if (!widget.isLocked)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top section: Level number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xff79E5B0),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff79E5B0)
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'NIVEL ${widget.level}',
                                  style: const TextStyle(
                                    color: Color(0xff071B2B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ).animate().fadeIn().slideX(
                                    begin: -0.3,
                                    duration: 600.ms,
                                    curve: Curves.easeOutBack,
                                  ),

                              // Stars display
                              Row(
                                children: [
                                  for (int i = 0; i < 3; i++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        i < widget.starsEarned ? '★' : '☆',
                                        style: TextStyle(
                                          color: i < widget.starsEarned
                                              ? const Color(0xffFFD166)
                                              : Colors.white30,
                                          fontSize: 18,
                                        ),
                                      )
                                          .animate(delay: (100 * i).ms)
                                          .fadeIn()
                                          .scale(
                                            curve: Curves.elasticOut,
                                          ),
                                    ),
                                ],
                              ),
                            ],
                          ),

                          // Bottom section: Subtitle, progress, button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subtitle
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                                  .animate(delay: 150.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.3),

                              const SizedBox(height: 12),

                              // Completion percentage bar
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: FractionallySizedBox(
                                    widthFactor:
                                        widget.completionPercent / 100.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xff79E5B0),
                                            const Color(0xff4ADE80),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  .animate(delay: 250.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.3),

                              const SizedBox(height: 8),

                              // Percentage text
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.completionPercent}% completado',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '⭐ ${widget.starsEarned}/3',
                                    style: const TextStyle(
                                      color: Color(0xffFFD166),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                                  .animate(delay: 300.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.3),

                              const SizedBox(height: 12),

                              // Play button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      widget.onPlay(widget.level);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xff79E5B0),
                                            const Color(0xff4ADE80),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xff4ADE80)
                                                .withValues(alpha: 0.4),
                                            blurRadius: 12,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Color(0xff071B2B),
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'JUGAR',
                                            style: TextStyle(
                                              color: Color(0xff071B2B),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  .animate(delay: 400.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.4),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
