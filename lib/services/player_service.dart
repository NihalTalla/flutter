import '../models/player.dart';
import '../models/game_result.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'storage_service.dart';

class PlayerService {
  static PlayerService? _instance;
  late Player _player;
  late List<GameResult> _history;

  PlayerService._();

  static PlayerService get instance {
    _instance ??= PlayerService._();
    return _instance!;
  }

  Player get player => _player;
  List<GameResult> get history => List.unmodifiable(_history);

  void init() {
    _player = StorageService.instance.loadPlayer();
    _history = StorageService.instance.loadHistory();
  }

  int get level => Helpers.getLevelFromXp(_player.xp);

  Future<void> updateProfile(String name, String avatar) async {
    _player.name = name;
    _player.avatar = avatar;
    await _save();
  }

  Future<int> recordResult(GameResult result) async {
    _player.totalGames++;

    switch (result.result) {
      case GameResultType.win:
        _player.wins++;
        _player.currentStreak++;
        if (_player.currentStreak > _player.highestStreak) {
          _player.highestStreak = _player.currentStreak;
        }
        break;
      case GameResultType.loss:
        _player.losses++;
        _player.currentStreak = 0;
        break;
      case GameResultType.draw:
        _player.draws++;
        break;
    }

    final streakBonus = _player.currentStreak > 2
        ? (_player.currentStreak - 2) * AppConstants.winPoints ~/ 4
        : 0;

    final totalScore = result.score + streakBonus;
    _player.totalPoints += totalScore;
    _player.xp += result.xpEarned;

    if (result.gameId == 'ttt' && totalScore > _player.bestScoreTtt) {
      _player.bestScoreTtt = totalScore;
    }
    if (result.gameId == 'memory_match' && result.score > _player.bestScoreMemory) {
      _player.bestScoreMemory = result.score;
    }

    _history.insert(0, result);
    if (_history.length > 50) _history = _history.sublist(0, 50);

    await _save();
    return totalScore;
  }

  Future<void> reset() async {
    _player = Player(name: _player.name, avatar: _player.avatar);
    _history = [];
    await _save();
  }

  Future<void> _save() async {
    await StorageService.instance.savePlayer(_player);
    await StorageService.instance.saveHistory(_history);
  }
}
