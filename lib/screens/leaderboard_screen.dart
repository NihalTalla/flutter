import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/leaderboard_tile.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late List<Map<String, dynamic>> _entries;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  void _loadLeaderboard() {
    final player = PlayerService.instance.player;
    _entries = GameService.generateLeaderboard(
      playerName: player.name,
      playerAvatar: player.avatar,
      playerPoints: player.totalPoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppTheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryVariant],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Global Rankings',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Local Demo Leaderboard',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _entries.length,
                itemBuilder: (ctx, i) {
                  final e = _entries[i];
                  return LeaderboardTile(
                    rank: i + 1,
                    name: e['name'] as String,
                    avatar: e['avatar'] as String,
                    points: e['points'] as int,
                    isPlayer: e['isPlayer'] as bool,
                    level: Helpers.getLevelFromXp(
                        (e['points'] as int) ~/ 2),
                  );
                },
              ),
            ),
            // Note
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppTheme.onSurfaceDim, size: 14),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'This is a local demo leaderboard. Rankings are based on your device data.',
                      style: TextStyle(
                        color: AppTheme.onSurfaceDim,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
