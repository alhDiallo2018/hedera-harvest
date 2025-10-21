import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class KeyMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const KeyMetricsWidget({
    super.key,
    required this.metricsData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final metrics = [
      {
        'title': 'Investissement Initial',
        'value':
            '€${((metricsData['initialInvestment'] as double?) ?? 0.0).toStringAsFixed(2)}',
        'icon': 'account_balance_wallet',
        'color': colorScheme.primary,
      },
      {
        'title': 'Valeur Actuelle',
        'value':
            '€${((metricsData['currentValue'] as double?) ?? 0.0).toStringAsFixed(2)}',
        'icon': 'trending_up',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        'title': 'Rendement Total',
        'value':
            '€${((metricsData['totalReturn'] as double?) ?? 0.0).toStringAsFixed(2)}',
        'icon': 'show_chart',
        'color': _getReturnColor(metricsData['totalReturn'] as double? ?? 0.0),
      },
      {
        'title': 'ROI',
        'value':
            '${((metricsData['roiPercentage'] as double?) ?? 0.0).toStringAsFixed(2)}%',
        'icon': 'percent',
        'color':
            _getReturnColor(metricsData['roiPercentage'] as double? ?? 0.0),
      },
      {
        'title': 'Dividendes Reçus',
        'value':
            '€${((metricsData['dividendPayments'] as double?) ?? 0.0).toStringAsFixed(2)}',
        'icon': 'payments',
        'color': AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        'title': 'Durée',
        'value': '${(metricsData['duration'] as int?) ?? 0} mois',
        'icon': 'schedule',
        'color': colorScheme.onSurface.withValues(alpha: 0.7),
      },
    ];

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
          Text(
            'Métriques Clés',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 2.5,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return _MetricCard(
                title: metric['title'] as String,
                value: metric['value'] as String,
                icon: metric['icon'] as String,
                color: metric['color'] as Color,
                theme: theme,
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getReturnColor(double value) {
    if (value > 0) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (value < 0) {
      return AppTheme.lightTheme.colorScheme.error;
    } else {
      return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color color;
  final ThemeData theme;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
