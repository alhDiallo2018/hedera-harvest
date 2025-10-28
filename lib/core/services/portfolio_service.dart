import 'package:agridash/core/index.dart';
import 'package:http/http.dart' as http;

class PortfolioService {
  static const String _backendBaseUrl = 'https://backend-agrosense-hedera.onrender.com/api';
  static const String _apiKey = 'change_this_api_key_to_a_strong_value';

  /// Récupère le portefeuille d'un investisseur
  Future<Map<String, dynamic>> getPortfolioSummary(String userId) async {
    try {
      final authService = AuthService();
      final token = authService.token;

      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // URL spécifique pour les investissements de l'utilisateur
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/users/$userId/investments'),
        headers: {
          'x-api-key': _apiKey,
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Réponse getPortfolioSummary: ${response.statusCode}');
      print('👤 User ID demandé: $userId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          return _formatInvestorPortfolio(data);
        } else {
          throw Exception(data['error'] ?? 'Erreur inconnue');
        }
      } else if (response.statusCode == 404) {
        return _getDefaultPortfolioData();
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur getPortfolioSummary: $e');
      return _getDefaultPortfolioData();
    }
  }

  /// Données par défaut pour les investisseurs sans investissements
  Map<String, dynamic> _getDefaultPortfolioData() {
    return {
      'totalInvested': 0.0,
      'currentValue': 0.0,
      'totalReturns': 0.0,
      'activeInvestments': 0,
      'overallROI': 0.0,
      'totalTokens': 0.0,
      'projects': [],
    };
  }

  /// Récupère les données de performance du portefeuille
  Future<Map<String, dynamic>> getPortfolioPerformance(String userId) async {
    try {
      final portfolioData = await getPortfolioSummary(userId);
      return _formatPerformanceData(portfolioData);
    } catch (e) {
      print('❌ Erreur getPortfolioPerformance: $e');
      return _getDefaultPerformanceData();
    }
  }

  /// Données de performance par défaut
  Map<String, dynamic> _getDefaultPerformanceData() {
    return {
      'totalInvested': 0.0,
      'currentValue': 0.0,
      'totalReturns': 0.0,
      'overallROI': 0.0,
      'projectPerformance': [],
      'monthlyPerformance': _generateMonthlyPerformance(0.0, 0.0),
      'performanceHistory': _generatePerformanceHistory(),
    };
  }

  /// Récupère les projets d'un agriculteur
  Future<Map<String, dynamic>> getFarmerPortfolio(String farmerId) async {
    try {
      final authService = AuthService();
      final token = authService.token;

      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // VÉRIFICATION CRITIQUE : S'assurer qu'on ne récupère que les projets du farmerId
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/projects?farmerId=$farmerId'),
        headers: {
          'x-api-key': _apiKey,
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Réponse getFarmerPortfolio: ${response.statusCode}');
      print('👤 Farmer ID demandé: $farmerId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // FILTRAGE SUPPLÉMENTAIRE côté client pour sécurité
        final filteredData = _filterFarmerProjects(data, farmerId);
        return _formatFarmerPortfolio(filteredData, farmerId);
      } else if (response.statusCode == 404) {
        return _getDefaultFarmerData();
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur getFarmerPortfolio: $e');
      return _getDefaultFarmerData();
    }
  }

  /// Filtrage supplémentaire pour s'assurer qu'on ne voit que ses projets
  dynamic _filterFarmerProjects(dynamic data, String farmerId) {
    try {
      if (data is Map && data.containsKey('projects')) {
        final projects = data['projects'] as List<dynamic>;
        final filteredProjects = projects.where((project) {
          final projectFarmerId = project['farmerId']?.toString() ?? '';
          return projectFarmerId == farmerId;
        }).toList();
        
        print('🔍 Filtrage projets: ${projects.length} → ${filteredProjects.length}');
        return {'projects': filteredProjects};
      }
      
      if (data is List) {
        final filteredProjects = data.where((project) {
          final projectFarmerId = project['farmerId']?.toString() ?? '';
          return projectFarmerId == farmerId;
        }).toList();
        
        print('🔍 Filtrage projets: ${data.length} → ${filteredProjects.length}');
        return filteredProjects;
      }
      
      return data;
    } catch (e) {
      print('❌ Erreur filtrage projets: $e');
      return {'projects': []};
    }
  }

  /// Données par défaut pour les agriculteurs sans projets
  Map<String, dynamic> _getDefaultFarmerData() {
    return {
      'totalProjects': 0,
      'completedProjects': 0,
      'activeProjects': 0,
      'totalRaised': 0.0,
      'averageROI': 0.0,
      'projects': [],
    };
  }

  /// Formate les données pour un investisseur
  Map<String, dynamic> _formatInvestorPortfolio(Map<String, dynamic> data) {
    try {
      final investments = data['investments'] as List<dynamic>? ?? [];
      final summary = data['summary'] as Map<String, dynamic>? ?? {};
      
      print('📊 Nombre d\'investissements: ${investments.length}');
      print('📊 Résumé: $summary');

      // Calculer les métriques
      final totalInvested = summary['totalInvested']?.toDouble() ?? 0.0;
      final totalTokens = summary['totalTokens']?.toDouble() ?? 0.0;
      final activeInvestments = summary['activeInvestments'] ?? investments.length;
      final estimatedTotalReturns = summary['estimatedTotalReturns']?.toDouble() ?? 0.0;
      
      // Calculer la valeur actuelle et le ROI
      final currentValue = totalInvested + estimatedTotalReturns;
      final overallROI = totalInvested > 0 ? (estimatedTotalReturns / totalInvested) * 100 : 0.0;

      // Formater les projets
      final projects = investments.map<CropProject>((inv) {
        try {
          final projectData = inv['project'] as Map<String, dynamic>? ?? {};
          return CropProject.fromJson(projectData);
        } catch (e) {
          print('❌ Erreur format projet: $e');
          // Retourner un projet par défaut en cas d'erreur
          return CropProject(
            id: 'default_${DateTime.now().millisecondsSinceEpoch}',
            farmerId: '',
            farmerName: 'Agriculteur inconnu',
            title: 'Projet inconnu',
            description: 'Description non disponible',
            cropType: CropType.other,
            location: 'Localisation inconnue',
            totalInvestmentNeeded: 0,
            totalTokens: 0,
            tokenPrice: 0,
            startDate: DateTime.now(),
            harvestDate: DateTime.now().add(const Duration(days: 90)),
            createdAt: DateTime.now(),
          );
        }
      }).toList();

      final result = {
        'totalInvested': totalInvested,
        'currentValue': currentValue,
        'totalReturns': estimatedTotalReturns,
        'activeInvestments': activeInvestments,
        'overallROI': overallROI,
        'totalTokens': totalTokens,
        'projects': projects,
      };

      print('✅ Portfolio investisseur formaté: $totalInvested FCFA investis, ${projects.length} projets');
      return result;
    } catch (e) {
      print('❌ Erreur _formatInvestorPortfolio: $e');
      return _getDefaultPortfolioData();
    }
  }

  /// Formate les données pour l'affichage des performances
  Map<String, dynamic> _formatPerformanceData(Map<String, dynamic> portfolioData) {
    try {
      final totalInvested = portfolioData['totalInvested'] ?? 0.0;
      final currentValue = portfolioData['currentValue'] ?? 0.0;
      final totalReturns = portfolioData['totalReturns'] ?? 0.0;
      final overallROI = portfolioData['overallROI'] ?? 0.0;
      final projects = portfolioData['projects'] as List<CropProject>? ?? [];

      print('📈 Formatage performance: $totalInvested FCFA investis, ${projects.length} projets');

      // Calculer la performance par projet
      final projectPerformance = projects.map((project) {
        final projectROI = project.estimatedROI;
        final projectValue = project.currentInvestment * (1 + projectROI / 100);
        
        return {
          'projectId': project.id,
          'projectName': project.title,
          'investment': project.currentInvestment,
          'currentValue': projectValue,
          'roi': projectROI,
          'status': project.status.name,
        };
      }).toList();

      // Calculer l'évolution mensuelle
      final monthlyPerformance = _generateMonthlyPerformance(totalInvested, totalReturns);

      final result = {
        'totalInvested': totalInvested,
        'currentValue': currentValue,
        'totalReturns': totalReturns,
        'overallROI': overallROI,
        'projectPerformance': projectPerformance,
        'monthlyPerformance': monthlyPerformance,
        'performanceHistory': _generatePerformanceHistory(),
      };

      print('✅ Performance data formatée: ${projectPerformance.length} projets de performance');
      return result;
    } catch (e) {
      print('❌ Erreur _formatPerformanceData: $e');
      return _getDefaultPerformanceData();
    }
  }

  /// Formate les données pour un agriculteur
  Map<String, dynamic> _formatFarmerPortfolio(dynamic data, String farmerId) {
    try {
      final projectsData = data is List ? data : (data['projects'] as List<dynamic>? ?? []);
      final projects = projectsData.map<CropProject>((p) {
        try {
          return CropProject.fromJson(p);
        } catch (e) {
          print('❌ Erreur format projet agriculteur: $e');
          return CropProject(
            id: 'default_${DateTime.now().millisecondsSinceEpoch}',
            farmerId: farmerId,
            farmerName: 'Agriculteur',
            title: 'Projet inconnu',
            description: 'Description non disponible',
            cropType: CropType.other,
            location: 'Localisation inconnue',
            totalInvestmentNeeded: 0,
            totalTokens: 0,
            tokenPrice: 0,
            startDate: DateTime.now(),
            harvestDate: DateTime.now().add(const Duration(days: 90)),
            createdAt: DateTime.now(),
          );
        }
      }).toList();
      
      // VÉRIFICATION FINALE : S'assurer que tous les projets appartiennent bien à l'agriculteur
      final myProjects = projects.where((project) => project.farmerId == farmerId).toList();
      
      // Calculer les métriques pour l'agriculteur
      final totalProjects = myProjects.length;
      final completedProjects = myProjects.where((p) => p.status == ProjectStatus.completed || p.status == ProjectStatus.harvested).length;
      final activeProjects = myProjects.where((p) => p.status == ProjectStatus.funding || p.status == ProjectStatus.active).length;
      
      final totalRaised = myProjects.fold<double>(0.0, (sum, project) => sum + project.currentInvestment);
      final averageROI = myProjects.isNotEmpty 
          ? myProjects.fold<double>(0.0, (sum, project) => sum + project.estimatedROI) / myProjects.length 
          : 0.0;

      final result = {
        'totalProjects': totalProjects,
        'completedProjects': completedProjects,
        'activeProjects': activeProjects,
        'totalRaised': totalRaised,
        'averageROI': averageROI,
        'projects': myProjects,
      };

      print('✅ Portfolio agriculteur formaté: $totalProjects projets, $totalRaised FCFA levés');
      print('🛡️  Vérification sécurité: ${projects.length} projets initiaux → $totalProjects projets après filtrage');
      
      return result;
    } catch (e) {
      print('❌ Erreur _formatFarmerPortfolio: $e');
      return _getDefaultFarmerData();
    }
  }

  /// Génère des données de performance mensuelle simulées
  List<Map<String, dynamic>> _generateMonthlyPerformance(double totalInvested, double totalReturns) {
    final now = DateTime.now();
    final months = <Map<String, dynamic>>[];
    
    // Générer 6 mois de données
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthName = _getMonthName(date.month);
      
      // Simulation de croissance progressive
      final progress = (6 - i) / 6;
      final monthlyValue = totalInvested + (totalReturns * progress);
      final monthlyReturn = totalReturns * progress;
      
      months.add({
        'month': monthName,
        'value': monthlyValue,
        'return': monthlyReturn,
        'growth': totalInvested > 0 ? (monthlyReturn / totalInvested * 100) : 0.0,
      });
    }
    
    return months;
  }

  /// Génère l'historique des performances
  List<Map<String, dynamic>> _generatePerformanceHistory() {
    return [
      {'date': 'Jan', 'value': 10000, 'return': 500},
      {'date': 'Fév', 'value': 12000, 'return': 800},
      {'date': 'Mar', 'value': 15000, 'return': 1200},
      {'date': 'Avr', 'value': 18000, 'return': 1800},
      {'date': 'Mai', 'value': 22000, 'return': 2500},
      {'date': 'Juin', 'value': 25000, 'return': 3000},
    ];
  }

  /// Helper pour obtenir le nom du mois
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month - 1];
  }
}