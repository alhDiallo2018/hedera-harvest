// navigation_service.dart
import 'package:agridash/core/models/crop_investment.dart';
import 'package:agridash/routes/app_routes.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static Future<void> navigateToDashboard({
    required BuildContext context,
    required String userType,
  }) async {
    if (!context.mounted) return;
    
    await Navigator.pushNamed(
      context,
      AppRoutes.dashboardHome,
      arguments: userType,
    );
  }

  static Future<void> navigateToCropDetail({
    required BuildContext context,
    required CropInvestment investment,
  }) async {
    if (!context.mounted) return;
    
    await Navigator.pushNamed(
      context,
      AppRoutes.cropDetail,
      arguments: investment,
    );
  }

  static Future<void> navigateToProjectDetails({
    required BuildContext context,
    required Map<String, dynamic> projectData,
  }) async {
    if (!context.mounted) return;
    
    await Navigator.pushNamed(
      context,
      AppRoutes.projectDetails,
      arguments: projectData,
    );
  }

  static Future<void> navigateToMarketplace(BuildContext context) async {
    if (!context.mounted) return;
    
    await Navigator.pushNamed(context, AppRoutes.marketplace);
  }

  // Méthode pour remplacer complètement la stack de navigation
  static Future<void> replaceWithDashboard({
    required BuildContext context,
    required String userType,
  }) async {
    if (!context.mounted) return;
    
    await Navigator.pushReplacementNamed(
      context,
      AppRoutes.dashboardHome,
      arguments: userType,
    );
  }

  // Navigation avec retour de résultat
  static Future<T?> navigateForResult<T>({
    required BuildContext context,
    required String routeName,
    Object? arguments,
  }) async {
    if (!context.mounted) return null;
    
    return await Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }
}