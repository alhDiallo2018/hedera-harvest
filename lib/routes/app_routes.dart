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
import 'package:agridash/routes/route_arguments.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Splash Screen
  static const String splashScreen = '/splash';

  // Auth Routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  // Main App Routes
  static const String dashboardHome = '/dashboard';
  static const String userProfile = '/profile';
  static const String portfolioManagement = '/portfolio';
  static const String investmentTracking = '/investments';
  static const String marketplace = '/marketplace';
  static const String projectCreation = '/project/create';
  static const String projectDetails = '/project/details';
  static const String cropDetailView = '/crop/details';

  // Settings & Others
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';

  static String getInitialRoute() {
    return splashScreen;
  }

  static Map<String, WidgetBuilder> routes(BuildContext context) {
    return {
      splashScreen: (context) => SplashScreen(),
      loginScreen: (context) => LoginScreen(),
      dashboardHome: (context) => DashboardHome(),
      userProfile: (context) => UserProfile(),
      portfolioManagement: (context) => PortfolioManagement(),
      investmentTracking: (context) => InvestmentTracking(),
      marketplace: (context) => Marketplace(),
      projectCreation: (context) => ProjectCreation(),
      projectDetails: (context) => ProjectDetails(
            args: ModalRoute.of(context)!.settings.arguments as ProjectDetailsArgs,
          ),
      cropDetailView: (context) => CropDetailView(
            args: ModalRoute.of(context)!.settings.arguments as CropDetailArgs,
          ),
    };
  }
}