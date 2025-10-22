import 'package:agridash/routes/route_arguments.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateReplacement(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateAndRemoveUntil(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  void goBack([dynamic result]) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    }
  }

  // Specific navigation methods for common flows
  void toLogin() {
    navigateAndRemoveUntil(AppRoutes.loginScreen);
  }

  void toDashboard() {
    navigateAndRemoveUntil(AppRoutes.dashboardHome);
  }

  void toProjectDetails(String projectId) {
    navigateTo(
      AppRoutes.projectDetails,
      arguments: ProjectDetailsArgs(projectId: projectId),
    );
  }

  void toCropDetails(String cropId) {
    navigateTo(
      AppRoutes.cropDetailView,
      arguments: CropDetailArgs(cropId: cropId),
    );
  }

  void toMarketplace() {
    navigateTo(AppRoutes.marketplace);
  }

  void toPortfolio() {
    navigateTo(AppRoutes.portfolioManagement);
  }

  void toInvestmentTracking() {
    navigateTo(AppRoutes.investmentTracking);
  }

  void toProjectCreation() {
    navigateTo(AppRoutes.projectCreation);
  }

  void toProfile() {
    navigateTo(AppRoutes.userProfile);
  }

  // Dialog utilities
  void showErrorDialog(String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Succès'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
  }) async {
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => goBack(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}