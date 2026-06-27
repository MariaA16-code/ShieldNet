import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../widgets/hero_section.dart';
import '../widgets/stat_card.dart';
import '../theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ApiService.getStats();
      setState(() {
        _stats = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load statistics right now.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: SingleChildScrollView(
        child: HeroSection(
          eyebrow: 'Public Awareness Dashboard',
          headline: 'Cyber harassment trends',
          subtitle:
              'Anonymized statistics from reports submitted through '
              'ShieldNet. No personal data is ever displayed here.',
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_error!, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextButton(onPressed: _loadStats, child: const Text('Try again')),
          ],
        ),
      );
    }

    final totalReports = _stats?['total_reports'] ?? 0;
    final evidenceVerifiedPct = _stats?['evidence_verified_pct'] ?? 0;
    final resolutionSuccessPct = _stats?['resolution_success_pct'] ?? 0;
    final platformsMonitored = _stats?['platforms_monitored'] ?? 0;

    final reportsPerPlatform =
        (_stats?['reports_per_platform'] as Map?) ?? {};
    final reportsPerCategory =
        (_stats?['reports_per_category'] as Map?) ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            StatCard(value: '$totalReports', label: 'Total reports'),
            StatCard(
              value: '$evidenceVerifiedPct%',
              label: 'Evidence verified',
            ),
            StatCard(
              value: '$resolutionSuccessPct%',
              label: 'Takedown success',
            ),
            StatCard(
              value: '$platformsMonitored',
              label: 'Platforms monitored',
            ),
          ],
        ),
        const SizedBox(height: 28),
        if (reportsPerPlatform.isNotEmpty) ...[
          Text('Reports by platform', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: _buildBarChart(context, reportsPerPlatform),
          ),
          const SizedBox(height: 28),
        ],
        if (reportsPerCategory.isNotEmpty) ...[
          Text('Reports by category', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: _buildDonutChart(context, reportsPerCategory),
          ),
          const SizedBox(height: 16),
          _buildLegend(context, reportsPerCategory),
        ],
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, Map data) {
    final entries = data.entries.toList();
    final maxValue = entries
        .map((e) => (e.value as num).toDouble())
        .fold<double>(0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maxValue == 0 ? 10 : maxValue * 1.2,
        barGroups: List.generate(entries.length, (i) {
          final value = (entries[i].value as num).toDouble();
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                color: AppTheme.purple,
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= entries.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    entries[index].key.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppTheme.border,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildDonutChart(BuildContext context, Map data) {
    final entries = data.entries.toList();
    final colors = [
      AppTheme.purple,
      AppTheme.blue,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
      Colors.grey,
      Colors.tealAccent,
    ];

    return PieChart(
      PieChartData(
        centerSpaceRadius: 50,
        sectionsSpace: 2,
        sections: List.generate(entries.length, (i) {
          final value = (entries[i].value as num).toDouble();
          return PieChartSectionData(
            value: value,
            color: colors[i % colors.length],
            title: '',
            radius: 50,
          );
        }),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Map data) {
    final entries = data.entries.toList();
    final colors = [
      AppTheme.purple,
      AppTheme.blue,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
      Colors.grey,
      Colors.tealAccent,
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: List.generate(entries.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors[i % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              entries[i].key.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      }),
    );
  }
}