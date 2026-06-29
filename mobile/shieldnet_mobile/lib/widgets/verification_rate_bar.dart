import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme.dart';

class VerificationRateBar extends StatefulWidget {
  const VerificationRateBar({super.key});

  @override
  State<VerificationRateBar> createState() => _VerificationRateBarState();
}

class _VerificationRateBarState extends State<VerificationRateBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ApiService.getStats();
      final pct = (result['evidence_verified_pct'] as num?)?.toDouble() ?? 0;
      setState(() {
        _loading = false;
      });
      _animation = Tween<double>(begin: 0, end: pct / 100).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    } catch (e) {
      setState(() {
        _error = 'Could not load live verification rate.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EVIDENCE VERIFICATION RATE',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 14),
          if (_loading)
            const SizedBox(
              height: 22,
              child: Center(
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_error != null)
            Text(_error!, style: Theme.of(context).textTheme.bodyMedium)
          else
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _animation.value,
                          minHeight: 10,
                          backgroundColor: AppTheme.border,
                          valueColor: const AlwaysStoppedAnimation(
                            AppTheme.purple,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(_animation.value * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 12),
          Text(
            'Reports are checked by AI before being escalated for review.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}