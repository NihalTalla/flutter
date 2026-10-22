enum GameResultType { win, loss, draw }

class GameResult {
  final String gameId;
  final String gameName;
  final GameResultType result;
  final int score;
  final int xpEarned;
  final DateTime timestamp;
  final String? detail;

  const GameResult({
    required this.gameId,
    required this.gameName,
    required this.result,
    required this.score,
    required this.xpEarned,
    required this.timestamp,
    this.detail,
  });

  String get resultLabel {
    switch (result) {
      case GameResultType.win:
        return 'Victory';
      case GameResultType.loss:
        return 'Defeat';
      case GameResultType.draw:
        return 'Draw';
    }
  }

  Map<String, dynamic> toMap() => {
        'gameId': gameId,
        'gameName': gameName,
        'result': result.index,
        'score': score,
        'xpEarned': xpEarned,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'detail': detail,
      };

  factory GameResult.fromMap(Map<String, dynamic> map) => GameResult(
        gameId: map['gameId'] ?? '',
        gameName: map['gameName'] ?? '',
        result: GameResultType.values[map['result'] ?? 0],
        score: map['score'] ?? 0,
        xpEarned: map['xpEarned'] ?? 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
        detail: map['detail'],
      );
}
