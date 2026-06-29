import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _error;
  int _touchedPieIndex = -1;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _countAnim;

  static const Map<String, String> _platformNames = {
    'facebook': 'Facebook',
    'instagram': 'Instagram',
    'tiktok': 'TikTok',
    'twitter': 'X (Twitter)',
    'snapchat': 'Snapchat',
    'youtube': 'YouTube',
    'other': 'Other',
  };

  static const List<Color> _categoryColors = [
    Color(0xFF9B8CF5),
    Color(0xFF4A7DFF),
    Color(0xFF00C896),
    Color(0xFFFF6B6B),
    Color(0xFFFFB347),
    Color(0xFF00D4FF),
    Color(0xFFFF8C00),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _countAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
    );
    _loadStats();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Direct HTTP call — bypasses ApiService to get the real error
  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uri = Uri.parse(
          'https://shieldnet-backend.onrender.com/api/stats');
      final response = await http
          .get(uri, headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          })
          .timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _stats = data;
            _loading = false;
          });
          _animController.forward(from: 0);
        }
      } else {
        if (mounted) {
          setState(() {
            _error =
                'Server error ${response.statusCode}:\n${response.body}';
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bar_chart_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: GoogleFonts.lexend(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Real-time insights',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded,
                  color: AppTheme.textSecondary, size: 20),
              onPressed: () {
                _animController.reset();
                _loadStats();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                color: AppTheme.purple,
                strokeWidth: 2.5,
                backgroundColor:
                    AppTheme.purple.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading statistics...',
              style: GoogleFonts.inter(
                  color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              'Server may take up to 60s to wake up',
              style: GoogleFonts.inter(
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  fontSize: 11),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.signal_wifi_off_rounded,
                    color: AppTheme.error, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                'Could Not Load Stats',
                style: GoogleFonts.lexend(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.error,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: _loadStats,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Try Again',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: RefreshIndicator(
        color: AppTheme.purple,
        backgroundColor: AppTheme.cardColor,
        onRefresh: () async {
          _animController.reset();
          await _loadStats();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetricCards(),
              const SizedBox(height: 20),
              _buildCard(
                title: 'Key Metrics',
                icon: Icons.trending_up_rounded,
                child: _buildProgressBars(),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Reports by Platform',
                icon: Icons.bar_chart_rounded,
                child: _buildPlatformChart(),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Reports by Category',
                icon: Icons.pie_chart_rounded,
                child: _buildCategoryChart(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.purple.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.purple.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.privacy_tip_outlined,
                        color: AppTheme.purple, size: 15),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'All data is fully anonymized. No personal information is stored or displayed.',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
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

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Icon(icon, color: AppTheme.purple, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.lexend(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildMetricCards() {
    final total = (_stats?['total_reports'] ?? 0) as num;
    final flagged = (_stats?['flagged_harassers'] ?? 0) as num;
    final platforms = (_stats?['platforms_monitored'] ?? 0) as num;

    return AnimatedBuilder(
      animation: _countAnim,
      builder: (context, _) {
        final t = _countAnim.value;
        return Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.description_rounded,
                iconColor: AppTheme.purple,
                label: 'Total\nReports',
                value: (total.toDouble() * t).toInt().toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.check_circle_rounded,
                iconColor: AppTheme.success,
                label: 'Cases\nResolved',
                value:
                    '${(((_stats?['resolution_success_pct'] ?? 0.0) as num).toDouble() * t).toInt()}%',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.flag_rounded,
                iconColor: AppTheme.error,
                label: 'Flagged\nHarassers',
                value: (flagged.toDouble() * t).toInt().toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                icon: Icons.shield_rounded,
                iconColor: AppTheme.blue,
                label: 'Platforms\nMonitored',
                value: (platforms.toDouble() * t).toInt().toString(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBars() {
    final evidencePct =
        ((_stats?['evidence_verified_pct'] ?? 0.0) as num).toDouble();
    final resolutionPct =
        ((_stats?['resolution_success_pct'] ?? 0.0) as num).toDouble();
    final anonymousPct =
        ((_stats?['anonymous_pct'] ?? 0.0) as num).toDouble();

    return AnimatedBuilder(
      animation: _countAnim,
      builder: (context, _) {
        final t = _countAnim.value;
        return Column(
          children: [
            _ProgressRow(
              icon: Icons.verified_rounded,
              iconColor: AppTheme.success,
              label: 'Evidence Verified',
              value: (evidencePct / 100) * t,
              percent: evidencePct * t,
              color: AppTheme.success,
            ),
            const SizedBox(height: 16),
            _ProgressRow(
              icon: Icons.track_changes_rounded,
              iconColor: AppTheme.purple,
              label: 'Resolution Success',
              value: (resolutionPct / 100) * t,
              percent: resolutionPct * t,
              color: AppTheme.purple,
            ),
            const SizedBox(height: 16),
            _ProgressRow(
              icon: Icons.person_off_rounded,
              iconColor: AppTheme.blue,
              label: 'Anonymous Reports',
              value: (anonymousPct / 100) * t,
              percent: anonymousPct * t,
              color: AppTheme.blue,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlatformChart() {
    final raw =
        _stats?['reports_per_platform'] as Map<String, dynamic>?;
    if (raw == null || raw.isEmpty) {
      return _emptyState('No platform data available yet.');
    }

    final entries = raw.entries.toList()
      ..sort((a, b) =>
          (b.value as num).compareTo(a.value as num));
    final maxVal = (entries.first.value as num).toDouble();

    return AnimatedBuilder(
      animation: _countAnim,
      builder: (context, _) {
        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxVal * 1.35).clamp(1, double.infinity),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppTheme.background,
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, _) {
                    final name = _platformNames[
                            entries[groupIndex].key.toLowerCase()] ??
                        entries[groupIndex].key;
                    return BarTooltipItem(
                      '$name\n',
                      GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 11),
                      children: [
                        TextSpan(
                          text: rod.toY.toInt().toString(),
                          style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (val, meta) {
                      final idx = val.toInt();
                      if (idx < 0 || idx >= entries.length) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          (entries[idx].value as num).toInt().toString(),
                          style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (val, meta) {
                      final idx = val.toInt();
                      if (idx < 0 || idx >= entries.length) {
                        return const SizedBox();
                      }
                      final key = entries[idx].key.toLowerCase();
                      final fullName =
                          _platformNames[key] ?? entries[idx].key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          fullName,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppTheme.border,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(entries.length, (i) {
                final animY = (entries[i].value as num).toDouble() *
                    _countAnim.value;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: animY,
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF4A7DFF), Color(0xFF9B8CF5)],
                      ),
                      width: 28,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: (maxVal * 1.35).clamp(1, double.infinity),
                        color: AppTheme.border.withValues(alpha: 0.25),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChart() {
    final raw =
        _stats?['reports_per_category'] as Map<String, dynamic>?;
    if (raw == null || raw.isEmpty) {
      return _emptyState('No category data available yet.');
    }

    final entries = raw.entries.toList()
      ..sort((a, b) =>
          (b.value as num).compareTo(a.value as num));
    final total = entries
        .map((e) => (e.value as num).toDouble())
        .reduce((a, b) => a + b);

    return AnimatedBuilder(
      animation: _countAnim,
      builder: (context, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 44,
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              _touchedPieIndex = -1;
                              return;
                            }
                            _touchedPieIndex = response
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sections: List.generate(entries.length, (i) {
                        final val =
                            (entries[i].value as num).toDouble();
                        final isTouched = i == _touchedPieIndex;
                        return PieChartSectionData(
                          value: val * _countAnim.value,
                          color: _categoryColors[
                              i % _categoryColors.length],
                          radius: isTouched ? 52 : 44,
                          title: '',
                        );
                      }),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toInt().toString(),
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Total',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(entries.length, (i) {
                  final val = (entries[i].value as num).toDouble();
                  final pct = total > 0
                      ? (val / total * 100).toStringAsFixed(0)
                      : '0';
                  final isActive = i == _touchedPieIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _categoryColors[
                                i % _categoryColors.length],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entries[i].key,
                            style: GoogleFonts.inter(
                              color: isActive
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$pct%',
                          style: GoogleFonts.jetBrainsMono(
                            color: _categoryColors[
                                i % _categoryColors.length],
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${val.toInt()})',
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary
                                .withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _emptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.bar_chart_rounded,
                color: AppTheme.textSecondary.withValues(alpha: 0.3),
                size: 36),
            const SizedBox(height: 10),
            Text(message,
                style: GoogleFonts.inter(
                    color: AppTheme.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ── Metric Card ───────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Progress Row ──────────────────────────────────────────────────────────────
class _ProgressRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final double value;
  final double percent;
  final Color color;

  const _ProgressRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: GoogleFonts.jetBrainsMono(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.6),
                            color,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}