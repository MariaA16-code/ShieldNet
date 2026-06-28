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
          'numbers above.',
    },
  ];

  static const List<_EmergencyContact> _emergencyContacts = [
    _EmergencyContact(
      label: 'FIA Cyber Crime Helpline',
      number: '1991',
      icon: Icons.shield_outlined,
    ),
    _EmergencyContact(
      label: 'Police',
      number: '15',
      icon: Icons.local_police_outlined,
    ),
    _EmergencyContact(
      label: 'Ambulance',
      number: '1122',
      icon: Icons.medical_services_outlined,
    ),
    _EmergencyContact(
      label: 'Women Helpline',
      number: '1099',
      icon: Icons.support_outlined,
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
              'Answers to common questions about using ShieldNet. If you '
              'don\'t see what you\'re looking for, you can reach out at '
              'the bottom of this page.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EmergencyCard(
                contacts: _emergencyContacts,
                onCall: (number) => _callNumber(context, number),
              ),
              const SizedBox(height: 24),
              Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              ..._faqs.map((faq) => _FaqTile(
                    question: faq['q']!,
                    answer: faq['a']!,
                  )),
              const SizedBox(height: 12),
              _SupportCard(onEmailTap: () => _launchEmail(context)),
              const SizedBox(height: 24),
              const _HelpFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyContact {
  final String label;
  final String number;
  final IconData icon;

  const _EmergencyContact({
    required this.label,
    required this.number,
    required this.icon,
  });
}

class _EmergencyCard extends StatelessWidget {
  final List<_EmergencyContact> contacts;
  final void Function(String number) onCall;

  const _EmergencyCard({required this.contacts, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppTheme.error, size: 20),
              const SizedBox(width: 8),
              Text(
                'Need Immediate Help?',
                style: GoogleFonts.lexend(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'If you are in immediate danger, contact emergency services '
            'directly — tap any number below to call.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < contacts.length; i += 2)
            Padding(
              padding: EdgeInsets.only(
                bottom: i + 2 < contacts.length ? 10 : 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _EmergencyTile(
                      contact: contacts[i],
                      onTap: () => onCall(contacts[i].number),
                    ),
                  ),
                  if (i + 1 < contacts.length) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: _EmergencyTile(
                        contact: contacts[i + 1],
                        onTap: () => onCall(contacts[i + 1].number),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Icon(contact.icon, color: AppTheme.error, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      contact.number,
                      style: GoogleFonts.lexend(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.call, color: AppTheme.success, size: 16),
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
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? AppTheme.purple.withValues(alpha: 0.4)
              : AppTheme.border,
        ),
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
                        color: AppTheme.textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.125 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: Icon(Icons.add, color: AppTheme.purple, size: 22),
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
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.answer,
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 13.5,
                          height: 1.55,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final VoidCallback onEmailTap;

  const _SupportCard({required this.onEmailTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.purple.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Still stuck?',
            style: GoogleFonts.lexend(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'If your question wasn\'t answered above, you can email us '
            'directly and we\'ll do our best to help.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEmailTap,
              icon: const Icon(Icons.mail_outline, size: 18),
              label: const Text('Email Support'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpFooter extends StatelessWidget {
  const _HelpFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.success.withValues(alpha: 0.6),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ShieldNet',
                style: GoogleFonts.lexend(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Protecting victims. Exposing abusers. Connecting the world.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FooterColumn(
                  title: 'PLATFORM',
                  items: const ['Report', 'Track', 'Statistics'],
                ),
              ),
              Expanded(
                child: _FooterColumn(
                  title: 'EMERGENCY RESOURCES',
                  items: const [
                    'FIA Cyber Crime: 1991',
                    'Police: 15',
                    'Women Helpline: 1099',
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          style: GoogleFonts.inter(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 12.5,
              ),
            ),
          ),
      ],
    );
  }
}