import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../services/api_service.dart';

class StatusTimeline extends StatelessWidget {
  final String currentStatus;

  const StatusTimeline({super.key, required this.currentStatus});

  // ── Step descriptions ─────────────────────────────────────
  static const Map<String, String> _descriptions = {
    'Submitted': 'Your report has been received and logged.',
    'Evidence Verified': 'Our team has reviewed and verified your evidence.',
    'Under Review': 'Your case is being actively investigated.',
    'Takedown Sent': 'A DMCA takedown notice has been sent.',
    'Resolved': 'Your case has been successfully resolved.',
  };

  // ── Step icons ────────────────────────────────────────────
  static const Map<String, IconData> _icons = {
    'Submitted': Icons.check_circle_outline_rounded,
    'Evidence Verified': Icons.verified_outlined,
    'Under Review': Icons.manage_search_rounded,
    'Takedown Sent': Icons.send_rounded,
    'Resolved': Icons.shield_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final steps = ShieldNetValues.statusSteps;
    final currentIndex = steps.indexOf(currentStatus);
    final activeIndex = currentIndex == -1 ? 0 : currentIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final isCompleted = i < activeIndex;
        final isCurrent = i == activeIndex;
        final isLast = i == steps.length - 1;

        Color dotColor;
        Color lineColor;
        Color textColor;
        Color descColor;
        Color bgColor;
        Widget dotChild;

        if (isCompleted) {
          dotColor = AppTheme.success;
          lineColor = AppTheme.success;
          textColor = AppTheme.textPrimary;
          descColor = AppTheme.textSecondary;
          bgColor = AppTheme.success.withValues(alpha: 0.15);
          dotChild = const Icon(
            Icons.check_rounded,
            size: 12,
            color: Colors.white,
          );
        } else if (isCurrent) {
          dotColor = AppTheme.purple;
          lineColor = AppTheme.border;
          textColor = AppTheme.textPrimary;
          descColor = AppTheme.textSecondary;
          bgColor = AppTheme.purple.withValues(alpha: 0.15);
          dotChild = Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          );
        } else {
          dotColor = AppTheme.border;
          lineColor = AppTheme.border;
          textColor = AppTheme.textSecondary;
          descColor = AppTheme.textSecondary.withValues(alpha: 0.5);
          bgColor = Colors.transparent;
          dotChild = const SizedBox();
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Left column: dot + line ───────────────
            Column(
              children: [
                // Dot
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                    border: Border.all(
                      color: dotColor,
                      width: isCurrent ? 2 : 1.5,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppTheme.purple.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(child: dotChild),
                ),
                // Line
                if (!isLast)
                  Container(
                    width: 2,
                    height: 52,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: lineColor,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // ── Right column: content ─────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 4,
                  bottom: isLast ? 0 : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step name + icon
                    Row(
                      children: [
                        Icon(
                          _icons[steps[i]] ??
                              Icons.circle_outlined,
                          size: 14,
                          color: isCurrent || isCompleted
                              ? dotColor
                              : AppTheme.textSecondary
                                  .withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          steps[i],
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : isCompleted
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.purple
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.purple
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'Current',
                              style: GoogleFonts.inter(
                                color: AppTheme.purple,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        if (isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.success
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Done',
                              style: GoogleFonts.inter(
                                color: AppTheme.success,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      _descriptions[steps[i]] ?? '',
                      style: GoogleFonts.inter(
                        color: descColor,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}