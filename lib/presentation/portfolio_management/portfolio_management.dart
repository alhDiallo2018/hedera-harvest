import 'package:agridash/core/app_export.dart';

class PortfolioManagement extends StatefulWidget {
  const PortfolioManagement({super.key});

  @override
  State<PortfolioManagement> createState() => _PortfolioManagementState();
}

class _PortfolioManagementState extends State<PortfolioManagement> {
  final PortfolioService _portfolioService = PortfolioService();
  final AuthService _authService = AuthService();
  
  Map<String, dynamic> _portfolioData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
  }

  Future<void> _loadPortfolioData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user != null) {
        if (user.role == UserRole.farmer) {
          _portfolioData = await _portfolioService.getFarmerPortfolio(user.id);
        } else if (user.role == UserRole.investor) {
          _portfolioData = await _portfolioService.getPortfolioSummary(user.id);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur lors du chargement du portefeuille: $e');
    }
  }

  void _handleProjectTap(String projectId) {
    NavigationService().toProjectDetails(projectId);
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
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    user?.role == UserRole.farmer ? 'Mes Projets' : 'Mon Portefeuille',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textColor,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _loadPortfolioData,
                      icon: const Icon(Icons.refresh),
                      color: AppConstants.textColor,
                    ),
                  ],
                ),

                // Portfolio Summary
                SliverToBoxAdapter(
                  child: _buildPortfolioSummary(),
                ),

                // Projects List
                if (_portfolioData['projects'] != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final project = _portfolioData['projects'][index];
                        return _buildProjectCard(project);
                      },
                      childCount: (_portfolioData['projects'] as List).length,
                    ),
                  ),

                // Empty State
                if (_portfolioData['projects'] == null || (_portfolioData['projects'] as List).isEmpty)
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_center_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.role == UserRole.farmer 
                              ? 'Aucun projet créé'
                              : 'Aucun investissement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.role == UserRole.farmer
                              ? 'Commencez par créer votre premier projet agricole'
                              : 'Découvrez des opportunités d\'investissement',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (user?.role == UserRole.farmer) {
                              NavigationService().toProjectCreation();
                            } else {
                              NavigationService().toMarketplace();
                            }
                          },
                          child: Text(
                            user?.role == UserRole.farmer 
                                ? 'Créer un projet' 
                                : 'Explorer le marché',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildPortfolioSummary() {
    final user = _authService.currentUser;
    
    if (user?.role == UserRole.farmer) {
      return _buildFarmerSummary();
    } else {
      return _buildInvestorSummary();
    }
  }

  Widget _buildFarmerSummary() {
    final totalProjects = _portfolioData['totalProjects'] ?? 0;
    final completedProjects = _portfolioData['completedProjects'] ?? 0;
    final activeProjects = _portfolioData['activeProjects'] ?? 0;
    final totalRaised = _portfolioData['totalRaised'] ?? 0.0;
    final averageROI = _portfolioData['averageROI'] ?? 0.0;

    return Container(
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
            'Aperçu de mes Projets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard('Total', '$totalProjects', 'Projets', Icons.list),
              _buildStatCard('Actifs', '$activeProjects', 'Projets', Icons.play_arrow),
              _buildStatCard('Terminés', '$completedProjects', 'Projets', Icons.check_circle),
              _buildStatCard('ROI Moyen', '${averageROI.toStringAsFixed(1)}%', 'Retour', Icons.trending_up),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total levé',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        '${totalRaised.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestorSummary() {
    final totalInvested = _portfolioData['totalInvested'] ?? 0.0;
    final currentValue = _portfolioData['currentValue'] ?? 0.0;
    final totalReturns = _portfolioData['totalReturns'] ?? 0.0;
    final activeInvestments = _portfolioData['activeInvestments'] ?? 0;
    final overallROI = _portfolioData['overallROI'] ?? 0.0;

    return Container(
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
            'Résumé du Portefeuille',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Current Value
          Center(
            child: Column(
              children: [
                Text(
                  'Valeur actuelle',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentValue.toStringAsFixed(0)} FCFA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard('Investi', '${totalInvested.toStringAsFixed(0)}', 'FCFA', Icons.account_balance_wallet),
              _buildStatCard('Retours', '${totalReturns.toStringAsFixed(0)}', 'FCFA', Icons.monetization_on),
              _buildStatCard('Actifs', '$activeInvestments', 'Invest.', Icons.business_center),
              _buildStatCard('ROI Total', '${overallROI.toStringAsFixed(1)}', '%', Icons.analytics),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              Text(
                '$title • $unit',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(dynamic project) {
    final cropProject = project as CropProject;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.eco,
            color: AppConstants.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          cropProject.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${cropProject.progressPercentage.toStringAsFixed(0)}% financé • ${cropProject.currentInvestment.toStringAsFixed(0)} FCFA',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: cropProject.progressPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                cropProject.progressPercentage >= 100 
                    ? AppConstants.successColor 
                    : AppConstants.primaryColor,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppConstants.textColor.withOpacity(0.5),
        ),
        onTap: () => _handleProjectTap(cropProject.id),
      ),
    );
  }
}