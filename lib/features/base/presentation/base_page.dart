import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../player/application/player_provider.dart';
import '../../../shared/widgets/app_layout.dart';
import '../../../shared/widgets/bottom_navigation.dart';
import '../../../shared/widgets/game_tile.dart';
import '../../../shared/widgets/player_card.dart';

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);

    return AppLayout(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '🌿 Expedición Ambiental',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Campamento Base',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  PlayerCard(player: player),

                  const SizedBox(height: 30),

                  const Text(
                    'Juegos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  GameTile(
                    title: "Clasificatón",
                    subtitle: "Aprende a reciclar jugando",
                    icon: Icons.recycling,
                    // REEMPLAZADO: Redirección directa -> Redirección a la pantalla de introducción
                    onTap: () => context.go('/clasificaton/intro'),
                  ),

                  const SizedBox(height: 16),

                  GameTile(
                    title: "LombriCarrera",
                    subtitle: "Próximamente",
                    icon: Icons.pest_control,
                    onTap: () {},
                  ),

                  const SizedBox(height: 16),

                  GameTile(
                    title: "Tesoros Ambientales",
                    subtitle: "Próximamente",
                    icon: Icons.explore,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          BottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              switch (index) {
                case 0:
                  break;

                case 1:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logros - Próximamente')),
                  );
                  break;

                case 2:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil - Próximamente')),
                  );
                  break;

                case 3:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ajustes - Próximamente')),
                  );
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
