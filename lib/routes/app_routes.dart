import 'package:agridash/core/models/crop_investment.dart';
import 'package:agridash/presentation/crop_detail_view/crop_detail_view.dart';
import 'package:agridash/presentation/dashboard_home/dashboard_home.dart';
import 'package:agridash/presentation/investment_tracking/investment_tracking.dart';
import 'package:agridash/presentation/login_screen/login_screen.dart';
import 'package:agridash/presentation/marketplace/marketplace.dart';
import 'package:agridash/presentation/portfolio_management/portfolio_management.dart';
import 'package:agridash/presentation/project_creation/project_creation.dart';
import 'package:agridash/presentation/project_details/project_details.dart';
import 'package:agridash/presentation/splash_screen/splash_screen.dart';
import 'package:agridash/presentation/user_profile/user_profile.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboardHome = '/dashboard-home';
  static const String portfolioManagement = '/portfolio-management';
  static const String cropDetail = '/crop-detail';
  static const String userProfile = '/user-profile';
  static const String projectDetails = '/project-details';
  static const String marketplace = '/marketplace';
  static const String projectCreation = '/project-creation';
  static const String investmentTracking = '/investment-tracking';

  // Routes simples sans arguments
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      portfolioManagement: (context) => const PortfolioManagementScreen(),
      userProfile: (context) => const UserProfileScreen(),
      marketplace: (context) => const Marketplace(),
      projectCreation: (context) => const ProjectCreation(),
      investmentTracking: (context) => const InvestmentTracking(),
    };
  }

  // Gestion des routes avec arguments
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("🚀 GenerateRoute called for: ${settings.name}");
    print("📦 Arguments: ${settings.arguments}");
    
    switch (settings.name) {
      case dashboardHome:
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        final String userType = args?['userType'] ?? 'farmer';
        final String userName = args?['userName'] ?? 'Utilisateur';
        
        print("🎯 Creating DashboardHome - userType: $userType, userName: $userName");
        
        return MaterialPageRoute(
          builder: (context) => DashboardHome(
            userType: userType,
            userName: userName,
          ),
        );

      case cropDetail:
        final investment = settings.arguments as CropInvestment?;
        if (investment != null) {
          return MaterialPageRoute(
            builder: (context) => CropDetailScreen(investment: investment),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => _buildErrorScreen(
              context, 
              'Données d\'investissement manquantes'
            ),
          );
        }

      case projectDetails:
        final projectData = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ProjectDetails(projectData: projectData),
        );

      default:
        // Pour les routes simples, utiliser le système de routes normal
        final builder = routes[settings.name];
        if (builder != null) {
          print("✅ Using route builder for: ${settings.name}");
          return MaterialPageRoute(builder: builder);
        }
        
        // Route non trouvée
        print("❌ Route not found: ${settings.name}");
        return MaterialPageRoute(
          builder: (context) => _buildErrorScreen(
            context, 
            'Route ${settings.name} non trouvée'
          ),
        );
    }
  }

  static Widget _buildErrorScreen(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Erreur de navigation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}