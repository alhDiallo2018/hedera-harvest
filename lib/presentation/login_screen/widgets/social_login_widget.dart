import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Social login options widget
class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  void _handleSocialLogin(BuildContext context, String provider) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connexion $provider bientôt disponible'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          // Divider with text
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'ou continuer avec',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Social Login Buttons
          Row(
            children: [
              // Google Login
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleSocialLogin(context, 'Google'),
                  icon: CustomIconWidget(
                    iconName: 'g_translate',
                    color: Colors.red,
                    size: 5.w,
                  ),
                  label: Text(
                    'Google',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Apple Login
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleSocialLogin(context, 'Apple'),
                  icon: CustomIconWidget(
                    iconName: 'apple',
                    color: Colors.black,
                    size: 5.w,
                  ),
                  label: Text(
                    'Apple',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
