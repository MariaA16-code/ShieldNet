import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// "Our Promise" card — 4-icon grid (Anonymous / Encrypted / No Data /
/// Community), glassmorphism style: translucent fill + backdrop blur +
/// soft border, so the Earth background stays faintly visible through
/// the panel.
class OurPromiseCard extends StatelessWidget {
  const OurPromiseCard({super.key});

  static const List<_Promise> _items = [
    _Promise(Icons.lock_outline, '100%\nAnonymous'),
    _Promise(Icons.shield_outlined, 'Secure &\nEncrypted'),
    _Promise(Icons.person_off_outlined, 'No Personal\nData'),
    _Promise(Icons.groups_outlined, 'Community\nDriven'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.purple.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_outlined,
                      color: AppTheme.purple, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Our Promise',
                    style: GoogleFonts.lexend(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < _items.length; i++) ...[
                    if (i != 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 1,
                          height: 70,
                          color: AppTheme.border.withValues(alpha: 0.6),
                        ),
                      ),
                    Expanded(child: _PromiseTile(item: _items[i])),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Promise {
  final IconData icon;
  final String label;
  const _Promise(this.icon, this.label);
}

class _PromiseTile extends StatelessWidget {
  final _Promise item;
  const _PromiseTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.purple.withValues(alpha: 0.16),
          ),
          child: Icon(item.icon, color: AppTheme.purple, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}