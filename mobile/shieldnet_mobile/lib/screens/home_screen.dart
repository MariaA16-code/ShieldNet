import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ApiService.getStats();
      setState(() { _stats = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Could not load stats'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShieldNetTheme.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: ShieldNetTheme.purple,
          onRefresh: () async => _loadStats(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Header ──────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.shield, color: ShieldNetTheme.purple, size: 32),
                    const SizedBox(width: 10),
                    Text('ShieldNet',
                      style: GoogleFonts.spaceGrotesk(
                        color: ShieldNetTheme.textPrime,
                        fontSize: 22, fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Hero Card ────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ShieldNetTheme.border),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A1F35), Color(0xFF141B2E)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0x269B8CF5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0x4D9B8CF5)),
                        ),
                        child: Text('Anonymous & Secure',
                          style: GoogleFonts.inter(
                            color: ShieldNetTheme.purple,
                            fontSize: 11, fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Report Cyber\nHarassment Safely',
                        style: GoogleFonts.spaceGrotesk(
                          color: ShieldNetTheme.textPrime,
                          fontSize: 26, fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Submit reports anonymously. Track your case. Get protected.',
                        style: GoogleFonts.inter(
                          color: ShieldNetTheme.textMuted, fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ShieldNetTheme.purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Report Incident',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ShieldNetTheme.textPrime,
                                side: const BorderSide(color: ShieldNetTheme.border),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Track Case',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Stats Row ────────────────────────────
                Text('Platform Overview',
                  style: GoogleFonts.spaceGrotesk(
                    color: ShieldNetTheme.textPrime,
                    fontSize: 16, fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                if (_loading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(color: ShieldNetTheme.purple),
                    ),
                  )
                else if (_error != null)
                  Center(
                    child: Column(
                      children: [
                        Text(_error!,
                          style: GoogleFonts.inter(color: ShieldNetTheme.danger)),
                        TextButton(
                          onPressed: _loadStats,
                          child: Text('Retry',
                            style: GoogleFonts.inter(color: ShieldNetTheme.purple)),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      _StatCard(
                        label: 'Total Reports',
                        value: '${_stats!['total_reports'] ?? '--'}',
                        icon: Icons.bar_chart,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Resolved',
                        value: '${_stats!['resolution_success_pct'] ?? '--'}%',
                        icon: Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        label: 'Platforms',
                        value: '${_stats!['platforms_monitored'] ?? '--'}',
                        icon: Icons.devices,
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // ── How It Works ─────────────────────────
                Text('How It Works',
                  style: GoogleFonts.spaceGrotesk(
                    color: ShieldNetTheme.textPrime,
                    fontSize: 16, fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _StepCard(step: '01', title: 'Submit a Report',
                  desc: 'Describe the incident anonymously. No account needed.'),
                const SizedBox(height: 10),
                _StepCard(step: '02', title: 'Get a Tracking Token',
                  desc: 'Save your token to check your case status anytime.'),
                const SizedBox(height: 10),
                _StepCard(step: '03', title: 'We Take Action',
                  desc: 'Our team verifies evidence and sends DMCA takedowns.'),

                const SizedBox(height: 24),

                // ── Emergency Footer ─────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0x14E24B4A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0x33E24B4A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.emergency, color: ShieldNetTheme.danger, size: 16),
                        const SizedBox(width: 6),
                        Text('Emergency Resources',
                          style: GoogleFonts.inter(
                            color: ShieldNetTheme.danger,
                            fontSize: 13, fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text('FIA Cybercrime Helpline: 1991',
                        style: GoogleFonts.inter(
                          color: ShieldNetTheme.textMuted, fontSize: 13)),
                      Text('NCCIA: nccia.gov.pk',
                        style: GoogleFonts.inter(
                          color: ShieldNetTheme.textMuted, fontSize: 13)),
                    ],
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

// ── Stat Card ────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ShieldNetTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ShieldNetTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: ShieldNetTheme.purple, size: 20),
            const SizedBox(height: 8),
            Text(value,
              style: GoogleFonts.jetBrainsMono(
                color: ShieldNetTheme.textPrime,
                fontSize: 18, fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: ShieldNetTheme.textMuted, fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step Card ────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final String step, title, desc;
  const _StepCard({required this.step, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShieldNetTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ShieldNetTheme.border),
      ),
      child: Row(
        children: [
          Text(step,
            style: GoogleFonts.jetBrainsMono(
              color: ShieldNetTheme.purple,
              fontSize: 20, fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: GoogleFonts.inter(
                    color: ShieldNetTheme.textPrime,
                    fontSize: 14, fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(desc,
                  style: GoogleFonts.inter(
                    color: ShieldNetTheme.textMuted, fontSize: 13,
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