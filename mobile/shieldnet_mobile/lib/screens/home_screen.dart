import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../services/api_service.dart';
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
  static const int _trackTabIndex = 2;
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

  // ── Protection status (real data, not decorative) ──────────────────
  // Loads the saved tracking token (same SharedPreferences key used by
  // Track screen) and, if present, fetches that case's real status.
  bool _statusLoading = true;
  String? _activeStatus; // null = no active case found / no token saved

  @override
  void initState() {
    super.initState();
    _safetyTip = _safetyTips[Random().nextInt(_safetyTips.length)];
    _loadProtectionStatus();
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

  Future<void> _loadProtectionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('tracking_token');
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _activeStatus = null;
            _statusLoading = false;
          });
        }
        return;
      }
      final result = await ApiService.trackCase(token);
      final reports = (result['reports'] as List?) ?? [];
      if (reports.isEmpty) {
        if (mounted) {
          setState(() {
            _activeStatus = null;
            _statusLoading = false;
          });
        }
        return;
      }
      final status = reports.first['case_status']?.toString() ??
          reports.first['report_status']?.toString();
      if (mounted) {
        setState(() {
          _activeStatus = status;
          _statusLoading = false;
        });
      }
    } catch (_) {
      // Fails quietly — falls back to the "no active case" state rather
      // than showing an error on the home screen.
      if (mounted) {
        setState(() {
          _activeStatus = null;
          _statusLoading = false;
        });
      }
    }
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

                  // ── Protection status ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _ProtectionStatusCard(
                      loading: _statusLoading,
                      status: _activeStatus,
                      onTap: () =>
                          widget.onNavigate?.call(_trackTabIndex),
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

// ── Protection Status Card ───────────────────────────────────────────────────
// Shows the real status of the device's most recently saved tracked case
// (via SharedPreferences token + ApiService.trackCase), inside a filling
// progress ring around the shield glyph. Falls back to an honest "no
// active case" state rather than showing fake progress.
class _ProtectionStatusCard extends StatelessWidget {
  final bool loading;
  final String? status;
  final VoidCallback onTap;

  const _ProtectionStatusCard({
    required this.loading,
    required this.status,
    required this.onTap,
  });

  // Maps known case_status values to a 0.0–1.0 progress fraction.
  // Unrecognized statuses fall back to a small non-zero fraction so the
  // ring still reads as "something is in progress" rather than empty.
  double _progressFor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('resolved')) return 1.0;
    if (normalized.contains('takedown')) return 0.75;
    if (normalized.contains('review')) return 0.45;
    if (normalized.contains('submit')) return 0.15;
    return 0.3;
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveCase = !loading && status != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            _StatusRing(
              loading: loading,
              progress: hasActiveCase ? _progressFor(status!) : 0.0,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loading
                        ? 'Checking status…'
                        : hasActiveCase
                            ? 'Your safety status'
                            : 'No active case',
                    style: GoogleFonts.lexend(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    loading
                        ? 'Fetching the latest update.'
                        : hasActiveCase
                            ? 'Case status: $status'
                            : 'You have no case currently being tracked.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (hasActiveCase)
              Icon(Icons.chevron_right,
                  color: AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Status Ring ───────────────────────────────────────────────────────────────
class _StatusRing extends StatefulWidget {
  final bool loading;
  final double progress;

  const _StatusRing({required this.loading, required this.progress});

  @override
  State<_StatusRing> createState() => _StatusRingState();
}

class _StatusRingState extends State<_StatusRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progressAnim = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (!widget.loading) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _StatusRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress || oldWidget.loading != widget.loading) {
      _progressAnim = Tween<double>(
        begin: _progressAnim.value,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.loading)
            SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppTheme.purple.withValues(alpha: 0.5),
              ),
            )
          else
            AnimatedBuilder(
              animation: _progressAnim,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(52, 52),
                  painter: _RingPainter(
                    progress: _progressAnim.value,
                    trackColor: AppTheme.purple.withValues(alpha: 0.12),
                    progressColor: AppTheme.purple,
                  ),
                );
              },
            ),
          Icon(
            Icons.shield_outlined,
            color: AppTheme.purple,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * 3.14159265 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


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