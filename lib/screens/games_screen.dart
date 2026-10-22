import 'package:flutter/material.dart';
import '../models/game.dart';
import '../theme/app_theme.dart';
import '../widgets/game_card.dart';
import '../widgets/section_header.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: AppTheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.15),
                      AppTheme.secondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Text('🎲', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Games',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Choose a game to play',
                            style: TextStyle(
                              color: AppTheme.onSurfaceDim,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Casual Games', badge: 'CASUAL'),
              ...GameInfo.casual.map(
                (g) => GameCard(
                  game: g,
                  onPlay: () => Navigator.of(context).pushNamed(g.route),
                ),
              ),
              const SizedBox(height: 8),
              const SectionHeader(title: 'Competitive', badge: 'COMPETITIVE'),
              ...GameInfo.competitive.map(
                (g) => GameCard(
                  game: g,
                  onPlay: () => Navigator.of(context).pushNamed(g.route),
                ),
              ),
              const SizedBox(height: 24),
              // Scoring info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppTheme.warning.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⭐ Scoring System',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _scoreRow('Win', '+100 pts', AppTheme.success),
                    _scoreRow('Draw', '+25 pts', AppTheme.warning),
                    _scoreRow('Loss', '+10 pts', AppTheme.onSurfaceDim),
                    _scoreRow('Hard Difficulty', '+50 bonus', AppTheme.accent),
                    _scoreRow('Win Streak Bonus', '×streak', AppTheme.primary),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppTheme.onSurfaceDim, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
