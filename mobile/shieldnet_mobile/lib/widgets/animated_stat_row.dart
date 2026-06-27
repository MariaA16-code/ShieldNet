import 'package:flutter/material.dart';

class AnimatedStatRow extends StatefulWidget {
  final num value;
  final String suffix;
  final String label;

  const AnimatedStatRow({
    super.key,
    required this.value,
    required this.label,
    this.suffix = '',
  });

  @override
  State<AnimatedStatRow> createState() => _AnimatedStatRowState();
}

class _AnimatedStatRowState extends State<AnimatedStatRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0, end: widget.value.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedStatRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value.toDouble(),
        end: widget.value.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double v) {
    if (widget.value == widget.value.roundToDouble()) {
      return v.round().toString();
    }
    return v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Row(
          children: [
            Text(
              '${_formatValue(_animation.value)}${widget.suffix}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 32,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.label.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      letterSpacing: 0.8,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}