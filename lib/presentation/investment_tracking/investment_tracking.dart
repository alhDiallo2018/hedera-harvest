import 'package:agridash/core/app_export.dart';

import 'widgets/index.dart';

class InvestmentTracking extends StatefulWidget {
  const InvestmentTracking({super.key});

  @override
  State<InvestmentTracking> createState() => _InvestmentTrackingState();
}

class _InvestmentTrackingState extends State<InvestmentTracking> {
  final PortfolioService _portfolioService = PortfolioService();
  final AuthService _authService = AuthService();
  
  Map<String, dynamic> _portfolioSummary = {};
  Map<String, dynamic> _performanceData = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
  }

  Future<void> _loadPortfolioData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _authService.currentUser;
      if (user != null) {
        print('👤 Chargement du portefeuille pour: ${user.name} (${user.role})');
        
        _portfolioSummary = await _portfolioService.getPortfolioSummary(user.id);
        _performanceData = await _portfolioService.getPortfolioPerformance(user.id);
        
        print('✅ Portfolio summary: $_portfolioSummary');
        print('✅ Performance data: ${_performanceData.length}');
      } else {
        throw Exception('Utilisateur non connecté');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      print('❌ Erreur chargement portefeuille: $e');
      NavigationService().showErrorDialog('Erreur lors du chargement du portefeuille: $e');
    }
  }

  void _handleProjectTap(String projectId) {
    NavigationService().toProjectDetails(projectId);
  }

  void _navigateToMarketplace() {
    NavigationService().toMarketplace();
  }

  @override
  Widget build(BuildContext context) {
    // Extraire les données de liste du Map pour les widgets qui attendent des List
    final List<Map<String, dynamic>> projectPerformance = 
        (_performanceData['projectPerformance'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    
    final List<Map<String, dynamic>> monthlyPerformance = 
        (_performanceData['monthlyPerformance'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

    final bool hasInvestments = (_portfolioSummary['activeInvestments'] ?? 0) > 0;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : hasInvestments
                  ? _buildPortfolioWithInvestments(monthlyPerformance, projectPerformance)
                  : _buildEmptyPortfolio(),
    );
  }

  Widget _buildPortfolioWithInvestments(
    List<Map<String, dynamic>> monthlyPerformance, 
    List<Map<String, dynamic>> projectPerformance
  ) {
    return RefreshIndicator(
      onRefresh: _loadPortfolioData,
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: InvestmentHeaderWidget(
              portfolioSummary: _portfolioSummary,
              onRefresh: _loadPortfolioData,
            ),
          ),

          // Key Metrics
          SliverToBoxAdapter(
            child: KeyMetricsWidget(portfolioSummary: _portfolioSummary),
          ),

          // Performance Chart
          SliverToBoxAdapter(
            child: PerformanceChartWidget(performanceData: monthlyPerformance),
          ),

          // Investment Timeline
          SliverToBoxAdapter(
            child: InvestmentTimelineWidget(
              performanceData: projectPerformance,
              onProjectTap: _handleProjectTap,
            ),
          ),

          // Comparison Tool
          SliverToBoxAdapter(
            child: ComparisonToolWidget(portfolioSummary: _portfolioSummary),
          ),

          // Documents Section
          SliverToBoxAdapter(
            child: DocumentsSectionWidget(),
          ),

          // Alert Settings
          SliverToBoxAdapter(
            child: AlertSettingsWidget(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPortfolio() {
    return RefreshIndicator(
      onRefresh: _loadPortfolioData,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun investissement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Vous n\'avez pas encore d\'investissements dans votre portefeuille. '
                    'Découvrez des opportunités d\'investissement prometteuses.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _navigateToMarketplace,
                  child: const Text('Explorer le marché'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _loadPortfolioData,
                  child: const Text('Actualiser'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _errorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPortfolioData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}