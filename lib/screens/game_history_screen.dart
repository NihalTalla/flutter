import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({super.key});

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

  String _resultIcon(GameResultType r) {
    switch (r) {
      case GameResultType.win:
        return '🏆';
      case GameResultType.loss:
        return '💀';
      case GameResultType.draw:
        return '🤝';
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = PlayerService.instance.history;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Match History'),
        backgroundColor: AppTheme.surface,
      ),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('📋', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 16),
                  Text(
                    'No matches yet',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Play a game to see your history here',
                    style: TextStyle(color: AppTheme.onSurfaceDim),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                final r = history[i];
                final color = _resultColor(r.result);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: color.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(_resultIcon(r.result),
                              style: const TextStyle(fontSize: 22)),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              r.resultLabel,
                              style: TextStyle(
                                color: color,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (r.detail != null)
                              Text(
                                r.detail!,
                                style: const TextStyle(
                                    color: AppTheme.onSurfaceDim, fontSize: 11),
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
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+${r.xpEarned} XP',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
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
                );
              },
            ),
    );
  }
}
