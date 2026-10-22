import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RockPaperScissorsScreen extends StatefulWidget {
  const RockPaperScissorsScreen({super.key});

  @override
  State<RockPaperScissorsScreen> createState() =>
      _RockPaperScissorsScreenState();
}

class _RockPaperScissorsScreenState extends State<RockPaperScissorsScreen>
    with SingleTickerProviderStateMixin {
  static const choices = ['Rock', 'Paper', 'Scissors'];
  static const emojis = ['✊', '✋', '✌️'];

  int? _playerChoice;
  int? _computerChoice;
  String _result = '';
  int _playerWins = 0;
  int _computerWins = 0;
  int _draws = 0;
  int _streak = 0;
  bool _animating = false;

  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  String _getResult(int player, int computer) {
    if (player == computer) return 'Draw';
    if ((player == 0 && computer == 2) ||
        (player == 1 && computer == 0) ||
        (player == 2 && computer == 1)) return 'Win';
    return 'Loss';
  }

  void _play(int playerChoice) async {
    if (_animating) return;
    setState(() {
      _animating = true;
      _playerChoice = playerChoice;
      _computerChoice = null;
      _result = '';
    });

    _shakeCtrl.reset();
    await _shakeCtrl.forward();

    final computer = Random().nextInt(3);
    final resultStr = _getResult(playerChoice, computer);

    setState(() {
      _computerChoice = computer;
      _result = resultStr;
      _animating = false;
      if (resultStr == 'Win') {
        _playerWins++;
        _streak++;
      } else if (resultStr == 'Loss') {
        _computerWins++;
        _streak = 0;
      } else {
        _draws++;
      }
    });
  }

  void _reset() {
    setState(() {
      _playerChoice = null;
      _computerChoice = null;
      _result = '';
      _playerWins = 0;
      _computerWins = 0;
      _draws = 0;
      _streak = 0;
    });
  }

  Color _resultColor() {
    if (_result == 'Win') return AppTheme.success;
    if (_result == 'Loss') return AppTheme.accent;
    return AppTheme.warning;
  }

  String _resultEmoji() {
    if (_result == 'Win') return '🏆';
    if (_result == 'Loss') return '💀';
    return '🤝';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rock Paper Scissors'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Score row
              Row(
                children: [
                  Expanded(
                      child: _scoreBox('You', _playerWins, AppTheme.primary)),
                  const SizedBox(width: 8),
                  _scoreBox('Draws', _draws, AppTheme.warning),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _scoreBox(
                          'CPU', _computerWins, AppTheme.accent)),
                ],
              ),
              if (_streak > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '$_streak win streak!',
                        style: const TextStyle(
                          color: AppTheme.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Battlefield
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _choiceDisplay(
                            label: 'YOU',
                            index: _playerChoice,
                            color: AppTheme.primary,
                            animate: _animating,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('VS',
                              style: TextStyle(
                                  color: AppTheme.onSurfaceDim,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: _choiceDisplay(
                            label: 'CPU',
                            index: _computerChoice,
                            color: AppTheme.accent,
                            animate: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_result.isNotEmpty)
                      AnimatedOpacity(
                        opacity: _result.isNotEmpty ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: _resultColor().withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: _resultColor().withOpacity(0.4),
                                width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_resultEmoji(),
                                  style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 10),
                              Text(
                                _result == 'Win'
                                    ? 'You Win!'
                                    : _result == 'Loss'
                                        ? 'CPU Wins!'
                                        : "It's a Draw!",
                                style: TextStyle(
                                  color: _resultColor(),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Choice buttons
              const Text(
                'Choose your move',
                style: TextStyle(
                    color: AppTheme.onSurfaceDim, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (i) {
                  final selected = _playerChoice == i && !_animating;
                  return GestureDetector(
                    onTap: () => _play(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary.withOpacity(0.25)
                            : AppTheme.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.cardLight,
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color:
                                      AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emojis[i],
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 2),
                          Text(choices[i],
                              style: const TextStyle(
                                  color: AppTheme.onSurfaceDim,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreBox(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('$value',
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.onSurfaceDim, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _choiceDisplay({
    required String label,
    required int? index,
    required Color color,
    required bool animate,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.onSurfaceDim, fontSize: 12)),
          const SizedBox(height: 6),
          animate
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                  ),
                )
              : Text(
                  index != null ? emojis[index] : '❓',
                  style: const TextStyle(fontSize: 42),
                ),
        ],
      ),
    );
  }
}
