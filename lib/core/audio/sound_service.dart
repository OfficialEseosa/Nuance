import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SoundEffect {
  tap('sfx/tap.ogg'),
  success('sfx/success.ogg'),
  pop('sfx/pop.ogg');

  const SoundEffect(this.assetPath);

  final String assetPath;
}

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();
  static const _soundEnabledKey = 'sound_effects_enabled';

  final AudioPlayer _player = AudioPlayer(playerId: 'nuance_ui_sfx')
    ..setReleaseMode(ReleaseMode.stop);

  bool _enabled = true;

  bool get enabled => _enabled;

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool(_soundEnabledKey) ?? true;
    } catch (_) {
      _enabled = true;
    }
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundEnabledKey, value);
    } catch (_) {
      // Preference persistence should never block UI interactions.
    }
  }

  Future<void> play(SoundEffect effect, {double volume = 0.65}) async {
    if (!_enabled) return;
    try {
      await _player.stop();
      await _player.play(
        AssetSource(effect.assetPath),
        mode: PlayerMode.lowLatency,
        volume: volume,
      );
    } catch (_) {
      // Sound playback should never block UI interactions.
    }
  }

  Future<void> playTap() => play(SoundEffect.tap, volume: 0.55);

  Future<void> playSuccess() => play(SoundEffect.success, volume: 0.72);

  Future<void> playPop() => play(SoundEffect.pop, volume: 0.66);
}
