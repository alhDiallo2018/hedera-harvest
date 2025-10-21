import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModal extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterModal({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late Map<String, dynamic> _filters;

  final List<String> _cropTypes = [
    'Maïs',
    'Blé',
    'Soja',
    'Tournesol',
    'Colza',
    'Orge',
    'Avoine',
    'Légumes'
  ];

  final List<String> _locations = [
    'Île-de-France',
    'Normandie',
    'Bretagne',
    'Pays de la Loire',
    'Centre-Val de Loire',
    'Bourgogne-Franche-Comté',
    'Grand Est',
    'Hauts-de-France',
    'Nouvelle-Aquitaine',
    'Occitanie',
    'Auvergne-Rhône-Alpes',
    'Provence-Alpes-Côte d\'Azur'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                    });
                  },
                  child: Text(
                    'Effacer tout',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                Text(
                  'Filtres',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onFiltersChanged(_filters);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Appliquer',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Crop type section
                  _buildFilterSection(
                    title: 'Type de Culture',
                    isExpanded: _filters['cropTypeExpanded'] ?? true,
                    onToggle: () {
                      setState(() {
                        _filters['cropTypeExpanded'] =
                            !(_filters['cropTypeExpanded'] ?? true);
                      });
                    },
                    child: _buildCropTypeFilter(),
                  ),
                  SizedBox(height: 3.h),

                  // Location section
                  _buildFilterSection(
                    title: 'Localisation',
                    isExpanded: _filters['locationExpanded'] ?? true,
                    onToggle: () {
                      setState(() {
                        _filters['locationExpanded'] =
                            !(_filters['locationExpanded'] ?? true);
                      });
                    },
                    child: _buildLocationFilter(),
                  ),
                  SizedBox(height: 3.h),

                  // Investment range section
                  _buildFilterSection(
                    title: 'Montant d\'Investissement',
                    isExpanded: _filters['investmentExpanded'] ?? true,
                    onToggle: () {
                      setState(() {
                        _filters['investmentExpanded'] =
                            !(_filters['investmentExpanded'] ?? true);
                      });
                    },
                    child: _buildInvestmentRangeFilter(),
                  ),
                  SizedBox(height: 3.h),

                  // Duration section
                  _buildFilterSection(
                    title: 'Durée du Projet',
                    isExpanded: _filters['durationExpanded'] ?? true,
                    onToggle: () {
                      setState(() {
                        _filters['durationExpanded'] =
                            !(_filters['durationExpanded'] ?? true);
                      });
                    },
                    child: _buildDurationFilter(),
                  ),
                  SizedBox(height: 3.h),

                  // ROI section
                  _buildFilterSection(
                    title: 'ROI Attendu',
                    isExpanded: _filters['roiExpanded'] ?? true,
                    onToggle: () {
                      setState(() {
                        _filters['roiExpanded'] =
                            !(_filters['roiExpanded'] ?? true);
                      });
                    },
                    child: _buildROIFilter(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: isExpanded ? 'expand_less' : 'expand_more',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded) ...[
          SizedBox(height: 2.h),
          child,
        ],
      ],
    );
  }

  Widget _buildCropTypeFilter() {
    final selectedCrops = (_filters['cropTypes'] as List<String>?) ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _cropTypes.map((crop) {
        final isSelected = selectedCrops.contains(crop);
        return FilterChip(
          label: Text(crop),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedCrops.add(crop);
              } else {
                selectedCrops.remove(crop);
              }
              _filters['cropTypes'] = selectedCrops;
            });
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
          labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationFilter() {
    final selectedLocations = (_filters['locations'] as List<String>?) ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _locations.map((location) {
        final isSelected = selectedLocations.contains(location);
        return FilterChip(
          label: Text(location),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedLocations.add(location);
              } else {
                selectedLocations.remove(location);
              }
              _filters['locations'] = selectedLocations;
            });
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.secondary,
          labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInvestmentRangeFilter() {
    final minInvestment = (_filters['minInvestment'] as double?) ?? 1000.0;
    final maxInvestment = (_filters['maxInvestment'] as double?) ?? 50000.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${minInvestment.toInt()}€',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${maxInvestment.toInt()}€',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(minInvestment, maxInvestment),
          min: 500,
          max: 100000,
          divisions: 100,
          labels: RangeLabels(
            '${minInvestment.toInt()}€',
            '${maxInvestment.toInt()}€',
          ),
          onChanged: (values) {
            setState(() {
              _filters['minInvestment'] = values.start;
              _filters['maxInvestment'] = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDurationFilter() {
    final selectedDurations = (_filters['durations'] as List<String>?) ?? [];
    final durations = ['3-6 mois', '6-12 mois', '1-2 ans', '2-5 ans', '5+ ans'];

    return Column(
      children: durations.map((duration) {
        final isSelected = selectedDurations.contains(duration);
        return CheckboxListTile(
          title: Text(duration),
          value: isSelected,
          onChanged: (selected) {
            setState(() {
              if (selected == true) {
                selectedDurations.add(duration);
              } else {
                selectedDurations.remove(duration);
              }
              _filters['durations'] = selectedDurations;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildROIFilter() {
    final minROI = (_filters['minROI'] as double?) ?? 5.0;
    final maxROI = (_filters['maxROI'] as double?) ?? 25.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${minROI.toInt()}%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${maxROI.toInt()}%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(minROI, maxROI),
          min: 0,
          max: 50,
          divisions: 50,
          labels: RangeLabels(
            '${minROI.toInt()}%',
            '${maxROI.toInt()}%',
          ),
          onChanged: (values) {
            setState(() {
              _filters['minROI'] = values.start;
              _filters['maxROI'] = values.end;
            });
          },
        ),
      ],
    );
  }
}
