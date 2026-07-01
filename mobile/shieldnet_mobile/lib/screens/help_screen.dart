import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
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
          'call the FIA Cybercrime Helpline at 1991 — see the emergency '
          'numbers below.',
    },
  ];

  Future<void> _launchEmail(BuildContext context) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'shieldnet.support@gmail.com',
      queryParameters: {'subject': 'ShieldNet Support Request'},
    );
    try {
      final launched = await launchUrl(emailUri);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open an email app on this device.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open an email app on this device.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: SingleChildScrollView(
        child: HeroSection(
          eyebrow: 'Support',
          headline: 'Help & FAQ',
          subtitle:
              'Answers to common questions about using ShieldNet. '
              'If you don\'t see what you\'re looking for, '
              'you can reach out at the bottom of this page.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── FAQ section ──────────────────────────────────────
              _SectionHeader(
                icon: Icons.help_outline_rounded,
                label: 'FREQUENTLY ASKED QUESTIONS',
              ),
              const SizedBox(height: 12),
              ..._faqs.map((faq) => _FaqTile(
                    question: faq['q']!,
                    answer: faq['a']!,
                  )),
              const SizedBox(height: 24),

              // ── Still stuck card ─────────────────────────────────
              _SupportCard(onEmailTap: () => _launchEmail(context)),
              const SizedBox(height: 28),

              // ── Footer (Platform / Emergency Resources) ──────────
              const _PlatformFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.purple, size: 14),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ── FAQ tile ──────────────────────────────────────────────────────────────────
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? AppTheme.purple.withValues(alpha: 0.45)
              : AppTheme.border,
        ),
        boxShadow: _expanded
            ? [
                BoxShadow(
                  color: AppTheme.purple.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.inter(
                        color: _expanded
                            ? AppTheme.textPrimary
                            : AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _expanded
                          ? AppTheme.purple.withValues(alpha: 0.15)
                          : AppTheme.border.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedRotation(
                      turns: _expanded ? 0.125 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.add,
                        color: _expanded
                            ? AppTheme.purple
                            : AppTheme.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: AppTheme.border,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.answer,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 13.5,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

// ── Support card ──────────────────────────────────────────────────────────────
class _SupportCard extends StatelessWidget {
  final VoidCallback onEmailTap;

  const _SupportCard({required this.onEmailTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.purple.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.purple.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.purple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.mail_outline_rounded,
                color: AppTheme.purple, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still stuck?',
                  style: GoogleFonts.lexend(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Email us and we\'ll do our best to help.',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onEmailTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mail_outline,
                            color: Colors.white, size: 15),
                        const SizedBox(width: 8),
                        Text(
                          'Email Support',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ── Footer (Platform / Emergency Resources) ───────────────────────────────────
class _PlatformFooter extends StatelessWidget {
  const _PlatformFooter();

  static const List<String> _platformLinks = [
    'Report now',
    'Track a case',
    'Statistics',
    'Help',
  ];

  static const List<String> _emergencyResources = [
    'National Cyber Crime Agency',
    'FIA Helpline: 1991',
    'Mental health support',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FooterColumn(
            title: 'PLATFORM',
            items: _platformLinks,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _FooterColumn(
            title: 'EMERGENCY RESOURCES',
            items: _emergencyResources,
          ),
        ),
      ],
    );
  }
}

// ── Footer column ──────────────────────────────────────────────────────────────
class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lexend(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                item,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 14.5,
                  height: 1.3,
                ),
              ),
            )),
      ],
    );
  }
}