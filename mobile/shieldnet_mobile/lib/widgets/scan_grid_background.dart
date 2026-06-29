import 'package:flutter/material.dart';
import '../theme.dart';

/// Signature hero background: a faint security-grid + a single animated
/// scan-line sweep. Fully custom-painted — no image assets, so it can't
/// silently fail to load on Flutter Web the way `earth_bg.jpg` did.
///
/// Usage: wrap your existing hero `Stack` content in this widget instead
/// of using `Image.asset(...)` as the base layer.
class ScanGridBackground extends StatefulWidget {
  final double height;

  const ScanGridBackground({super.key, required this.height});

  @override
  State<ScanGridBackground> createState() => _ScanGridBackgroundState();
}

class _ScanGridBackgroundState extends State<ScanGridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ScanGridPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _ScanGridPainter extends CustomPainter {
  final double progress;

  _ScanGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Base fill
    final basePaint = Paint()..color = AppTheme.background;
    canvas.drawRect(Offset.zero & size, basePaint);

    // ── Faint grid ─────────────────────────────────────────────
    final gridPaint = Paint()
      ..color = AppTheme.purple.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const spacing = 28.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ── Scan-line sweep ────────────────────────────────────────
    // A soft gradient band that moves top -> bottom -> loops.
    final sweepY = progress * (size.height + 160) - 80;

    final sweepRect = Rect.fromLTWH(0, sweepY - 60, size.width, 120);
    final sweepPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.purple.withValues(alpha: 0.0),
          AppTheme.purple.withValues(alpha: 0.10),
          AppTheme.purple.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(sweepRect);
    canvas.drawRect(sweepRect, sweepPaint);

    // Thin bright leading edge of the sweep line
    final linePaint = Paint()
      ..color = AppTheme.purple.withValues(alpha: 0.22)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(0, sweepY),
      Offset(size.width, sweepY),
      linePaint,
    );

    // ── Vignette so edges fade to pure background ─────────────
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.1,
        colors: [
          Colors.transparent,
          AppTheme.background.withValues(alpha: 0.85),
        ],
        stops: const [0.4, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant _ScanGridPainter oldDelegate) =>
      oldDelegate.progress != progress;
}