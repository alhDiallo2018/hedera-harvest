import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onCreateProject;
  final VoidCallback onViewMarketplace;
  final VoidCallback onTrackInvestments;
  final VoidCallback onManageProfile;

  const QuickActionsWidget({
    super.key,
    required this.onCreateProject,
    required this.onViewMarketplace,
    required this.onTrackInvestments,
    required this.onManageProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // ⚡ Rend le widget scrollable si overflow
      child: Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions Rapides',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: 'add_business',
                    label: 'Nouveau\nProjet',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    onTap: onCreateProject,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: 'store',
                    label: 'Marché\nInvestisseurs',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    onTap: onViewMarketplace,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: 'trending_up',
                    label: 'Suivi\nInvestissements',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    onTap: onTrackInvestments,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: 'person',
                    label: 'Gérer\nProfil',
                    color: const Color(0xFF66BB6A),
                    onTap: onManageProfile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder( // ⚡ Rend la hauteur adaptative au parent
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
