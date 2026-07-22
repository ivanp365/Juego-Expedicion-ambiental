import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Tarjeta de jugador estilo HUD gamificado.
/// Muestra avatar, nivel, título, XP y moneda de hojas.
class ProPlayerCard extends StatefulWidget {
  final int level;
  final int currentXp;
  final int maxXp;
  final int leaves;
  final String playerName;
  final String? avatarAsset;
  final VoidCallback? onTap;

  const ProPlayerCard({
    super.key,
    required this.level,
    required this.currentXp,
    required this.maxXp,
    required this.leaves,
    this.playerName = 'Explorador',
    this.avatarAsset,
    this.onTap,
  });

  @override
  State<ProPlayerCard> createState() => _ProPlayerCardState();
}

class _ProPlayerCardState extends State<ProPlayerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _xpController;
  late Animation<double> _xpAnimation;
  int _displayedXp = 0;

  @override
  void initState() {
    super.initState();
    _xpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _xpAnimation = Tween<double>(begin: 0, end: widget.currentXp.toDouble())
        .animate(
          CurvedAnimation(parent: _xpController, curve: Curves.easeOutCubic),
        );

    _xpAnimation.addListener(() {
      setState(() {
        _displayedXp = _xpAnimation.value.toInt();
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _xpController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant ProPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentXp != widget.currentXp) {
      _xpAnimation =
          Tween<double>(
            begin: _displayedXp.toDouble(),
            end: widget.currentXp.toDouble(),
          ).animate(
            CurvedAnimation(parent: _xpController, curve: Curves.easeOutCubic),
          );
      _xpController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _xpController.dispose();
    super.dispose();
  }

  String get _rankTitle {
    if (widget.level >= 10) return 'Guardián del Bosque';
    if (widget.level >= 7) return 'Eco-Héroe';
    if (widget.level >= 5) return 'Ranger Natural';
    if (widget.level >= 3) return 'Aprendiz Ambiental';
    return 'Novato Verde';
  }

  @override
  Widget build(BuildContext context) {
    final xpProgress = widget.maxXp > 0 ? widget.currentXp / widget.maxXp : 0.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.activeCardGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.leafGreen.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: AppColors.leafGreen.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playerName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.leafGreen,
                                    AppColors.success,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.leafGreen.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                'Nv. ${widget.level}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.neonGreen.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _rankTitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.neonGreen.withValues(
                                  alpha: 0.9,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildLeavesCounter(),
                ],
              ),
              const SizedBox(height: 16),
              _buildXpBar(xpProgress),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.leafGreen, AppColors.neonGreen],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.leafGreen.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.deepForest,
          border: Border.all(
            color: AppColors.leafGreen.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.transparent,
          backgroundImage: widget.avatarAsset != null
              ? AssetImage(widget.avatarAsset!)
              : null,
          child: widget.avatarAsset == null
              ? const Icon(Icons.person, color: AppColors.neonGreen, size: 28)
              : null,
        ),
      ),
    );
  }

  Widget _buildLeavesCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.forestMid, AppColors.success],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.leafGreen.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.neonGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: 1.1),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: const Icon(
                  Icons.eco_rounded,
                  color: AppColors.neonGreen,
                  size: 20,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            '${widget.leaves}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: 10,
                width:
                    MediaQuery.of(context).size.width *
                    0.75 *
                    progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.leafGreen, AppColors.neonGreen],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.leafGreen.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              Positioned(
                left:
                    MediaQuery.of(context).size.width *
                        0.75 *
                        progress.clamp(0.0, 1.0) -
                    20,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_displayedXp / ${widget.maxXp} XP',
              style: TextStyle(
                color: AppColors.neonGreen.withValues(alpha: 0.8),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: AppColors.neonGreen.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Versión estática para cuando no necesitas animaciones de XP.
class PlayerCardStatic extends StatelessWidget {
  final int level;
  final int currentXp;
  final int maxXp;
  final int leaves;
  final String playerName;
  final String? avatarAsset;
  final VoidCallback? onTap;

  const PlayerCardStatic({
    super.key,
    required this.level,
    required this.currentXp,
    required this.maxXp,
    required this.leaves,
    this.playerName = 'Explorador',
    this.avatarAsset,
    this.onTap,
  });

  String get _rankTitle {
    if (level >= 10) return 'Guardián del Bosque';
    if (level >= 7) return 'Eco-Héroe';
    if (level >= 5) return 'Ranger Natural';
    if (level >= 3) return 'Aprendiz Ambiental';
    return 'Novato Verde';
  }

  @override
  Widget build(BuildContext context) {
    final xpProgress = maxXp > 0 ? currentXp / maxXp : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.activeCardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.leafGreen.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.leafGreen.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.leafGreen, AppColors.neonGreen],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.leafGreen.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.deepForest,
                    backgroundImage: avatarAsset != null
                        ? AssetImage(avatarAsset!)
                        : null,
                    child: avatarAsset == null
                        ? const Icon(
                            Icons.person,
                            color: AppColors.neonGreen,
                            size: 28,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.leafGreen,
                                  AppColors.success,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.leafGreen.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              'Nv. $level',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonGreen.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _rankTitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.neonGreen.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.forestMid, AppColors.success],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.leafGreen.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.neonGreen.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.eco_rounded,
                        color: AppColors.neonGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$leaves',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 10,
                    width:
                        MediaQuery.of(context).size.width *
                        0.75 *
                        xpProgress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.leafGreen, AppColors.neonGreen],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.leafGreen.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentXp / $maxXp XP',
                  style: TextStyle(
                    color: AppColors.neonGreen.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(xpProgress * 100).toInt()}%',
                  style: TextStyle(
                    color: AppColors.neonGreen.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
