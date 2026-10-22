import 'package:flutter/material.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/stat_card.dart';
import '../widgets/xp_progress.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showEditProfile() {
    final player = PlayerService.instance.player;
    final nameCtrl = TextEditingController(text: player.name);
    String selectedAvatar = player.avatar;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text('Edit Profile',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle:
                        const TextStyle(color: AppTheme.onSurfaceDim),
                    filled: true,
                    fillColor: AppTheme.cardLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLength: 20,
                ),
                const SizedBox(height: 12),
                const Text('Choose Avatar',
                    style: TextStyle(
                        color: AppTheme.onSurfaceDim, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.avatars.map((av) {
                    final selected = av == selectedAvatar;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedAvatar = av),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.primary.withOpacity(0.3)
                              : AppTheme.cardLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? AppTheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(av,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty) {
                  await PlayerService.instance
                      .updateProfile(name, selectedAvatar);
                  if (mounted) {
                    Navigator.pop(ctx);
                    setState(() {});
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = PlayerService.instance.player;
    final level = PlayerService.instance.level;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _showEditProfile,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar + name
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.15),
                      AppTheme.secondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.5), width: 2),
                      ),
                      child: Center(
                        child: Text(player.avatar,
                            style: const TextStyle(fontSize: 40)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Level $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    XpProgressWidget(xp: player.xp),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Stats grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.95,
                children: [
                  StatCard(
                    label: 'Games',
                    value: '${player.totalGames}',
                    color: AppTheme.secondary,
                    icon: '🎮',
                  ),
                  StatCard(
                    label: 'Wins',
                    value: '${player.wins}',
                    color: AppTheme.success,
                    icon: '🏆',
                  ),
                  StatCard(
                    label: 'Losses',
                    value: '${player.losses}',
                    color: AppTheme.accent,
                    icon: '💀',
                  ),
                  StatCard(
                    label: 'Draws',
                    value: '${player.draws}',
                    color: AppTheme.warning,
                    icon: '🤝',
                  ),
                  StatCard(
                    label: 'Win Rate',
                    value: Helpers.winRateText(player.wins, player.totalGames),
                    color: AppTheme.primary,
                    icon: '📊',
                  ),
                  StatCard(
                    label: 'Best Streak',
                    value: '${player.highestStreak}',
                    color: AppTheme.warning,
                    icon: '🔥',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Best scores
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🏅 Best Scores',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _bestRow('⚔️ Tic-Tac-Toe', player.bestScoreTtt),
                    _bestRow('🃏 Memory Match', player.bestScoreMemory),
                    _bestRow('📍 Total Points', player.totalPoints),
                    const Divider(color: AppTheme.cardLight, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('🔥 Current Streak',
                            style: TextStyle(
                                color: AppTheme.onSurfaceDim, fontSize: 13)),
                        Text('${player.currentStreak}',
                            style: const TextStyle(
                                color: AppTheme.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ],
                    ),
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

  Widget _bestRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: AppTheme.onSurfaceDim, fontSize: 13)),
          Text('$value',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }
}
