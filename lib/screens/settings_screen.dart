import 'package:flutter/material.dart';
import '../services/player_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _sound;
  late bool _notifications;

  @override
  void initState() {
    super.initState();
    _sound = StorageService.instance.getSoundEnabled();
    _notifications = StorageService.instance.getNotificationsEnabled();
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Reset Game Data',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will reset all your stats, XP, scores and match history.\n\nThis cannot be undone.',
          style: TextStyle(color: AppTheme.onSurfaceDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await PlayerService.instance.reset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game data reset successfully.'),
            backgroundColor: AppTheme.success,
          ),
        );
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.surface,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _sectionLabel('Preferences'),
            _switchTile(
              icon: Icons.volume_up_outlined,
              title: 'Sound Effects',
              subtitle: 'Enable in-game sounds',
              value: _sound,
              onChanged: (v) async {
                await StorageService.instance.setSoundEnabled(v);
                setState(() => _sound = v);
              },
            ),
            _switchTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Game alerts',
              value: _notifications,
              onChanged: (v) async {
                await StorageService.instance.setNotificationsEnabled(v);
                setState(() => _notifications = v);
              },
            ),
            const SizedBox(height: 24),
            _sectionLabel('Theme'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.dark_mode, color: AppTheme.primary),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dark Mode',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        Text('Currently active',
                            style: TextStyle(
                                color: AppTheme.onSurfaceDim, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionLabel('Data'),
            _actionTile(
              icon: Icons.delete_outline,
              iconColor: AppTheme.accent,
              title: 'Reset Game Data',
              subtitle: 'Clear all stats, scores and history',
              onTap: _confirmReset,
            ),
            const SizedBox(height: 24),
            _sectionLabel('About'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('🎮 GameHub',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Casual & Competitive Gaming',
                      style:
                          TextStyle(color: AppTheme.onSurfaceDim, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('Version 1.0.0',
                      style:
                          TextStyle(color: AppTheme.onSurfaceDim, fontSize: 12)),
                  Text('Flutter Lab Project',
                      style:
                          TextStyle(color: AppTheme.onSurfaceDim, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.onSurfaceDim,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppTheme.primary),
        title: Text(title,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppTheme.onSurfaceDim, fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primary,
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppTheme.onSurfaceDim, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceDim),
        onTap: onTap,
      ),
    );
  }
}
