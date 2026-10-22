class AppConstants {
  static const String appName = 'GameHub';
  static const String appSubtitle = 'Casual & Competitive Gaming';

  // XP thresholds per level
  static const List<int> levelXp = [0, 500, 1000, 2000, 3500, 5500, 8000, 11000, 15000, 20000];

  // Scoring
  static const int winPoints = 100;
  static const int drawPoints = 25;
  static const int lossPoints = 10;
  static const int winXp = 50;
  static const int drawXp = 15;
  static const int lossXp = 5;

  // Difficulty bonuses
  static const int easyBonus = 0;
  static const int mediumBonus = 25;
  static const int hardBonus = 50;

  // Storage keys
  static const String keyPlayerName = 'player_name';
  static const String keyPlayerAvatar = 'player_avatar';
  static const String keyTotalGames = 'total_games';
  static const String keyWins = 'wins';
  static const String keyLosses = 'losses';
  static const String keyDraws = 'draws';
  static const String keyTotalPoints = 'total_points';
  static const String keyXp = 'xp';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyHighestStreak = 'highest_streak';
  static const String keyGameHistory = 'game_history';
  static const String keyBestScoreTtt = 'best_score_ttt';
  static const String keyBestScoreMemory = 'best_score_memory';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Avatar options (emoji)
  static const List<String> avatars = [
    '🎮', '🕹️', '👾', '🎯', '🏆', '⚡', '🔥', '💎', '🦊', '🐲',
  ];

  // Sample leaderboard names
  static const List<String> sampleNames = [
    'Alex', 'Rahul', 'Sarah', 'John', 'Priya',
    'Arjun', 'Emma', 'Vikram', 'Mia', 'Kiran',
  ];
}
