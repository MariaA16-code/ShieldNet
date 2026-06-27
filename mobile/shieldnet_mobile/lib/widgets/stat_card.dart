import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 26,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  letterSpacing: 0.6,
                ),
          ),
        ],
      ),
    );
  }
}