import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String userType;
  final VoidCallback onNotificationTap;
  final VoidCallback onSettingsTap;

  const DashboardHeaderWidget({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.userType = 'farmer',
    required this.onNotificationTap,
    required this.onSettingsTap,
  });

  String _getUserRole() {
    switch (userType) {
      case 'farmer':
        return 'Agriculteur';
      case 'investor':
        return 'Investisseur';
      case 'admin':
        return 'Administrateur';
      default:
        return 'Utilisateur';
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Corrigé: withOpacity
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // User Avatar
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network( // Remplacement de CustomImageWidget
                  userAvatar,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 20.sp,
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Welcome Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_getGreeting, $userName!', // Utilisation de la méthode de salutation
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getUserRole(), // Affichage du rôle utilisateur
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.7), // Corrigé: withOpacity
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Notification Icon
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2), // Corrigé: withOpacity
                ),
              ),
              child: IconButton(
                onPressed: onNotificationTap,
                icon: Icon( // Remplacement de CustomIconWidget
                  Icons.notifications_outlined,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
              ),
            ),

            SizedBox(width: 2.w),

            // Settings Icon
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.2), // Corrigé: withOpacity
                ),
              ),
              child: IconButton(
                onPressed: onSettingsTap,
                icon: Icon( // Remplacement de CustomIconWidget
                  Icons.settings_outlined,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}