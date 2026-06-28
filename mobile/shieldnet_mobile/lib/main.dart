import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'main_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const ShieldNetApp());
}

const String kLanguagePrefKey = 'shieldnet_language_code';

class ShieldNetApp extends StatefulWidget {
  const ShieldNetApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_ShieldNetAppState>();
    state?.setLocale(locale);
  }

  @override
  State<ShieldNetApp> createState() => _ShieldNetAppState();
}

class _ShieldNetAppState extends State<ShieldNetApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(kLanguagePrefKey);
    if (code != null && mounted) {
      setState(() {
        _locale = Locale(code);
      });
    }
  }

  Future<void> setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLanguagePrefKey, locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShieldNet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainScreen(),
    );
  }
}