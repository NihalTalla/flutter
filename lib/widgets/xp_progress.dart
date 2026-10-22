import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class XpProgressWidget extends StatelessWidget {
  final int xp;
  final bool showLabel;

  const XpProgressWidget({super.key, required this.xp, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final level = Helpers.getLevelFromXp(xp);
    final current = Helpers.getXpForCurrentLevel(xp);
    final next = Helpers.getXpForNextLevel(xp);
    final progress = Helpers.getLevelProgress(xp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $level',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '$xp / $next XP',
                style: const TextStyle(
                  color: AppTheme.onSurfaceDim,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        if (showLabel) const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppTheme.cardLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ],
    );
  }
}
