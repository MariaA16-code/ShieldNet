import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class SuccessScreen extends StatefulWidget {
  final String token;
  final int? reportId;
  const SuccessScreen({super.key, required this.token, this.reportId});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(
        parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _saveToken();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _saveToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tracking_token', widget.token);
    if (widget.reportId != null) {
      await prefs.setInt('report_id', widget.reportId!);
    }
  }

  void _copyToken() {
    Clipboard.setData(ClipboardData(text: widget.token));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('Token copied!',
              style: GoogleFonts.inter(color: Colors.white)),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppTheme.textPrimary, size: 18),
          onPressed: () => Navigator.of(context).popUntil(
            (route) => route.isFirst,
          ),
        ),
        title: Text('Report Submitted',
          style: GoogleFonts.lexend(
            color: AppTheme.textPrimary,
            fontSize: 16, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ── Success Icon ────────────────────────
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.success.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppTheme.success.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.success.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppTheme.success,
                      size: 44,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Title ───────────────────────────────
                Text('Report Submitted!',
                  style: GoogleFonts.lexend(
                    color: AppTheme.textPrimary,
                    fontSize: 26, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your report has been received.\nSave this token — it\'s your only way to track your case.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 14, height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Token Card ──────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.purple.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.purple.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.token_rounded,
                              color: AppTheme.purple, size: 14),
                          const SizedBox(width: 6),
                          Text('TRACKING TOKEN',
                            style: GoogleFonts.inter(
                              color: AppTheme.purple,
                              fontSize: 11, fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(widget.token,
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textPrimary,
                          fontSize: 13, fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _copyToken,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.purple.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.copy_rounded,
                                  color: AppTheme.purple, size: 14),
                              const SizedBox(width: 6),
                              Text('Copy Token',
                                style: GoogleFonts.inter(
                                  color: AppTheme.purple,
                                  fontSize: 13, fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Auto-saved note ─────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.success.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.save_rounded,
                          color: AppTheme.success, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Token saved automatically on this device',
                          style: GoogleFonts.inter(
                            color: AppTheme.success,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Done Button ─────────────────────────
                GestureDetector(
                  onTap: () => Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  ),
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
                    child: Text('Done',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}