// Flutter imports
import 'dart:ui';

export 'dart:async';
export 'dart:convert';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
// Packages exports
export 'package:shared_preferences/shared_preferences.dart';

// Routes exports
export '../routes/app_routes.dart';
export '../routes/navigation_service.dart';
export '../routes/route_arguments.dart';
// Core exports
export 'models/index.dart';
export 'services/index.dart';

// Constants
class AppConstants {
  static const String appName = 'AgroSense';
  static const String appVersion = '1.0.0';
  static const String companyName = 'AgroSense Technologies';
  
  // API Constants
  static const String baseUrl = 'https://api.agrosense.com';
  static const String hederaTestnetUrl = 'https://testnet.hashio.io/api';
  
  // App Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF8BC34A);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
  
  // App Text Styles
  static const String fontFamily = 'Inter';
  
  // App Images
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImage = 'assets/images/placeholder.jpg';
  
  // App Settings
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}

class ImageConstant {
  static String imgBackground = 'assets/images/img_background.png';
  static String imgLogo = 'assets/images/img_logo.png';
  static String imgPlaceholder = 'assets/images/img_placeholder.png';
  static String imgFarmer = 'assets/images/img_farmer.png';
  static String imgInvestor = 'assets/images/img_investor.png';
  static String imgSuccess = 'assets/images/img_success.png';
}

class MockData {
  static const List<Map<String, dynamic>> demoCrops = [
    {
      'name': 'Maïs',
      'icon': '🌽',
      'season': 'Printemps',
      'duration': '6 mois',
    },
    {
      'name': 'Riz',
      'icon': '🌾',
      'season': 'Été',
      'duration': '5 mois',
    },
    {
      'name': 'Tomate',
      'icon': '🍅',
      'season': 'Printemps/Été',
      'duration': '4 mois',
    },
    {
      'name': 'Café',
      'icon': '☕',
      'season': 'Annuelle',
      'duration': '9 mois',
    },
  ];
}