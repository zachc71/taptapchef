import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService instance = SoundService._internal();
  factory SoundService() => instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playCook() => _player.play(AssetSource('sounds/cook.wav'));
  Future<void> playCash() => _player.play(AssetSource('sounds/cash.wav'));
  Future<void> playUi() => _player.play(AssetSource('sounds/ui.wav'));
}
