import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/game_result.dart';
import '../../services/game_service.dart';
import '../../services/player_service.dart';
import '../../theme/app_theme.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  static const int empty = 0;
  static const int playerX = 1;
  static const int aiO = 2;

  List<int> _board = List.filled(9, empty);
  bool _playerTurn = true;
  bool _gameOver = false;
  int _winner = empty;
  List<int> _winLine = [];
  String _difficulty = 'Medium';

  int _playerScore = 0;
  int _aiScore = 0;
  int _draws = 0;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
  }

  void _resetBoard() {
    setState(() {
      _board = List.filled(9, empty);
      _playerTurn = true;
      _gameOver = false;
      _winner = empty;
      _winLine = [];
    });
  }

  List<int>? _checkWinner(List<int> board) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (final line in lines) {
      if (board[line[0]] != empty &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        return line;
      }
    }
    return null;
  }

  bool _isDraw(List<int> board) => !board.contains(empty);

  void _handleTap(int index) {
    if (_board[index] != empty || _gameOver || !_playerTurn) return;

    setState(() {
      _board[index] = playerX;
      _playerTurn = false;
    });

    _checkGameState(playerX);
    if (!_gameOver) {
      Future.delayed(const Duration(milliseconds: 400), _aiMove);
    }
  }

  void _aiMove() {
    if (_gameOver) return;
    int move;
    if (_difficulty == 'Easy') {
      move = _randomMove();
    } else if (_difficulty == 'Medium') {
      move = _mediumMove();
    } else {
      move = _minimaxMove();
    }
    setState(() {
      _board[move] = aiO;
      _playerTurn = true;
    });
    _checkGameState(aiO);
  }

  int _randomMove() {
    final empties = <int>[];
    for (int i = 0; i < 9; i++) {
      if (_board[i] == empty) empties.add(i);
    }
    return empties[Random().nextInt(empties.length)];
  }

  int _mediumMove() {
    // Win if possible
    for (int i = 0; i < 9; i++) {
      if (_board[i] == empty) {
        final test = List<int>.from(_board)..[i] = aiO;
        if (_checkWinner(test) != null) return i;
      }
    }
    // Block player win
    for (int i = 0; i < 9; i++) {
      if (_board[i] == empty) {
        final test = List<int>.from(_board)..[i] = playerX;
        if (_checkWinner(test) != null) return i;
      }
    }
    // Take center or random
    if (_board[4] == empty) return 4;
    return _randomMove();
  }

  int _minimaxMove() {
    int bestScore = -1000;
    int bestMove = -1;
    for (int i = 0; i < 9; i++) {
      if (_board[i] == empty) {
        _board[i] = aiO;
        int score = _minimax(_board, false, 0);
        _board[i] = empty;
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  int _minimax(List<int> board, bool isMaximizing, int depth) {
    final winner = _checkWinner(board);
    if (winner != null) return isMaximizing ? -10 + depth : 10 - depth;
    if (_isDraw(board)) return 0;

    if (isMaximizing) {
      int best = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == empty) {
          board[i] = aiO;
          best = max(best, _minimax(board, false, depth + 1));
          board[i] = empty;
        }
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == empty) {
          board[i] = playerX;
          best = min(best, _minimax(board, true, depth + 1));
          board[i] = empty;
        }
      }
      return best;
    }
  }

  void _checkGameState(int lastPlayer) {
    final winLine = _checkWinner(_board);
    if (winLine != null) {
      final winnerVal = _board[winLine[0]];
      setState(() {
        _gameOver = true;
        _winner = winnerVal;
        _winLine = winLine;
        if (winnerVal == playerX) {
          _playerScore++;
        } else {
          _aiScore++;
        }
      });
      _recordResult(
          winnerVal == playerX ? GameResultType.win : GameResultType.loss);
      _showResultDialog();
    } else if (_isDraw(_board)) {
      setState(() {
        _gameOver = true;
        _winner = -1;
        _draws++;
      });
      _recordResult(GameResultType.draw);
      _showResultDialog();
    }
  }

  Future<void> _recordResult(GameResultType result) async {
    final score = GameService.calculateTttScore(
        result: result, difficulty: _difficulty);
    final xp = GameService.calculateXp(result: result);
    await PlayerService.instance.recordResult(GameResult(
      gameId: 'ttt',
      gameName: 'Tic-Tac-Toe',
      result: result,
      score: score,
      xpEarned: xp,
      timestamp: DateTime.now(),
      detail: 'vs AI · $_difficulty',
    ));
  }

  void _showResultDialog() {
    String title, subtitle;
    Color color;
    String emoji;
    if (_winner == playerX) {
      title = 'YOU WIN!';
      subtitle = '+${GameService.calculateTttScore(result: GameResultType.win, difficulty: _difficulty)} pts';
      color = AppTheme.success;
      emoji = '🏆';
    } else if (_winner == aiO) {
      title = 'AI WINS!';
      subtitle = 'Better luck next time';
      color = AppTheme.accent;
      emoji = '💀';
    } else {
      title = 'DRAW!';
      subtitle = '+${GameService.calculateTttScore(result: GameResultType.draw, difficulty: _difficulty)} pts';
      color = AppTheme.warning;
      emoji = '🤝';
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              Text(title,
                  style: TextStyle(
                      color: color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppTheme.onSurfaceDim, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                '+${GameService.calculateXp(result: _winner == playerX ? GameResultType.win : _winner == aiO ? GameResultType.loss : GameResultType.draw)} XP',
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _resetBoard();
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      );
    });
  }

  Color _cellColor(int idx) {
    if (_winLine.contains(idx)) return AppTheme.success.withOpacity(0.25);
    return AppTheme.cardLight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetBoard,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Score
              Row(
                children: [
                  Expanded(
                    child: _scoreBox('YOU (X)', _playerScore,
                        AppTheme.primary, _playerTurn && !_gameOver),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('$_draws',
                        style: const TextStyle(
                            color: AppTheme.onSurfaceDim,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _scoreBox('AI (O)', _aiScore, AppTheme.accent,
                        !_playerTurn && !_gameOver),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _difficulties.map((d) {
                  final selected = d == _difficulty;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _difficulty = d);
                      _resetBoard();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.cardLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        d,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppTheme.onSurfaceDim,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Turn indicator
              Text(
                _gameOver
                    ? (_winner == playerX
                        ? 'You won!'
                        : _winner == aiO
                            ? 'AI won!'
                            : 'Draw!')
                    : (_playerTurn ? 'Your turn (X)' : 'AI thinking…'),
                style: TextStyle(
                  color: _gameOver
                      ? (_winner == playerX ? AppTheme.success : AppTheme.accent)
                      : AppTheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              // Board
              AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (ctx, i) => GestureDetector(
                    onTap: () => _handleTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: _cellColor(i),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _winLine.contains(i)
                              ? AppTheme.success
                              : AppTheme.card,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _board[i] == empty
                              ? const SizedBox.shrink()
                              : Text(
                                  _board[i] == playerX ? 'X' : 'O',
                                  key: ValueKey(_board[i]),
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: _board[i] == playerX
                                        ? AppTheme.primary
                                        : AppTheme.accent,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _resetBoard,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cardLight,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreBox(String label, int score, Color color, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? color.withOpacity(0.5) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$score',
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.onSurfaceDim,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
