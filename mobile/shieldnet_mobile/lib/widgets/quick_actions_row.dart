import 'package:flutter/material.dart';
import '../theme.dart';

class QuickActionsRow extends StatelessWidget {
  final void Function(int)? onNavigate;

  const QuickActionsRow({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(icon: Icons.report_outlined, label: 'Report', tabIndex: 1),
      _QuickAction(icon: Icons.search_outlined, label: 'Track', tabIndex: 2),
      _QuickAction(
          icon: Icons.bar_chart_outlined, label: 'Stats', tabIndex: 3),
      _QuickAction(icon: Icons.help_outline, label: 'Help', tabIndex: 4),
    ];

    return Row(
      children: actions
          .map(
            (action) => Expanded(
              child: _QuickActionButton(
                action: action,
                onTap: () => onNavigate?.call(action.tabIndex),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final int tabIndex;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.tabIndex,
  });
}

class _QuickActionButton extends StatefulWidget {
  final _QuickAction action;
  final VoidCallback onTap;

  const _QuickActionButton({required this.action, required this.onTap});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Icon(
                  widget.action.icon,
                  color: AppTheme.purple,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.action.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}