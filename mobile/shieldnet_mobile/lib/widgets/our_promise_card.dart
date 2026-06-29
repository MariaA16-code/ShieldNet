import 'package:flutter/material.dart';
import '../theme.dart';

class PrivacyPromiseCard extends StatelessWidget {
  const PrivacyPromiseCard({super.key});

  static const List<String> _promises = [
    'No account or sign-up required',
    'No name, email, or device ID collected by default',
    'Contact info is optional and never shown publicly',
    'Evidence is used only for verification and takedown',
  ];

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
          Row(
            children: [
              Icon(Icons.verified_user_outlined,
                  color: AppTheme.success, size: 20),
              const SizedBox(width: 10),
              Text('Our Privacy Promise',
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          ..._promises.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle,
                      size: 16, color: AppTheme.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(text,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}