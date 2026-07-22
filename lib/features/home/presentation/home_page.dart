import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/player_card.dart';
import '../../games/clasificaton/widgets/animated_background.dart';

/// Página principal del Campamento Base.
/// Punto de entrada del juego con fondo de bosque animado.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  // Datos de ejemplo - reemplazar con tu provider/state
  final _playerData = {
    'name': 'Explorador',
    'level': 2,
    'currentXp': 350,
    'maxXp': 700,
    'leaves': 10,
  };

  final _games = [
    {
      'title': 'CLASIFICATÓN',
      'subtitle': 'Aprende a reciclar jugando',
      'icon': Icons.recycling,
      'isLocked': false,
      'isNew': true,
      'route': '/clasificaton',
    },
    {
      'title': 'LOMBRICARRERA',
      'subtitle': 'Próximamente',
      'icon': Icons.bug_report,
      'isLocked': true,
      'isNew': false,
      'route': null,
    },
    {
      'title': 'TESOROS AMBIENTALES',
      'subtitle': 'Próximamente',
      'icon': Icons.map,
      'isLocked': true,
      'isNew': false,
      'route': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(
            index * 0.15,
            0.3 + index * 0.15,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 30),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(
            index * 0.15,
            0.3 + index * 0.15,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: ForestBackground()),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimations[0],
                    child: SlideTransition(
                      position: _slideAnimations[0],
                      child: _buildGameTitle(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimations[1],
                    child: SlideTransition(
                      position: _slideAnimations[1],
                      child: ProPlayerCard(
                        level: _playerData['level'] as int,
                        currentXp: _playerData['currentXp'] as int,
                        maxXp: _playerData['maxXp'] as int,
                        leaves: _playerData['leaves'] as int,
                        playerName: _playerData['name'] as String,
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimations[2],
                    child: SlideTransition(
                      position: _slideAnimations[2],
                      child: _buildSectionHeader('JUEGOS'),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final game = _games[index];
                    return FadeTransition(
                      opacity: _fadeAnimations[3],
                      child: SlideTransition(
                        position: _slideAnimations[3],
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ProGameCard(
                            title: game['title'] as String,
                            subtitle: game['subtitle'] as String,
                            icon: game['icon'] as IconData,
                            isLocked: game['isLocked'] as bool,
                            isNew: game['isNew'] as bool,
                            onTap: game['route'] != null
                                ? () => Navigator.pushNamed(
                                    context,
                                    game['route'] as String,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }, childCount: _games.length),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fadeAnimations[4],
        child: SlideTransition(
          position: _slideAnimations[4],
          child: const ProBottomNav(currentIndex: 0),
        ),
      ),
    );
  }

  Widget _buildGameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: AppTheme.woodDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.forest_rounded,
                    color: AppColors.neonGreen,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'EXPEDICIÓN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'AMBIENTAL',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonGreen,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    Shadow(
                      color: AppColors.leafGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.deepForest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.goldAccent.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'CAMPAMENTO BASE',
                  style: TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 11,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.leafGreen, AppColors.neonGreen],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.leafGreen.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TARJETA DE JUEGO PROFESIONAL
// ═══════════════════════════════════════════════════════════════

class ProGameCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLocked;
  final bool isNew;
  final VoidCallback? onTap;

  const ProGameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isLocked = false,
    this.isNew = false,
    this.onTap,
  });

  @override
  State<ProGameCard> createState() => _ProGameCardState();
}

class _ProGameCardState extends State<ProGameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLocked) {
      _pressController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.isLocked
        ? AppColors.lockedGradient
        : const LinearGradient(
            colors: [AppColors.cardDark, AppColors.cardGlass],
          );

    final borderColor = widget.isLocked
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.leafGreen.withValues(alpha: 0.3);

    final shadowColor = widget.isLocked
        ? Colors.black.withValues(alpha: 0.15)
        : AppColors.leafGreen.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          final scale = 1 - (_pressController.value * 0.03);

          return Transform.scale(
            scale: scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -2,
                  ),
                  if (!widget.isLocked)
                    BoxShadow(
                      color: AppColors.leafGreen.withValues(alpha: 0.05),
                      blurRadius: 30,
                      offset: const Offset(0, -5),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isLocked
                              ? Colors.white.withValues(alpha: 0.02)
                              : AppColors.leafGreen.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isLocked
                              ? Colors.white.withValues(alpha: 0.01)
                              : AppColors.goldAccent.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: widget.isLocked
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        AppColors.leafGreen,
                                        AppColors.success,
                                      ],
                                    ),
                              color: widget.isLocked
                                  ? const Color(0xFF1A1A2E)
                                  : null,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: widget.isLocked
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : AppColors.neonGreen.withValues(
                                        alpha: 0.3,
                                      ),
                                width: 1.5,
                              ),
                              boxShadow: widget.isLocked
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: AppColors.leafGreen.withValues(
                                          alpha: 0.25,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: Icon(
                              widget.icon,
                              color: widget.isLocked
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: widget.isLocked
                                        ? Colors.white.withValues(alpha: 0.4)
                                        : Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.subtitle,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.isLocked
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : AppColors.neonGreen.withValues(
                                            alpha: 0.9,
                                          ),
                                  ),
                                ),
                                if (widget.isNew) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.warning,
                                          Color(0xFFF4A261),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.warning.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      '¡NUEVO!',
                                      style: TextStyle(
                                        color: Color(0xFF0D2B1D),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          widget.isLocked
                              ? Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.2),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white.withValues(alpha: 0.25),
                                    size: 24,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.leafGreen,
                                        AppColors.success,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.leafGreen.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                        ],
                      ),
                    ),
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

// ═══════════════════════════════════════════════════════════════
// BOTTOM NAVIGATION PROFESIONAL
// ═══════════════════════════════════════════════════════════════

class ProBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const ProBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: AppTheme.woodDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 'Campamento', 0),
          _buildNavItem(Icons.emoji_events_rounded, 'Logros', 1),
          _buildNavItem(Icons.person_rounded, 'Perfil', 2),
          _buildNavItem(Icons.settings_rounded, 'Ajustes', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.leafGreen, AppColors.success],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.leafGreen.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColors.goldAccent.withValues(alpha: 0.7),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : AppColors.goldAccent.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
