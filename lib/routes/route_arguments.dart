// Créer un fichier route_arguments.dart
import 'package:agridash/core/models/crop_investment.dart';

class DashboardArguments {
  final String userType;
  
  DashboardArguments({required this.userType});
}

class CropDetailArguments {
  final CropInvestment investment;
  
  CropDetailArguments({required this.investment});
}

class ProjectDetailArguments {
  final Map<String, dynamic> projectData;
  
  ProjectDetailArguments({required this.projectData});
}