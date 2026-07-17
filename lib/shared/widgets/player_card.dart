import 'package:flutter/material.dart';

import '../../features/player/domain/player.dart';
import 'xp_bar.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final progress = (player.xp % 100) / 100;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Nivel ${player.level}"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.eco),
                    const SizedBox(width: 5),
                    Text(
                      "${player.ecoCoins}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            XPBar(progress: progress),
          ],
        ),
      ),
    );
  }
}
