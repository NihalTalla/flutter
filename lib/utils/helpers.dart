import '../utils/constants.dart';

class Helpers {
  static int getLevelFromXp(int xp) {
    final thresholds = AppConstants.levelXp;
    int level = 1;
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (xp >= thresholds[i]) {
        level = i + 1;
        break;
      }
    }
    return level;
  }

  static int getXpForNextLevel(int currentXp) {
    final thresholds = AppConstants.levelXp;
    int level = getLevelFromXp(currentXp);
    if (level >= thresholds.length) return thresholds.last;
    return thresholds[level]; // index = level because levels are 1-based
  }

  static int getXpForCurrentLevel(int currentXp) {
    final thresholds = AppConstants.levelXp;
    int level = getLevelFromXp(currentXp);
    return thresholds[level - 1];
  }

  static double getLevelProgress(int currentXp) {
    int current = getXpForCurrentLevel(currentXp);
    int next = getXpForNextLevel(currentXp);
    if (next == current) return 1.0;
    return (currentXp - current) / (next - current);
  }

  static String formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);

    String timeStr =
        '${dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';

    if (date == today) return 'Today, $timeStr';
    if (date == yesterday) return 'Yesterday, $timeStr';
    return '${dt.day}/${dt.month}/${dt.year}, $timeStr';
  }

  static String formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String winRateText(int wins, int total) {
    if (total == 0) return '0%';
    return '${(wins / total * 100).toStringAsFixed(1)}%';
  }
}
