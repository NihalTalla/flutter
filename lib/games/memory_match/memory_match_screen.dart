import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/game_result.dart';
import '../../services/game_service.dart';
import '../../services/player_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/helpers.dart';

class _Card {
  final String emoji;
  bool isFlipped;
  bool isMatched;
  _Card({required this.emoji, this.isFlipped = false, this.isMatched = false});
}

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  static const _emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
    '🐨', '🦁', '🐮', '🐸',
  ];

  String _difficulty = 'Easy';
  late List<_Card> _cards;
  int _firstIndex = -1;
  int _secondIndex = -1;
  bool _checking = false;
  int _moves = 0;
  int _matched = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _gameOver = false;
  bool _started = false;

  int get _pairCount {
    if (_difficulty == 'Hard') return 12;
    if (_difficulty == 'Medium') return 8;
    return 4;
  }

  int get _cols {
    if (_difficulty == 'Hard') return 6;
    return 4;
  }

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupGame() {
    _timer?.cancel();
    final pairs = _emojis.take(_pairCount).toList();
    final all = [...pairs, ...pairs]..shuffle();
    _cards = all.map((e) => _Card(emoji: e)).toList();
    _firstIndex = -1;
    _secondIndex = -1;
    _checking = false;
    _moves = 0;
    _matched = 0;
    _seconds = 0;
    _gameOver = false;
    _started = false;
    setState(() {});
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_gameOver) setState(() => _seconds++);
    });
  }

  void _handleTap(int index) {
    if (_checking || _cards[index].isFlipped || _cards[index].isMatched ||
        _gameOver) return;

    if (!_started) {
      _started = true;
      _startTimer();
    }

    setState(() => _cards[index].isFlipped = true);

    if (_firstIndex == -1) {
      _firstIndex = index;
    } else {
      _secondIndex = index;
      _moves++;
      _checking = true;
      Future.delayed(const Duration(milliseconds: 700), _checkMatch);
    }
  }

  void _checkMatch() {
    if (_cards[_firstIndex].emoji == _cards[_secondIndex].emoji) {
      setState(() {
        _cards[_firstIndex].isMatched = true;
        _cards[_secondIndex].isMatched = true;
        _matched++;
        _firstIndex = -1;
        _secondIndex = -1;
        _checking = false;
      });
      if (_matched == _pairCount) _onComplete();
    } else {
      setState(() {
        _cards[_firstIndex].isFlipped = false;
        _cards[_secondIndex].isFlipped = false;
        _firstIndex = -1;
        _secondIndex = -1;
        _checking = false;
      });
    }
  }

  void _onComplete() {
    _timer?.cancel();
    setState(() => _gameOver = true);
    final score = GameService.calculateMemoryScore(
      pairs: _matched,
      moves: _moves,
      timeSeconds: _seconds,
      difficulty: _difficulty,
    );
    _saveResult(score);
    _showCompleteDialog(score);
  }

  Future<void> _saveResult(int score) async {
    final xp = GameService.calculateXp(result: GameResultType.win);
    await PlayerService.instance.recordResult(GameResult(
      gameId: 'memory_match',
      gameName: 'Memory Match',
      result: GameResultType.win,
      score: score,
      xpEarned: xp,
      timestamp: DateTime.now(),
      detail: '$_difficulty · $_moves moves · ${Helpers.formatDuration(_seconds)}',
    ));
  }

  void _showCompleteDialog(int score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            const Text(
              'COMPLETE!',
              style: TextStyle(
                  color: AppTheme.success,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _statRow('Score', '$score pts', AppTheme.secondary),
            _statRow('Moves', '$_moves', AppTheme.onSurface),
            _statRow('Time', Helpers.formatDuration(_seconds), AppTheme.onSurface),
            _statRow('Difficulty', _difficulty, AppTheme.primary),
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
              _setupGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.onSurfaceDim, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 40 - (_cols - 1) * 8) / _cols;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Memory Match'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _setupGame,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['Easy', 'Medium', 'Hard'].map((d) {
                  final sel = d == _difficulty;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _difficulty = d);
                      _setupGame();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? AppTheme.primary : AppTheme.cardLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(d,
                          style: TextStyle(
                              color: sel
                                  ? Colors.white
                                  : AppTheme.onSurfaceDim,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              // Stats bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoChip('⏱', Helpers.formatDuration(_seconds),
                      AppTheme.secondary),
                  _infoChip('🃏', '$_moves moves', AppTheme.primary),
                  _infoChip('✅', '$_matched/$_pairCount',
                      AppTheme.success),
                ],
              ),
              const SizedBox(height: 16),
              // Grid
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _cols,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (ctx, i) => _CardWidget(
                    card: _cards[i],
                    size: cardSize,
                    onTap: () => _handleTap(i),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class _CardWidget extends StatefulWidget {
  final _Card card;
  final double size;
  final VoidCallback onTap;

  const _CardWidget(
      {required this.card, required this.size, required this.onTap});

  @override
  State<_CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<_CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _anim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _showFront = widget.card.isFlipped || widget.card.isMatched;
    if (_showFront) _ctrl.value = 1;
  }

  @override
  void didUpdateWidget(_CardWidget old) {
    super.didUpdateWidget(old);
    final shouldShow = widget.card.isFlipped || widget.card.isMatched;
    if (shouldShow != _showFront) {
      _showFront = shouldShow;
      if (_showFront) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.card.isMatched ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (ctx, _) {
          final isFirstHalf = _anim.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
                isFirstHalf ? _anim.value * 3.14 : (_anim.value - 1) * 3.14),
            child: isFirstHalf ? _back() : _front(),
          );
        },
      ),
    );
  }

  Widget _back() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryVariant],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text('?', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _front() {
    final matched = widget.card.isMatched;
    return Container(
      decoration: BoxDecoration(
        color: matched
            ? AppTheme.success.withOpacity(0.2)
            : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: matched ? AppTheme.success : AppTheme.card,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          widget.card.emoji,
          style: TextStyle(
              fontSize: matched ? 28 : 26,
              shadows: matched
                  ? [
                      Shadow(
                          color: AppTheme.success.withOpacity(0.5),
                          blurRadius: 8)
                    ]
                  : []),
        ),
      ),
    );
  }
}
