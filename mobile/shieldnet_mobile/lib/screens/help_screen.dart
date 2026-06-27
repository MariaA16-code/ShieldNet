import 'package:flutter/material.dart';
import '../widgets/hero_section.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'I submitted a report but didn\'t get a token. What happened?',
      'a': 'If the connection dropped before the confirmation loaded, your '
          'report may not have been saved. Please submit it again — '
          'duplicate reports are not a problem on our end.',
    },
    {
      'q': 'I lost my tracking token. Can I get it back?',
      'a': 'If you provided contact info when reporting, the admin team '
          'can verify your identity and resend it. Otherwise, since '
          'ShieldNet stores no personal data by default, the token '
          'cannot be recovered.',
    },
    {
      'q': 'Will the harasser find out I reported them?',
      'a': 'No. Reports are completely anonymous unless you choose to '
          'provide contact details, and that information is only ever '
          'visible to the admin team — never to the person you reported.',
    },
    {
      'q': 'Is my identity really anonymous?',
      'a': 'Yes. By default we collect no name, account, or device '
          'identifier. The contact field is optional and used only for '
          'follow-up if you provide it.',
    },
    {
      'q': 'What happens to my evidence after I submit it?',
      'a': 'Evidence is analyzed to help verify the report, then stored '
          'securely and used only for the takedown and review process.',
    },
    {
      'q': 'What if I need urgent help right now?',
      'a': 'If you are in immediate danger, contact local emergency '
          'services first. For cyber harassment specifically, you can '
          'call the FIA Cybercrime Helpline at 1991.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: SingleChildScrollView(
        child: HeroSection(
          eyebrow: 'Support',
          headline: 'Help & FAQ',
          subtitle:
              'Answers to common questions about using ShieldNet. If you '
              'don\'t see what you\'re looking for, you can reach out at '
              'the bottom of this page.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._faqs.map((faq) => _FaqTile(
                    question: faq['q']!,
                    answer: faq['a']!,
                  )),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Still stuck?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If your question wasn\'t answered above, you can '
                      'email us directly and we\'ll do our best to help.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Opens the device's email app — wired up with
                        // url_launcher once a real support address exists.
                      },
                      child: const Text('Email us'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.remove : Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.answer,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}