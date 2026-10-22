import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final String avatar;
  final int points;
  final bool isPlayer;
  final int level;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.isPlayer,
    this.level = 1,
  });

  @override
  Widget build(BuildContext context) {
    final rankLabel = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : rank == 3
                ? '🥉'
                : '$rank.';
    final bgColor = isPlayer
        ? AppTheme.primary.withOpacity(0.15)
        : AppTheme.cardLight;
    final border = isPlayer
        ? Border.all(color: AppTheme.primary.withOpacity(0.5), width: 1.5)
        : Border.all(color: Colors.transparent);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: border,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              rankLabel,
              style: TextStyle(
                fontSize: rank <= 3 ? 20 : 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(avatar, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: isPlayer ? AppTheme.primary : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (isPlayer) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Lv. $level',
                  style: const TextStyle(
                    color: AppTheme.onSurfaceDim,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$points pts',
            style: TextStyle(
              color: rank == 1
                  ? AppTheme.warning
                  : rank == 2
                      ? AppTheme.onSurface
                      : rank == 3
                          ? const Color(0xFFCD7F32)
                          : AppTheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
