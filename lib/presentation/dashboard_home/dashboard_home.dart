import 'package:agridash/core/app_export.dart';

import 'widgets/index.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final AuthService _authService = AuthService();
  final ProjectService _projectService = ProjectService();
  final PortfolioService _portfolioService = PortfolioService();

  List<CropProject> _projects = [];
  Map<String, dynamic> _portfolioSummary = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user != null) {
        if (user.role == UserRole.farmer) {
          _portfolioSummary = await _portfolioService.getFarmerPortfolio(user.id);
          _projects = await _projectService.getProjects(farmerId: user.id);
        } else if (user.role == UserRole.investor) {
          _portfolioSummary = await _portfolioService.getPortfolioSummary(user.id);
          _projects = await _projectService.getAvailableProjects();
        } else if (user.role == UserRole.admin) {
          _projects = await _projectService.getProjects();
          _portfolioSummary = {
            'totalProjects': _projects.length,
            'totalInvestments': _projects.fold(0.0, (sum, project) => sum + project.currentInvestment),
            'activeUsers': 156, // Demo data
          };
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur lors du chargement des données: $e');
    }
  }

  void _handleProjectTap(CropProject project) {
    NavigationService().toProjectDetails(project.id);
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'invest':
        NavigationService().toMarketplace();
        break;
      case 'create':
        NavigationService().toProjectCreation();
        break;
      case 'portfolio':
        NavigationService().toPortfolio();
        break;
      case 'tracking':
        NavigationService().toInvestmentTracking();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: DashboardHeaderWidget(
                    user: user!,
                    onProfileTap: () => NavigationService().toProfile(),
                    onNotificationTap: () {
                      NavigationService().showSuccessDialog('Notifications en cours de développement');
                    },
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: QuickActionsWidget(
                    userRole: user.role,
                    onActionSelected: _handleQuickAction,
                  ),
                ),

                // Project Summary (for farmers and admins)
                if (user.role == UserRole.farmer || user.role == UserRole.admin)
                  SliverToBoxAdapter(
                    // child: ProjectSummaryCard(
                    //   portfolioSummary: _portfolioSummary,
                    //   userRole: user.role,
                    // ),
                  ),

                // Investment Summary (for investors)
                if (user.role == UserRole.investor)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Résumé des Investissements',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildInvestmentMetric(
                                'Investi',
                                '${_portfolioSummary['totalInvested']?.toStringAsFixed(0) ?? '0'} FCFA',
                                AppConstants.primaryColor,
                              ),
                              _buildInvestmentMetric(
                                'Valeur Actuelle',
                                '${_portfolioSummary['currentValue']?.toStringAsFixed(0) ?? '0'} FCFA',
                                AppConstants.successColor,
                              ),
                              _buildInvestmentMetric(
                                'ROI',
                                '${_portfolioSummary['overallROI']?.toStringAsFixed(1) ?? '0'}%',
                                AppConstants.accentColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Investment Opportunities
                if (_projects.isNotEmpty && user.role == UserRole.investor)
                  SliverToBoxAdapter(
                    child: InvestmentOpportunitiesCardWidget(
                      projects: _projects.take(3).toList(),
                      onProjectTap: _handleProjectTap,
                    ),
                  ),

                // Recent Projects (for farmers)
                if (_projects.isNotEmpty && user.role == UserRole.farmer)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mes Projets Récents',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.textColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () => NavigationService().toMarketplace(),
                                child: Text(
                                  'Voir tout',
                                  style: TextStyle(
                                    color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ..._projects.take(3).map((project) => _buildProjectItem(project)),
                        ],
                      ),
                    ),
                  ),

                // Recent Transactions
                SliverToBoxAdapter(
                  child: RecentTransactionsCardWidget(
                    userRole: user.role,
                  ),
                ),

                // Activity Feed
                SliverToBoxAdapter(
                  child: ActivityFeedWidget(
                    userRole: user.role,
                  ),
                ),

                // Weather Widget
                SliverToBoxAdapter(
                  child: WeatherWidget(
                    location: user.location ?? 'Paris, FR',
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
    );
  }

  Widget _buildInvestmentMetric(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(CropProject project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.eco,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${project.progressPercentage.toStringAsFixed(0)}% financé',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${project.currentInvestment.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}