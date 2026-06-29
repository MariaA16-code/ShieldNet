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

  // Ambulance (1122) removed as requested
  static const List<_EmergencyContact> _emergencyContacts = [
    _EmergencyContact(
      label: 'FIA Cyber Crime Helpline',
      number: '1991',
      icon: Icons.shield_outlined,
      color: Color(0xFF9B8CF5),
    ),
    _EmergencyContact(
      label: 'Police',
      number: '15',
      icon: Icons.local_police_outlined,
      color: Color(0xFF4A7DFF),
    ),
    _EmergencyContact(
      label: 'Women Helpline',
      number: '1099',
      icon: Icons.support_outlined,
      color: Color(0xFFFF6B6B),
    ),
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

  Future<void> _callNumber(BuildContext context, String number) async {
    final telUri = Uri(scheme: 'tel', path: number);
    try {
      final launched = await launchUrl(telUri);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start a call to $number.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start a call to $number.')),
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

              // ── Emergency contacts (moved to bottom) ─────────────
              _EmergencySection(
                contacts: _emergencyContacts,
                onCall: (number) => _callNumber(context, number),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────
class _EmergencyContact {
  final String label;
  final String number;
  final IconData icon;
  final Color color;

  const _EmergencyContact({
    required this.label,
    required this.number,
    required this.icon,
    required this.color,
  });
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

// ── Emergency section (moved to bottom) ──────────────────────────────────────
class _EmergencySection extends StatelessWidget {
  final List<_EmergencyContact> contacts;
  final void Function(String number) onCall;

  const _EmergencySection({
    required this.contacts,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppTheme.error.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.warning_amber_rounded,
                    color: AppTheme.error, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Immediate Help?',
                      style: GoogleFonts.lexend(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Tap any number below to call directly.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contact tiles — vertical list for 3 items
          ...contacts.map((contact) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _EmergencyTile(
                  contact: contact,
                  onTap: () => onCall(contact.number),
                ),
              )),
        ],
      ),
    );
  }
}

// ── Emergency tile ────────────────────────────────────────────────────────────
class _EmergencyTile extends StatelessWidget {
  final _EmergencyContact contact;
  final VoidCallback onTap;

  const _EmergencyTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: contact.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(contact.icon,
                    color: contact.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.label,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      contact.number,
                      style: GoogleFonts.lexend(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.call_rounded,
                    color: AppTheme.success, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}