import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../main.dart';

class _LanguageOption {
  final Locale locale;
  final String nativeName;

  const _LanguageOption(this.locale, this.nativeName);
}

const List<_LanguageOption> _languageOptions = [
  _LanguageOption(Locale('en'), 'English'),
  _LanguageOption(Locale('ur'), 'اردو'),
  _LanguageOption(Locale('ar'), 'العربية'),
  _LanguageOption(Locale('fr'), 'Français'),
  _LanguageOption(Locale('es'), 'Español'),
];

Future<void> showLanguageMenu(BuildContext context, RelativeRect position) async {
  final currentLocale = Localizations.localeOf(context);

  final selected = await showMenu<Locale>(
    context: context,
    position: position,
    color: AppTheme.cardColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: AppTheme.border),
    ),
    items: [
      for (final option in _languageOptions)
        PopupMenuItem<Locale>(
          value: option.locale,
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: option.locale.languageCode ==
                        currentLocale.languageCode
                    ? Icon(Icons.check, size: 18, color: AppTheme.purple)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                option.nativeName,
                style: GoogleFonts.inter(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: option.locale.languageCode ==
                          currentLocale.languageCode
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  if (selected != null && context.mounted) {
    ShieldNetApp.setLocale(context, selected);
  }
}

RelativeRect languageMenuPositionBelow(BuildContext context) {
  final button = context.findRenderObject() as RenderBox;
  final overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  return RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(
        button.size.bottomLeft(Offset.zero),
        ancestor: overlay,
      ),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );
}

String languageShortLabel(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return 'EN';
    case 'ur':
      return 'UR';
    case 'ar':
      return 'AR';
    case 'fr':
      return 'FR';
    case 'es':
      return 'ES';
    default:
      return locale.languageCode.toUpperCase();
  }
}