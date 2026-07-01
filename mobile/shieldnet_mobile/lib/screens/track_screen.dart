import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../services/api_service.dart';
import '../widgets/status_timeline.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final _tokenController = TextEditingController();
  bool _loading = false;
  bool _loadingToken = true;
  String? _errorMessage;
  Map<String, dynamic>? _caseData;

  @override
  void initState() {
    super.initState();
    _loadSavedToken();
  }

  Future<void> _loadSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('tracking_token');
    if (saved != null && saved.isNotEmpty) {
      _tokenController.text = saved;
    }
    setState(() => _loadingToken = false);
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _trackCase() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your tracking token.';
        _caseData = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
      _caseData = null;
    });
    try {
      final result = await ApiService.trackCase(token);
      setState(() {
        _caseData = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e is ApiException
            ? e.message
            : 'Could not find a case with that token. Please check and try again.';
        _loading = false;
      });
    }
  }

  // ── Extract a usable report id from the tracked-case JSON ──────────
  // NOTE: assumes the id is returned under 'id', 'report_id', or
  // 'reportId'. Confirm the actual key against api_service.dart /
  // the backend response and adjust here if it differs.
  int? _extractReportId(Map report) {
    final raw = report['id'] ?? report['report_id'] ?? report['reportId'];
    if (raw == null) return null;
    if (raw is int) return raw;
    return int.tryParse(raw.toString());
  }

  Future<void> _downloadPdf(BuildContext context, int reportId) async {
    final url = ApiService.generatePdfUrl(reportId);
    final uri = Uri.parse(url);
    final launched =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open the PDF link.',
              style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text('Track Case',
          style: GoogleFonts.lexend(
            color: AppTheme.textPrimary,
            fontSize: 18, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _loadingToken
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.purple))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Header ────────────────────────────
                    Text('ANONYMOUS · ENCRYPTED · FREE',
                      style: GoogleFonts.inter(
                        color: AppTheme.purple,
                        fontSize: 11, fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Track your case',
                      style: GoogleFonts.lexend(
                        color: AppTheme.textPrimary,
                        fontSize: 28, fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the token you received when you submitted your report.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 14, height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Token Input ───────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: TextField(
                        controller: _tokenController,
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Tracking Token',
                          labelStyle: GoogleFonts.inter(
                              color: AppTheme.textSecondary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: const Icon(
                            Icons.token_outlined,
                            color: AppTheme.purple,
                            size: 20,
                          ),
                          suffixIcon: _tokenController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppTheme.textSecondary,
                                      size: 18),
                                  onPressed: () {
                                    _tokenController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Track Button ──────────────────────
                    GestureDetector(
                      onTap: _loading ? null : _trackCase,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: _loading
                              ? null
                              : AppTheme.accentGradient,
                          color: _loading
                              ? AppTheme.cardColor
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _loading
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppTheme.purple
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: _loading
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.manage_search_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Track My Case',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    // ── Error ─────────────────────────────
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  AppTheme.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppTheme.error, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(_errorMessage!,
                                style: GoogleFonts.inter(
                                    color: AppTheme.error,
                                    fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Case Result ───────────────────────
                    if (_caseData != null) ..._buildCaseResult(context),

                    // ── Empty State ───────────────────────
                    if (_caseData == null && _errorMessage == null)
                      _buildEmptyState(),
                  ],
                ),
              ),
      ),
    );
  }

  // ── Premium Empty State ───────────────────────────────────
  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 8),

        // Hero icon — shield + search, matches reference
        Center(
          child: SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.purple.withValues(alpha: 0.18),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.shield_outlined,
                  size: 110,
                  color: AppTheme.purple.withValues(alpha: 0.4),
                ),
                Icon(
                  Icons.search_rounded,
                  size: 44,
                  color: AppTheme.purple,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // How it works steps
        Container(
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
                  const Icon(Icons.info_outline_rounded,
                      color: AppTheme.purple, size: 16),
                  const SizedBox(width: 8),
                  Text('How tracking works',
                    style: GoogleFonts.lexend(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStep('01', Icons.receipt_long_outlined,
                'Submit a report',
                'File a report anonymously — no account needed.'),
              const SizedBox(height: 14),
              _buildStep('02', Icons.token_outlined,
                'Save your token',
                'You receive a unique token after submission.'),
              const SizedBox(height: 14),
              _buildStep('03', Icons.track_changes_rounded,
                'Track your case',
                'Paste your token here to see real-time status.',
                isLast: true),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Privacy reassurance card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: AppTheme.purple, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your privacy is our priority',
                      style: GoogleFonts.lexend(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We never store personal information. Your token '
                      'is the only way to track your case.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // "Have your token?" nudge card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: AppTheme.blue, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Have your token?',
                      style: GoogleFonts.lexend(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter it above to get the latest updates on your case.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(
      String number, IconData icon, String title, String desc,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppTheme.purple.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: AppTheme.purple, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(number,
                    style: GoogleFonts.jetBrainsMono(
                      color: AppTheme.purple.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(title,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(desc,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCaseResult(BuildContext context) {
    final reports = (_caseData?['reports'] as List?) ?? [];
    if (reports.isEmpty) {
      return [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded,
                  color: AppTheme.textSecondary, size: 40),
              const SizedBox(height: 12),
              Text('No reports found',
                style: GoogleFonts.lexend(
                  color: AppTheme.textPrimary,
                  fontSize: 16, fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text('No report details found for this token.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: AppTheme.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      ];
    }

    final widgets = <Widget>[const SizedBox(height: 28)];

    for (final report in reports) {
      final status = report['case_status']?.toString() ??
          report['report_status']?.toString() ??
          'Submitted';
      final category = report['category']?.toString() ?? '';
      final platform = report['platform']?.toString() ?? '';
      final submittedAt = report['submitted_at']?.toString() ?? '';
      final notes = report['case_notes']?.toString() ?? '';

      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category + Platform
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.folder_special_rounded,
                        color: AppTheme.purple, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category,
                          style: GoogleFonts.lexend(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(platform,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.purple.withValues(alpha: 0.3)),
                    ),
                    child: Text(status,
                      style: GoogleFonts.inter(
                        color: AppTheme.purple,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              if (submittedAt.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Submitted $submittedAt',
                  style: GoogleFonts.inter(
                      color: AppTheme.textSecondary, fontSize: 11)),
              ],

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppTheme.border, height: 1),
              ),

              StatusTimeline(currentStatus: status),

              // Notes
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ADMIN NOTES',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(notes,
                        style: GoogleFonts.inter(
                            color: AppTheme.textPrimary, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // ── Download PDF button (end of page, only shown when a report
    // id is available) ────────────────────────────────────────────
    final firstReportId = _extractReportId(reports.first as Map);
    if (firstReportId != null) {
      widgets.add(
        GestureDetector(
          onTap: () => _downloadPdf(context, firstReportId),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf_rounded,
                    color: AppTheme.blue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Download PDF Report',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
    }

    return widgets;
  }
}