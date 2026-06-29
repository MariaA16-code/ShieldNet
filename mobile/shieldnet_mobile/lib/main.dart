import 'package:flutter/material.dart';
import 'theme.dart';
import 'main_screen.dart';

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
      theme: AppTheme.theme,
      home: const MainScreen(),
    );
  }
}