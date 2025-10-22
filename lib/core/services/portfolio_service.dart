import '../models/crop_investment.dart';
import '../models/crop_project.dart';
import 'project_service.dart';

class PortfolioService {
  static final PortfolioService _instance = PortfolioService._internal();
  factory PortfolioService() => _instance;
  PortfolioService._internal();

  final ProjectService _projectService = ProjectService();

  Future<Map<String, dynamic>> getPortfolioSummary(String userId) async {
    final investments = await _projectService.getUserInvestments(userId);
    final projects = await _projectService.getProjects();
    
    double totalInvested = 0;
    double currentValue = 0;
    double totalReturns = 0;
    int activeInvestments = 0;
    int completedInvestments = 0;

    for (final investment in investments) {
      totalInvested += investment.investedAmount;
      
      // ignore: unused_local_variable
      final project = projects.firstWhere(
        (p) => p.id == investment.projectId,
        orElse: () => projects.first,
      );

      if (investment.status == InvestmentStatus.active) {
        activeInvestments++;
        currentValue += investment.potentialReturns;
      } else if (investment.status == InvestmentStatus.completed) {
        completedInvestments++;
        totalReturns += investment.returns ?? 0;
        currentValue += investment.returns ?? 0;
      }
    }

    final overallROI = totalInvested > 0 
        ? ((currentValue - totalInvested) / totalInvested * 100) 
        : 0;

    return {
      'totalInvested': totalInvested,
      'currentValue': currentValue,
      'totalReturns': totalReturns,
      'activeInvestments': activeInvestments,
      'completedInvestments': completedInvestments,
      'overallROI': overallROI,
      'investments': investments,
    };
  }

  Future<List<Map<String, dynamic>>> getPortfolioPerformance(String userId) async {
    final investments = await _projectService.getUserInvestments(userId);
    final projects = await _projectService.getProjects();
    
    List<Map<String, dynamic>> performanceData = [];

    for (final investment in investments) {
      final project = projects.firstWhere(
        (p) => p.id == investment.projectId,
        orElse: () => projects.first,
      );

      performanceData.add({
        'investment': investment,
        'project': project,
        'currentValue': investment.status == InvestmentStatus.active 
            ? investment.potentialReturns 
            : investment.returns ?? 0,
        'growth': investment.status == InvestmentStatus.active
            ? ((investment.potentialReturns - investment.investedAmount) / investment.investedAmount * 100)
            : ((investment.returns ?? 0) - investment.investedAmount) / investment.investedAmount * 100,
      });
    }

    return performanceData;
  }

  Future<Map<String, dynamic>> getFarmerPortfolio(String farmerId) async {
    final projects = await _projectService.getProjects(farmerId: farmerId);
    
    double totalRaised = 0;
    double totalReturns = 0;
    int completedProjects = 0;
    int activeProjects = 0;
    double averageROI = 0;

    for (final project in projects) {
      totalRaised += project.currentInvestment;
      
      if (project.status == ProjectStatus.completed) {
        completedProjects++;
        totalReturns += project.estimatedReturns;
      } else if (project.status.index >= ProjectStatus.funding.index && 
                 project.status.index <= ProjectStatus.harvested.index) {
        activeProjects++;
      }
    }

    if (completedProjects > 0) {
      averageROI = projects
          .where((p) => p.status == ProjectStatus.completed)
          .map((p) => p.estimatedROI)
          .reduce((a, b) => a + b) / completedProjects;
    }

    return {
      'totalProjects': projects.length,
      'completedProjects': completedProjects,
      'activeProjects': activeProjects,
      'totalRaised': totalRaised,
      'totalReturns': totalReturns,
      'averageROI': averageROI,
      'projects': projects,
    };
  }
}