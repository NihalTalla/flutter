enum GameCategory { casual, competitive }

class GameInfo {
  final String id;
  final String name;
  final String description;
  final String icon;
  final GameCategory category;
  final bool hasDifficulty;
  final String route;

  const GameInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.hasDifficulty,
    required this.route,
  });

  static const List<GameInfo> all = [
    GameInfo(
      id: 'memory_match',
      name: 'Memory Match',
      description: 'Flip cards and find matching pairs',
      icon: '🃏',
      category: GameCategory.casual,
      hasDifficulty: true,
      route: '/memory-match',
    ),
    GameInfo(
      id: 'rps',
      name: 'Rock Paper Scissors',
      description: 'Classic hand battle against the computer',
      icon: '✊',
      category: GameCategory.casual,
      hasDifficulty: false,
      route: '/rps',
    ),
    GameInfo(
      id: 'ttt',
      name: 'Tic-Tac-Toe',
      description: 'Compete for rankings in classic Tic-Tac-Toe',
      icon: '⚔️',
      category: GameCategory.competitive,
      hasDifficulty: true,
      route: '/ttt',
    ),
  ];

  static List<GameInfo> get casual =>
      all.where((g) => g.category == GameCategory.casual).toList();

  static List<GameInfo> get competitive =>
      all.where((g) => g.category == GameCategory.competitive).toList();
}
