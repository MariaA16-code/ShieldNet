import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StatusTimeline extends StatelessWidget {
  final String currentStatus;

  const StatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = ShieldNetValues.statusSteps;
    final currentIndex = steps.indexOf(currentStatus);
    final activeIndex = currentIndex == -1 ? 0 : currentIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final isComplete = i <= activeIndex;
        final isLast = i == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isComplete
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isComplete
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                  child: isComplete
                      ? const Icon(Icons.check, size: 14, color: Colors.black)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 36,
                    color: i < activeIndex
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                steps[i],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          i == activeIndex ? FontWeight.w600 : FontWeight.w400,
                      color: isComplete
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
            ),
          ],
        );
      }),
    );
  }
}