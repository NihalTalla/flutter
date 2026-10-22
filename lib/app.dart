import 'package:flutter/material.dart';
import 'games/memory_match/memory_match_screen.dart';
import 'games/rock_paper_scissors/rock_paper_scissors_screen.dart';
import 'games/tic_tac_toe/tic_tac_toe_screen.dart';
import 'screens/game_history_screen.dart';
import 'screens/games_screen.dart';
import 'screens/home_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class GameHubApp extends StatelessWidget {
  const GameHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const SplashScreen(),
        '/home': (ctx) => const MainShell(),
        '/history': (ctx) => const GameHistoryScreen(),
        '/settings': (ctx) => const SettingsScreen(),
        '/profile': (ctx) => const ProfileScreen(),
        '/memory-match': (ctx) => const MemoryMatchScreen(),
        '/rps': (ctx) => const RockPaperScissorsScreen(),
        '/ttt': (ctx) => const TicTacToeScreen(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    GamesScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.primary.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppTheme.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.games_outlined),
            selectedIcon: Icon(Icons.games, color: AppTheme.primary),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard, color: AppTheme.primary),
            label: 'Leaderboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppTheme.primary),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 3
          ? FloatingActionButton.small(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              backgroundColor: AppTheme.card,
              foregroundColor: AppTheme.onSurfaceDim,
              tooltip: 'Settings',
              child: const Icon(Icons.settings_outlined),
            )
          : null,
    );
  }
}
