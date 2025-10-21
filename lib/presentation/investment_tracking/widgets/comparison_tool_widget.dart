import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComparisonToolWidget extends StatefulWidget {
  final Map<String, dynamic> currentInvestment;
  final List<Map<String, dynamic>> comparisonOptions;

  const ComparisonToolWidget({
    super.key,
    required this.currentInvestment,
    required this.comparisonOptions,
  });

  @override
  State<ComparisonToolWidget> createState() => _ComparisonToolWidgetState();
}

class _ComparisonToolWidgetState extends State<ComparisonToolWidget> {
  String? selectedComparison;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Outil de Comparaison',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => _showComparisonSelector(context),
                child: Text(
                  selectedComparison != null ? 'Changer' : 'Sélectionner',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (selectedComparison != null) ...[
            _ComparisonChart(
              currentInvestment: widget.currentInvestment,
              comparisonData: _getComparisonData(selectedComparison!),
              theme: theme,
            ),
            SizedBox(height: 3.h),
            _ComparisonMetrics(
              currentInvestment: widget.currentInvestment,
              comparisonData: _getComparisonData(selectedComparison!),
              theme: theme,
            ),
          ] else ...[
            Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'compare_arrows',
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Sélectionnez un investissement\nou indice pour comparer',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => _showComparisonSelector(context),
                    child: const Text('Commencer la Comparaison'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showComparisonSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Sélectionner une Comparaison',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.comparisonOptions.length,
                itemBuilder: (context, index) {
                  final option = widget.comparisonOptions[index];
                  return ListTile(
                    leading: CustomIconWidget(
                      iconName: option['icon'] as String? ?? 'trending_up',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      option['name'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    subtitle: Text(
                      option['description'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedComparison = option['id'] as String?;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getComparisonData(String comparisonId) {
    return widget.comparisonOptions.firstWhere(
      (option) => option['id'] == comparisonId,
      orElse: () => <String, dynamic>{},
    );
  }
}

class _ComparisonChart extends StatelessWidget {
  final Map<String, dynamic> currentInvestment;
  final Map<String, dynamic> comparisonData;
  final ThemeData theme;

  const _ComparisonChart({
    required this.currentInvestment,
    required this.comparisonData,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      height: 25.h,
      child: Semantics(
        label:
            "Graphique de comparaison entre votre investissement et ${comparisonData['name']}",
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxValue(),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                // tooltipBgColor: colorScheme.inverseSurface,
                // tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final isCurrentInvestment = groupIndex == 0;
                  final name = isCurrentInvestment
                      ? 'Votre Investissement'
                      : comparisonData['name'] as String? ?? '';
                  final value = rod.toY;
                  return BarTooltipItem(
                    '$name\n€${value.toStringAsFixed(2)}',
                    TextStyle(
                      color: colorScheme.onInverseSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final titles = [
                      'Votre\nInvestissement',
                      comparisonData['name'] as String? ?? ''
                    ];
                    final index = value.toInt();
                    if (index >= 0 && index < titles.length) {
                      return SideTitleWidget(
                        // axisSide: meta.axisSide,
                        meta: meta,
                        child: Text(
                          titles[index],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(
                      '€${(value / 1000).toStringAsFixed(0)}k',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: (currentInvestment['currentValue'] as double?) ?? 0.0,
                    color: colorScheme.primary,
                    width: 20.w,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: (comparisonData['value'] as double?) ?? 0.0,
                    color: colorScheme.secondary,
                    width: 20.w,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getMaxValue() {
    final currentValue = (currentInvestment['currentValue'] as double?) ?? 0.0;
    final comparisonValue = (comparisonData['value'] as double?) ?? 0.0;
    final maxValue =
        currentValue > comparisonValue ? currentValue : comparisonValue;
    return maxValue * 1.2; // Add 20% padding
  }
}

class _ComparisonMetrics extends StatelessWidget {
  final Map<String, dynamic> currentInvestment;
  final Map<String, dynamic> comparisonData;
  final ThemeData theme;

  const _ComparisonMetrics({
    required this.currentInvestment,
    required this.comparisonData,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    final currentROI = (currentInvestment['roiPercentage'] as double?) ?? 0.0;
    final comparisonROI = (comparisonData['roiPercentage'] as double?) ?? 0.0;
    final roiDifference = currentROI - comparisonROI;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricComparison(
                title: 'ROI',
                currentValue: '${currentROI.toStringAsFixed(2)}%',
                comparisonValue: '${comparisonROI.toStringAsFixed(2)}%',
                difference: roiDifference,
                theme: theme,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _MetricComparison(
                title: 'Valeur',
                currentValue:
                    '€${((currentInvestment['currentValue'] as double?) ?? 0.0).toStringAsFixed(0)}',
                comparisonValue:
                    '€${((comparisonData['value'] as double?) ?? 0.0).toStringAsFixed(0)}',
                difference:
                    ((currentInvestment['currentValue'] as double?) ?? 0.0) -
                        ((comparisonData['value'] as double?) ?? 0.0),
                theme: theme,
                isValue: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: roiDifference >= 0
                ? AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: roiDifference >= 0 ? 'trending_up' : 'trending_down',
                color: roiDifference >= 0
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  roiDifference >= 0
                      ? 'Votre investissement performe mieux de ${roiDifference.abs().toStringAsFixed(2)}%'
                      : 'Votre investissement sous-performe de ${roiDifference.abs().toStringAsFixed(2)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: roiDifference >= 0
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricComparison extends StatelessWidget {
  final String title;
  final String currentValue;
  final String comparisonValue;
  final double difference;
  final ThemeData theme;
  final bool isValue;

  const _MetricComparison({
    required this.title,
    required this.currentValue,
    required this.comparisonValue,
    required this.difference,
    required this.theme,
    this.isValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final isPositive = difference >= 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Vous: $currentValue',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          Text(
            'Comparaison: $comparisonValue',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: isPositive ? 'arrow_upward' : 'arrow_downward',
                color: isPositive
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 14,
              ),
              SizedBox(width: 1.w),
              Text(
                isValue
                    ? '€${difference.abs().toStringAsFixed(0)}'
                    : '${difference.abs().toStringAsFixed(2)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isPositive
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}