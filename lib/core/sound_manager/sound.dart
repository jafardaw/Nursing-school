import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playEntrySound() async {
    await _player.play(AssetSource('sounds/entry.mp3'));
  }

  static Future<void> playExitSound() async {
    await _player.play(AssetSource('sounds/exit.mp3'));
  }

  static Future<void> playErrorSound() async {
    await _player.play(AssetSource('sounds/error.mp3'));
  }
}
