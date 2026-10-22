import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/game_result.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/game_card.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/xp_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _reload() => setState(() {});

  Color _resultColor(GameResultType r) {
    switch (r) {
      case GameResultType.win:
        return AppTheme.success;
      case GameResultType.loss:
        return AppTheme.accent;
      case GameResultType.draw:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ps = PlayerService.instance;
    final player = ps.player;
    final level = ps.level;
    final history = ps.history.take(3).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _reload(),
          color: AppTheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: AppTheme.onSurfaceDim,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            player.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/profile').then((_) => _reload()),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppTheme.primary.withOpacity(0.4), width: 2),
                        ),
                        child: Center(
                          child: Text(player.avatar,
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // XP progress
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.2),
                        AppTheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.3), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'LVL $level',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${player.xp} XP total',
                            style: const TextStyle(
                              color: AppTheme.onSurfaceDim,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      XpProgressWidget(xp: player.xp),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Quick stats
                const SectionHeader(title: 'Quick Stats'),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Games',
                        value: '${player.totalGames}',
                        color: AppTheme.secondary,
                        icon: '🎮',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        label: 'Wins',
                        value: '${player.wins}',
                        color: AppTheme.success,
                        icon: '🏆',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        label: 'Best Score',
                        value: '${player.bestScoreTtt > player.bestScoreMemory ? player.bestScoreTtt : player.bestScoreMemory}',
                        color: AppTheme.warning,
                        icon: '⭐',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Casual games
                const SectionHeader(title: 'Casual Games', badge: 'CASUAL'),
                ...GameInfo.casual.map(
                  (g) => GameCard(
                    game: g,
                    onPlay: () => Navigator.of(context)
                        .pushNamed(g.route)
                        .then((_) => _reload()),
                  ),
                ),
                const SizedBox(height: 8),
                const SectionHeader(
                    title: 'Competitive', badge: 'COMPETITIVE'),
                ...GameInfo.competitive.map(
                  (g) => GameCard(
                    game: g,
                    onPlay: () => Navigator.of(context)
                        .pushNamed(g.route)
                        .then((_) => _reload()),
                  ),
                ),
                // Recent activity
                if (history.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Recent Activity',
                    actionLabel: 'See All',
                    onAction: () =>
                        Navigator.of(context).pushNamed('/history').then((_) => _reload()),
                  ),
                  ...history.map(
                    (r) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cardLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _resultColor(r.result).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                r.result == GameResultType.win
                                    ? '🏆'
                                    : r.result == GameResultType.draw
                                        ? '🤝'
                                        : '💀',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.gameName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  r.resultLabel,
                                  style: TextStyle(
                                    color: _resultColor(r.result),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '+${r.score} pts',
                                style: const TextStyle(
                                  color: AppTheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                Helpers.formatDate(r.timestamp),
                                style: const TextStyle(
                                  color: AppTheme.onSurfaceDim,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
