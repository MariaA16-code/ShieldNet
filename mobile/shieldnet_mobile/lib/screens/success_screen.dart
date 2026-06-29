import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/hero_section.dart';

class SuccessScreen extends StatelessWidget {
  final String token;
  final int? reportId;

  const SuccessScreen({super.key, required this.token, this.reportId});

  void _copyToken(BuildContext context) {
    Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token copied to clipboard')),
    );
  }

  Future<void> _downloadPdf(BuildContext context) async {
    if (reportId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF is not available for this report yet.'),
        ),
      );
      return;
    }
    final url = ApiService.generatePdfUrl(reportId!);
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the PDF link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Submitted')),
      body: SingleChildScrollView(
        child: HeroSection(
          eyebrow: 'Report received',
          headline: 'Your report has been submitted.',
          subtitle:
              'Save this token — it is the only way to check your case '
              'status later. We do not store any way to contact you '
              'unless you provided one.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      'TRACKING TOKEN',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      token,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(letterSpacing: 1.2),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _copyToken(context),
                icon: const Icon(Icons.copy_outlined),
                label: const Text('Copy token'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _downloadPdf(context),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Download PDF'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}