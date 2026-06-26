import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';
import 'screens/track_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/help_screen.dart';

void main() {
  runApp(const ShieldNetApp());
}

class ShieldNetApp extends StatelessWidget {
  const ShieldNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShieldNet',
      debugShowCheckedModeBanner: false,
      theme: ShieldNetTheme.theme,
      home: const MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _current = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ReportScreen(),
    TrackScreen(),
    StatisticsScreen(),
    HelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_current],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: ShieldNetTheme.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _current,
          onTap: (i) => setState(() => _current = i),
          backgroundColor: ShieldNetTheme.card,
          selectedItemColor: ShieldNetTheme.purple,
          unselectedItemColor: ShieldNetTheme.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),      activeIcon: Icon(Icons.home),          label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.report_outlined),    activeIcon: Icon(Icons.report),        label: 'Report'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes),      activeIcon: Icon(Icons.track_changes), label: 'Track'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart),     label: 'Stats'),
            BottomNavigationBarItem(icon: Icon(Icons.help_outline),       activeIcon: Icon(Icons.help),          label: 'Help'),
          ],
        ),
      ),
    );
  }
}