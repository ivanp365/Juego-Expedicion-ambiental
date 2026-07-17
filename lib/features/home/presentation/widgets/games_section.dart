import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/game_tile.dart';

class GamesSection extends StatelessWidget {
  const GamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTile(
          title: "Clasificatón",
          subtitle: "Aprende a reciclar jugando",
          icon: Icons.recycling,
          onTap: () => context.go('/clasificaton'),
        ),
        const SizedBox(height: 15),
        GameTile(
          title: "LombriCarrera",
          subtitle: "Muy pronto",
          icon: Icons.pest_control,
          onTap: () {},
        ),
        const SizedBox(height: 15),
        GameTile(
          title: "Tesoros Ambientales",
          subtitle: "Muy pronto",
          icon: Icons.explore,
          onTap: () {},
        ),
      ],
    );
  }
}
