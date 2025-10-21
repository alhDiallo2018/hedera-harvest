import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryTagsWidget extends StatelessWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const CategoryTagsWidget({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  static final List<Map<String, dynamic>> availableTags = [
    {
      'name': 'Bio',
      'icon': 'eco',
      'color': Color(0xFF4CAF50),
    },
    {
      'name': 'Durable',
      'icon': 'recycling',
      'color': Color(0xFF2E7D32),
    },
    {
      'name': 'Innovation',
      'icon': 'lightbulb',
      'color': Color(0xFFFF9800),
    },
    {
      'name': 'Local',
      'icon': 'location_on',
      'color': Color(0xFF1976D2),
    },
    {
      'name': 'Saisonnier',
      'icon': 'schedule',
      'color': Color(0xFF795548),
    },
    {
      'name': 'Export',
      'icon': 'public',
      'color': Color(0xFF9C27B0),
    },
    {
      'name': 'Technologie',
      'icon': 'precision_manufacturing',
      'color': Color(0xFF607D8B),
    },
    {
      'name': 'Familial',
      'icon': 'family_restroom',
      'color': Color(0xFFE91E63),
    },
    {
      'name': 'Coopératif',
      'icon': 'groups',
      'color': Color(0xFF3F51B5),
    },
    {
      'name': 'Rentable',
      'icon': 'trending_up',
      'color': Color(0xFF4CAF50),
    },
  ];

  void _toggleTag(String tagName) {
    HapticFeedback.lightImpact();

    List<String> updatedTags = List<String>.from(selectedTags);

    if (updatedTags.contains(tagName)) {
      updatedTags.remove(tagName);
    } else {
      if (updatedTags.length < 5) {
        updatedTags.add(tagName);
      }
    }

    onTagsChanged(updatedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Catégories du projet',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedTags.length}/5',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          Text(
            'Sélectionnez jusqu\'à 5 catégories qui décrivent votre projet',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Tags grid
          Wrap(
            spacing: 2.w,
            runSpacing: 2.h,
            children: availableTags.map((tag) {
              final isSelected = selectedTags.contains(tag['name']);
              final isDisabled = !isSelected && selectedTags.length >= 5;

              return GestureDetector(
                onTap: isDisabled ? null : () => _toggleTag(tag['name']),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (tag['color'] as Color)
                        : isDisabled
                            ? Colors.grey.withValues(alpha: 0.1)
                            : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? (tag['color'] as Color)
                          : isDisabled
                              ? Colors.grey.withValues(alpha: 0.3)
                              : (tag['color'] as Color).withValues(alpha: 0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: tag['icon'],
                        color: isSelected
                            ? Colors.white
                            : isDisabled
                                ? Colors.grey
                                : tag['color'],
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        tag['name'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : isDisabled
                                  ? Colors.grey
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          if (selectedTags.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Catégories sélectionnées',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 1.w,
                    runSpacing: 0.5.h,
                    children: selectedTags.map((tagName) {
                      final tag = availableTags.firstWhere(
                        (t) => t['name'] == tagName,
                        orElse: () => {
                          'name': tagName,
                          'icon': 'label',
                          'color': Colors.grey
                        },
                      );

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: (tag['color'] as Color).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: tag['icon'],
                              color: tag['color'],
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              tagName,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: tag['color'],
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
