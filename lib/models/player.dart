class Player {
  String name;
  String avatar;
  int totalGames;
  int wins;
  int losses;
  int draws;
  int totalPoints;
  int xp;
  int currentStreak;
  int highestStreak;
  int bestScoreTtt;
  int bestScoreMemory;

  Player({
    this.name = 'Player',
    this.avatar = '🎮',
    this.totalGames = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.totalPoints = 0,
    this.xp = 0,
    this.currentStreak = 0,
    this.highestStreak = 0,
    this.bestScoreTtt = 0,
    this.bestScoreMemory = 0,
  });

  double get winRate => totalGames == 0 ? 0 : wins / totalGames;

  Map<String, dynamic> toMap() => {
        'name': name,
        'avatar': avatar,
        'totalGames': totalGames,
        'wins': wins,
        'losses': losses,
        'draws': draws,
        'totalPoints': totalPoints,
        'xp': xp,
        'currentStreak': currentStreak,
        'highestStreak': highestStreak,
        'bestScoreTtt': bestScoreTtt,
        'bestScoreMemory': bestScoreMemory,
      };

  factory Player.fromMap(Map<String, dynamic> map) => Player(
        name: map['name'] ?? 'Player',
        avatar: map['avatar'] ?? '🎮',
        totalGames: map['totalGames'] ?? 0,
        wins: map['wins'] ?? 0,
        losses: map['losses'] ?? 0,
        draws: map['draws'] ?? 0,
        totalPoints: map['totalPoints'] ?? 0,
        xp: map['xp'] ?? 0,
        currentStreak: map['currentStreak'] ?? 0,
        highestStreak: map['highestStreak'] ?? 0,
        bestScoreTtt: map['bestScoreTtt'] ?? 0,
        bestScoreMemory: map['bestScoreMemory'] ?? 0,
      );
}
