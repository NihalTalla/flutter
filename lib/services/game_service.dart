import '../models/game_result.dart';
import '../utils/constants.dart';

class GameService {
  static int calculateTttScore({
    required GameResultType result,
    required String difficulty,
  }) {
    int base;
    switch (result) {
      case GameResultType.win:
        base = AppConstants.winPoints;
        break;
      case GameResultType.draw:
        base = AppConstants.drawPoints;
        break;
      case GameResultType.loss:
        base = AppConstants.lossPoints;
        break;
    }
    int diffBonus = difficulty == 'Hard'
        ? AppConstants.hardBonus
        : difficulty == 'Medium'
            ? AppConstants.mediumBonus
            : AppConstants.easyBonus;
    return base + diffBonus;
  }

  static int calculateXp({required GameResultType result}) {
    switch (result) {
      case GameResultType.win:
        return AppConstants.winXp;
      case GameResultType.draw:
        return AppConstants.drawXp;
      case GameResultType.loss:
        return AppConstants.lossXp;
    }
  }

  static int calculateMemoryScore({
    required int pairs,
    required int moves,
    required int timeSeconds,
    required String difficulty,
  }) {
    if (pairs == 0) return 0;
    int base = pairs * 100;
    int movePenalty = (moves - pairs).clamp(0, 999) * 3;
    int timePenalty = timeSeconds * 2;
    int diffBonus = difficulty == 'Hard'
        ? 300
        : difficulty == 'Medium'
            ? 150
            : 0;
    return (base - movePenalty - timePenalty + diffBonus).clamp(0, 9999);
  }

  static List<Map<String, dynamic>> generateLeaderboard({
    required String playerName,
    required String playerAvatar,
    required int playerPoints,
  }) {
    final sampleData = [
      {'name': 'Alex', 'avatar': '🏆', 'points': 2450, 'level': 8},
      {'name': 'Rahul', 'avatar': '⚡', 'points': 1950, 'level': 7},
      {'name': 'Sarah', 'avatar': '💎', 'points': 1820, 'level': 6},
      {'name': 'John', 'avatar': '🔥', 'points': 1650, 'level': 6},
      {'name': 'Priya', 'avatar': '🦊', 'points': 1420, 'level': 5},
      {'name': 'Arjun', 'avatar': '🐲', 'points': 1200, 'level': 5},
      {'name': 'Emma', 'avatar': '🎯', 'points': 980, 'level': 4},
      {'name': 'Vikram', 'avatar': '🕹️', 'points': 750, 'level': 3},
      {'name': 'Mia', 'avatar': '👾', 'points': 540, 'level': 2},
    ];

    final playerEntry = {
      'name': playerName,
      'avatar': playerAvatar,
      'points': playerPoints,
      'isPlayer': true,
      'level': 1,
    };

    final List<Map<String, dynamic>> all = [
      ...sampleData.map((e) => {...e, 'isPlayer': false}),
      playerEntry,
    ];
    all.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
    return all;
  }
}
