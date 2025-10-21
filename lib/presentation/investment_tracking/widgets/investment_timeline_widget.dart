import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InvestmentTimelineWidget extends StatefulWidget {
  final List<Map<String, dynamic>> timelineData;

  const InvestmentTimelineWidget({
    super.key,
    required this.timelineData,
  });

  @override
  State<InvestmentTimelineWidget> createState() =>
      _InvestmentTimelineWidgetState();
}

class _InvestmentTimelineWidgetState extends State<InvestmentTimelineWidget> {
  final Set<int> expandedItems = <int>{};

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
          Text(
            'Chronologie de l\'Investissement',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.timelineData.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final item = widget.timelineData[index];
              final isExpanded = expandedItems.contains(index);

              return _TimelineItem(
                item: item,
                isExpanded: isExpanded,
                onTap: () => _toggleExpansion(index),
                onLongPress: () => _showActionSheet(context, item),
                theme: theme,
              );
            },
          ),
        ],
      ),
    );
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (expandedItems.contains(index)) {
        expandedItems.remove(index);
      } else {
        expandedItems.add(index);
      }
    });
  }

  void _showActionSheet(BuildContext context, Map<String, dynamic> item) {
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
              SizedBox(height: 3.h),
              _ActionSheetItem(
                icon: 'visibility',
                title: 'Voir Détails',
                onTap: () {
                  Navigator.pop(context);
                  // Handle view details
                },
              ),
              _ActionSheetItem(
                icon: 'download',
                title: 'Télécharger Reçu',
                onTap: () {
                  Navigator.pop(context);
                  // Handle download receipt
                },
              ),
              _ActionSheetItem(
                icon: 'report_problem',
                title: 'Signaler Problème',
                onTap: () {
                  Navigator.pop(context);
                  // Handle report problem
                },
                isDestructive: true,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ThemeData theme;

  const _TimelineItem({
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.onLongPress,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final eventType = item['type'] as String? ?? '';
    final eventColor = _getEventColor(eventType);
    final eventIcon = _getEventIcon(eventType);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: eventColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: eventColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: eventColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: eventIcon,
                      color: eventColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String? ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        item['date'] as String? ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (item['amount'] != null) ...[
                  Text(
                    '€${((item['amount'] as double?) ?? 0.0).toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: eventColor,
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
                CustomIconWidget(
                  iconName: isExpanded ? 'expand_less' : 'expand_more',
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
            if (isExpanded && item['description'] != null) ...[
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['description'] as String? ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'investment':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'dividend':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'milestone':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'value_change':
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7);
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  String _getEventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'investment':
        return 'account_balance_wallet';
      case 'dividend':
        return 'payments';
      case 'milestone':
        return 'flag';
      case 'value_change':
        return 'trending_up';
      default:
        return 'event';
    }
  }
}

class _ActionSheetItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionSheetItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? colorScheme.error
            : colorScheme.onSurface.withValues(alpha: 0.7),
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isDestructive ? colorScheme.error : colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
