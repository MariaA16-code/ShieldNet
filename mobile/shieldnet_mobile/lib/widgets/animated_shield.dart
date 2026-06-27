import 'package:flutter/material.dart';
import '../theme.dart';

class AnimatedShield extends StatefulWidget {
  final double size;

  const AnimatedShield({super.key, this.size = 140});

  @override
  State<AnimatedShield> createState() => _AnimatedShieldState();
}

class _AnimatedShieldState extends State<AnimatedShield>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _rotateController]),
        builder: (context, _) {
          final pulse = 0.85 + (_pulseController.value * 0.15);
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.size * pulse,
                height: widget.size * pulse,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.purple.withValues(alpha: 0.25),
                      AppTheme.purple.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                angle: _rotateController.value * 6.28319,
                child: CustomPaint(
                  size: Size(widget.size * 0.78, widget.size * 0.78),
                  painter: _DashedRingPainter(color: AppTheme.purple),
                ),
              ),
              Icon(
                Icons.shield_outlined,
                size: widget.size * 0.4,
                color: AppTheme.textPrimary,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  final Color color;

  _DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    const dashCount = 24;
    const dashFraction = 0.55;
    final anglePerDash = (2 * 3.14159265) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * anglePerDash;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        anglePerDash * dashFraction,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) => false;
}