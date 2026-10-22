import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/game_result.dart';
import '../utils/constants.dart';

class StorageService {
  static StorageService? _instance;
  late SharedPreferences _prefs;
  bool _initialized = false;

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // Player
  Future<void> savePlayer(Player player) async {
    await _prefs.setString('player', jsonEncode(player.toMap()));
  }

  Player loadPlayer() {
    final raw = _prefs.getString('player');
    if (raw == null) return Player();
    try {
      return Player.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return Player();
    }
  }

  // Game history
  Future<void> saveHistory(List<GameResult> history) async {
    final encoded = history.map((r) => jsonEncode(r.toMap())).toList();
    await _prefs.setStringList(AppConstants.keyGameHistory, encoded);
  }

  List<GameResult> loadHistory() {
    final raw = _prefs.getStringList(AppConstants.keyGameHistory) ?? [];
    return raw.map((s) {
      try {
        return GameResult.fromMap(jsonDecode(s) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<GameResult>().toList();
  }

  // Settings
  bool getSoundEnabled() => _prefs.getBool(AppConstants.keySoundEnabled) ?? true;
  Future<void> setSoundEnabled(bool v) => _prefs.setBool(AppConstants.keySoundEnabled, v);

  bool getNotificationsEnabled() =>
      _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool v) =>
      _prefs.setBool(AppConstants.keyNotificationsEnabled, v);

  // Reset
  Future<void> resetAll() async {
    final soundEnabled = getSoundEnabled();
    final notificationsEnabled = getNotificationsEnabled();
    await _prefs.clear();
    await setSoundEnabled(soundEnabled);
    await setNotificationsEnabled(notificationsEnabled);
  }
}
