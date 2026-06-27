import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // ── Auto-fill token from SharedPreferences ────────────────
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
                    Text('Enter the token you received when you submitted your report.',
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
                          suffixIcon: _tokenController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppTheme.textSecondary, size: 18),
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
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.purple.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: _loading
                            ? const Center(
                                child: SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text('Track',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // ── Error ─────────────────────────────
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppTheme.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppTheme.error, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_errorMessage!,
                                style: GoogleFonts.inter(
                                  color: AppTheme.error, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Case Result ───────────────────────
                    if (_caseData != null) ..._buildCaseResult(),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _buildCaseResult() {
    final reports = (_caseData?['reports'] as List?) ?? [];
    if (reports.isEmpty) {
      return [
        const SizedBox(height: 16),
        Text('No report details found for this token.',
          style: GoogleFonts.inter(color: AppTheme.textSecondary)),
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
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category + Platform
              Text('$category · $platform',
                style: GoogleFonts.lexend(
                  color: AppTheme.textPrimary,
                  fontSize: 16, fontWeight: FontWeight.w600,
                ),
              ),
              if (submittedAt.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Submitted $submittedAt',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary, fontSize: 12)),
              ],

              // Status badge
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.purple.withValues(alpha: 0.3)),
                ),
                child: Text(status,
                  style: GoogleFonts.inter(
                    color: AppTheme.purple,
                    fontSize: 11, fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
                      Text('Admin Notes',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 11, fontWeight: FontWeight.w600,
                          letterSpacing: 1,
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
    return widgets;
  }
}