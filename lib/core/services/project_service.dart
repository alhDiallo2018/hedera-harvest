import 'dart:convert';

import 'package:agridash/core/hedera_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/crop_investment.dart';
import '../models/crop_project.dart';

class ProjectService {
  static final ProjectService _instance = ProjectService._internal();
  factory ProjectService() => _instance;
  ProjectService._internal();

  static const String _projectsKey = 'crop_projects';
  static const String _investmentsKey = 'crop_investments';

  final HederaService _hederaService = HederaService();

  Future<List<CropProject>> getProjects({String? farmerId}) async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString(_projectsKey);
    
    if (projectsJson == null) {
      await _initializeDemoProjects();
      return getProjects(farmerId: farmerId);
    }

    final List<dynamic> projects = json.decode(projectsJson);
    List<CropProject> projectList = projects
        .map((p) => CropProject.fromJson(p))
        .toList();

    if (farmerId != null) {
      projectList = projectList.where((p) => p.farmerId == farmerId).toList();
    }

    return projectList;
  }

  Future<CropProject?> getProjectById(String projectId) async {
    final projects = await getProjects();
    return projects.firstWhere((p) => p.id == projectId);
  }

  Future<List<CropProject>> getAvailableProjects() async {
    final projects = await getProjects();
    return projects.where((p) => p.canInvest).toList();
  }

  Future<Map<String, dynamic>> createProject({
    required String farmerId,
    required String farmerName,
    required String title,
    required String description,
    required CropType cropType,
    required String location,
    required double totalInvestmentNeeded,
    required DateTime startDate,
    required DateTime harvestDate,
    required double estimatedYield,
    required String yieldUnit,
    List<String>? imageUrls,
  }) async {
    try {
      final tokenId = await _hederaService.tokenizeCrop(
        farmerId: farmerId,
        cropType: cropType.name,
        quantity: (totalInvestmentNeeded / 100).round(), // 1 token = 100 FCFA
        estimatedValue: totalInvestmentNeeded,
        harvestDate: harvestDate,
      );

      final project = CropProject(
        id: 'project_${DateTime.now().millisecondsSinceEpoch}',
        farmerId: farmerId,
        farmerName: farmerName,
        title: title,
        description: description,
        cropType: cropType,
        location: location,
        totalInvestmentNeeded: totalInvestmentNeeded,
        totalTokens: (totalInvestmentNeeded / 100).round(),
        availableTokens: (totalInvestmentNeeded / 100).round(),
        tokenPrice: 100.0, // 100 FCFA per token
        startDate: startDate,
        harvestDate: harvestDate,
        estimatedYield: estimatedYield,
        yieldUnit: yieldUnit,
        estimatedReturns: totalInvestmentNeeded * 1.25, // 25% estimated return
        imageUrls: imageUrls ?? [],
        createdAt: DateTime.now(),
      );

      await _saveProject(project);

      return {
        'success': true,
        'project': project,
        'tokenId': tokenId,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> investInProject({
    required String projectId,
    required String investorId,
    required double amount,
  }) async {
    try {
      final project = await getProjectById(projectId);
      if (project == null) {
        throw Exception('Projet non trouvé');
      }

      if (!project.canInvest) {
        throw Exception('Le projet n\'accepte pas de nouveaux investissements');
      }

      final tokensToPurchase = (amount / project.tokenPrice).round();
      if (tokensToPurchase > project.availableTokens) {
        throw Exception('Tokens insuffisants disponibles');
      }

      // Simulate Hedera transaction
      final transaction = await _hederaService.purchaseCropTokens(
        tokenId: projectId, // Using project ID as token ID for demo
        investorId: investorId,
        quantity: tokensToPurchase,
        amount: amount,
      );

      // Create investment record
      final investment = CropInvestment(
        id: 'investment_${DateTime.now().millisecondsSinceEpoch}',
        projectId: projectId,
        investorId: investorId,
        farmerId: project.farmerId,
        investedAmount: amount,
        tokensPurchased: tokensToPurchase,
        tokenPrice: project.tokenPrice,
        investmentDate: DateTime.now(),
        status: InvestmentStatus.active,
      );

      await _saveInvestment(investment);

      // Update project
      final updatedProject = CropProject(
        id: project.id,
        farmerId: project.farmerId,
        farmerName: project.farmerName,
        title: project.title,
        description: project.description,
        cropType: project.cropType,
        location: project.location,
        totalInvestmentNeeded: project.totalInvestmentNeeded,
        totalTokens: project.totalTokens,
        tokenPrice: project.tokenPrice,
        startDate: project.startDate,
        harvestDate: project.harvestDate,
        currentInvestment: project.currentInvestment + amount,
        availableTokens: project.availableTokens - tokensToPurchase,
        status: project.status,
        imageUrls: project.imageUrls,
        estimatedYield: project.estimatedYield,
        yieldUnit: project.yieldUnit,
        estimatedReturns: project.estimatedReturns,
        updates: project.updates,
        createdAt: project.createdAt,
      );

      await _saveProject(updatedProject);

      return {
        'success': true,
        'investment': investment,
        'transaction': transaction,
        'project': updatedProject,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<List<CropInvestment>> getUserInvestments(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final investmentsJson = prefs.getString(_investmentsKey);
    
    if (investmentsJson == null) {
      return [];
    }

    final List<dynamic> investments = json.decode(investmentsJson);
    return investments
        .map((i) => CropInvestment.fromJson(i))
        .where((i) => i.investorId == userId)
        .toList();
  }

  Future<void> addProjectUpdate({
    required String projectId,
    required String title,
    required String description,
    required UpdateType type,
    List<String> images = const [],
  }) async {
    final project = await getProjectById(projectId);
    if (project == null) return;

    final update = ProjectUpdate(
      id: 'update_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      date: DateTime.now(),
      images: images,
      type: type,
    );

    final updatedProject = CropProject(
      id: project.id,
      farmerId: project.farmerId,
      farmerName: project.farmerName,
      title: project.title,
      description: project.description,
      cropType: project.cropType,
      location: project.location,
      totalInvestmentNeeded: project.totalInvestmentNeeded,
      totalTokens: project.totalTokens,
      tokenPrice: project.tokenPrice,
      startDate: project.startDate,
      harvestDate: project.harvestDate,
      currentInvestment: project.currentInvestment,
      availableTokens: project.availableTokens,
      status: project.status,
      imageUrls: project.imageUrls,
      estimatedYield: project.estimatedYield,
      yieldUnit: project.yieldUnit,
      estimatedReturns: project.estimatedReturns,
      updates: [...project.updates, update],
      createdAt: project.createdAt,
    );

    await _saveProject(updatedProject);
  }

  // Private methods
  Future<void> _saveProject(CropProject project) async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString(_projectsKey);
    final List<dynamic> projects = projectsJson != null ? json.decode(projectsJson) : [];

    final projectIndex = projects.indexWhere((p) => p['id'] == project.id);
    if (projectIndex != -1) {
      projects[projectIndex] = project.toJson();
    } else {
      projects.add(project.toJson());
    }

    await prefs.setString(_projectsKey, json.encode(projects));
  }

  Future<void> _saveInvestment(CropInvestment investment) async {
    final prefs = await SharedPreferences.getInstance();
    final investmentsJson = prefs.getString(_investmentsKey);
    final List<dynamic> investments = investmentsJson != null ? json.decode(investmentsJson) : [];

    investments.add(investment.toJson());
    await prefs.setString(_investmentsKey, json.encode(investments));
  }

  Future<void> _initializeDemoProjects() async {
    final demoProjects = [
      CropProject(
        id: 'project_maize_001',
        farmerId: 'farmer_001',
        farmerName: 'Jean Dupont Agriculteur',
        title: 'Culture de Maïs Bio en Normandie',
        description: 'Projet de culture de maïs biologique sur 20 hectares avec techniques d\'agriculture durable et rotation des cultures.',
        cropType: CropType.maize,
        location: 'Normandie, France',
        totalInvestmentNeeded: 50000.0,
        totalTokens: 500,
        tokenPrice: 100.0,
        startDate: DateTime(2024, 3, 1),
        harvestDate: DateTime(2024, 9, 15),
        currentInvestment: 35000.0,
        availableTokens: 150,
        status: ProjectStatus.funding,
        imageUrls: [
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=500',
          'https://images.unsplash.com/photo-1621344040338-94a175125715?w=500',
        ],
        estimatedYield: 15000.0,
        yieldUnit: 'kg',
        estimatedReturns: 62500.0,
        updates: [
          ProjectUpdate(
            id: 'update_1',
            title: 'Préparation des sols',
            description: 'Les sols ont été préparés avec des engrais naturels et la rotation des cultures a été planifiée.',
            date: DateTime(2024, 2, 15),
            type: UpdateType.planting,
          ),
        ],
        createdAt: DateTime(2024, 1, 15),
      ),
      CropProject(
        id: 'project_tomato_001',
        farmerId: 'farmer_001',
        farmerName: 'Jean Dupont Agriculteur',
        title: 'Serres de Tomates Cerises',
        description: 'Culture de tomates cerises sous serres high-tech avec système d\'irrigation goutte-à-goutte et contrôle climatique.',
        cropType: CropType.tomato,
        location: 'Bretagne, France',
        totalInvestmentNeeded: 75000.0,
        totalTokens: 750,
        tokenPrice: 100.0,
        startDate: DateTime(2024, 2, 1),
        harvestDate: DateTime(2024, 7, 30),
        currentInvestment: 75000.0,
        availableTokens: 0,
        status: ProjectStatus.active,
        imageUrls: [
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500',
        ],
        estimatedYield: 8000.0,
        yieldUnit: 'kg',
        estimatedReturns: 93750.0,
        updates: [
          ProjectUpdate(
            id: 'update_2',
            title: 'Plantation réussie',
            description: 'Les plants de tomates cerises ont été installés dans les serres. Croissance optimale observée.',
            date: DateTime(2024, 2, 10),
            type: UpdateType.planting,
          ),
        ],
        createdAt: DateTime(2024, 1, 10),
      ),
    ];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_projectsKey, json.encode(
      demoProjects.map((p) => p.toJson()).toList()
    ));
  }
}