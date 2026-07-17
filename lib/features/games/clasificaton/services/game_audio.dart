/// Centraliza las rutas y los puntos de reproducción de audio del juego.
/// Conecta aquí el reproductor elegido cuando los .mp3 estén disponibles.
class GameAudio {
  static const correct = 'assets/audio/clasificaton/correct.mp3';
  static const wrong = 'assets/audio/clasificaton/wrong.mp3';
  static const click = 'assets/audio/clasificaton/click.mp3';
  static const victory = 'assets/audio/clasificaton/victory.mp3';
  static const countdown = 'assets/audio/clasificaton/countdown.mp3';
  static const drag = 'assets/audio/clasificaton/drag.mp3';
  static const drop = 'assets/audio/clasificaton/drop.mp3';

  static Future<void> play(String asset) async {
    // Intencionalmente preparado sin dependencia ni archivos de audio todavía.
  }
}
