import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/need_help_card.dart';
import '../widgets/scan_grid_background.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onNavigate;

  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const int _reportTabIndex = 1;
  static const int _helpTabIndex = 4;

  // Fixed list of safety tips — one is picked at random per screen
  // load. No backend dependency.
  static const List<String> _safetyTips = [
    'Screenshot harassment before blocking — evidence helps your case move faster.',
    'Never share your tracking token with anyone. It is the only way to access your case.',
    'Save screenshots with visible usernames, dates, and platform names for stronger evidence.',
    'You can report anonymously — no account or personal details are required.',
    'If you feel unsafe right now, contact local emergency services before filing a report.',
  ];

  late final AnimationController _entranceController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final String _safetyTip;

  @override
  void initState() {
    super.initState();
    _safetyTip = _safetyTips[Random().nextInt(_safetyTips.length)];
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
          parent: _entranceController, curve: Curves.easeOutCubic),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.purple.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.shield_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Shield',
                    style: GoogleFonts.lexend(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'Net',
                    style: GoogleFonts.lexend(
                      color: AppTheme.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.purple,
        backgroundColor: AppTheme.cardColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Scan-grid hero ──────────────────────────────────
                  SizedBox(
                    height: screenHeight * 0.62,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // New signature background — replaces the
                        // never-confirmed earth_bg.jpg asset.
                        ScanGridBackground(height: screenHeight * 0.62),

                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x000A0E16),
                                Color(0x1A00D4FF),
                                Color(0xFF040D12),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                        // Glow behind shield
                        Positioned(
                          top: screenHeight * 0.12,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.purple
                                        .withValues(alpha: 0.35),
                                    blurRadius: 80,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Orbiting nodes — small satellites circling the
                        // shield to read as "actively monitoring".
                        Positioned(
                          top: screenHeight * 0.10 - 25,
                          left: 0,
                          right: 0,
                          child: const Center(child: _OrbitingNodes()),
                        ),
                        // Glowing shield
                        Positioned(
                          top: screenHeight * 0.10,
                          left: 0,
                          right: 0,
                          child: const Center(child: _GlowingShield()),
                        ),
                        // Hero text
                        Positioned(
                          bottom: 32,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Stay aware.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lexend(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Stay ',
                                      style: GoogleFonts.lexend(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w700,
                                        height: 1.15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'protected.',
                                      style: GoogleFonts.lexend(
                                        color: AppTheme.purple,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w700,
                                        height: 1.15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Report incidents. Track updates.\nHelp build a safer digital world.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white
                                      .withValues(alpha: 0.6),
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Action cards ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ActionCard(
                          icon: Icons.edit_document,
                          iconColor: AppTheme.purple,
                          title: 'Report an Incident',
                          subtitle:
                              'Report online harassment or something suspicious.',
                          onTap: () =>
                              widget.onNavigate?.call(_reportTabIndex),
                        ),
                        const SizedBox(height: 12),
                        NeedHelpCard(
                          onTap: () =>
                              widget.onNavigate?.call(_helpTabIndex),
                        ),
                        const SizedBox(height: 12),
                        _SafetyTipCard(tip: _safetyTip),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Orbiting Nodes ───────────────────────────────────────────────────────────
// Two small satellite dots circling the shield at different speeds and
// radii, in opposite directions — reads as "actively monitoring".
class _OrbitingNodes extends StatefulWidget {
  const _OrbitingNodes();

  @override
  State<_OrbitingNodes> createState() => _OrbitingNodesState();
}

class _OrbitingNodesState extends State<_OrbitingNodes>
    with TickerProviderStateMixin {
  late final AnimationController _outerController;
  late final AnimationController _innerController;

  @override
  void initState() {
    super.initState();
    _outerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _innerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Faint reference ring for the outer orbit
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.purple.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
          ),
          // Outer node — clockwise, radius 70
          Positioned.fill(
            child: RotationTransition(
              turns: _outerController,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.purple,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.purple.withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Inner node — counter-clockwise, radius 45
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 90,
                height: 90,
                child: RotationTransition(
                  turns: ReverseAnimation(_innerController),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.blue,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.blue.withValues(alpha: 0.6),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glowing Shield ─────────────────────────────────────────────────────────────
class _GlowingShield extends StatefulWidget {
  const _GlowingShield();

  @override
  State<_GlowingShield> createState() => _GlowingShieldState();
}

class _GlowingShieldState extends State<_GlowingShield>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
          parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.purple
                    .withValues(alpha: 0.5 * _pulse.value),
                blurRadius: 40.0 * _pulse.value,
                spreadRadius: 8.0 * _pulse.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.purple.withValues(alpha: 0.15),
          border: Border.all(
            color: AppTheme.purple.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.verified_user_rounded,
          color: Colors.white,
          size: 42,
        ),
      ),
    );
  }
}

// ── Action Card ────────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Faint top inner highlight — fakes glass catching light
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor.withValues(alpha: 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withValues(alpha: 0.25),
                          blurRadius: 14,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.lexend(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor.withValues(alpha: 0.1),
                    ),
                    child: Icon(Icons.chevron_right,
                        color: iconColor, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Safety Tip Card ───────────────────────────────────────────────────────────
// Static (non-tappable) card showing a single rotating safety tip below
// the two action cards. Purely additive — does not touch the hero,
// background, or any existing widget.
class _SafetyTipCard extends StatelessWidget {
  final String tip;

  const _SafetyTipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.purple.withValues(alpha: 0.08),
            AppTheme.blue.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.purple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              color: AppTheme.purple, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SAFETY TIP',
                  style: GoogleFonts.inter(
                    color: AppTheme.purple,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tip,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}