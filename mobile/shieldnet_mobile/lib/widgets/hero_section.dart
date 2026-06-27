import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class HeroSection extends StatelessWidget {
  final String eyebrow;
  final String headline;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HeroSection({
    super.key,
    required this.eyebrow,
    required this.headline,
    this.subtitle,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 28, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.purple.withValues(alpha: 0.14),
            AppTheme.background,
          ],
        ),
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: GoogleFonts.inter(
              color: AppTheme.blue,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            headline,
            style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}