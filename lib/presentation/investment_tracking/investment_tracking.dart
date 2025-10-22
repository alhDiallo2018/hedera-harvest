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
  List<Map<String, dynamic>> _performanceData = [];
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
        _portfolioSummary = await _portfolioService.getPortfolioSummary(user.id);
        _performanceData = await _portfolioService.getPortfolioPerformance(user.id);
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
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
                    child: PerformanceChartWidget(performanceData: _performanceData),
                  ),

                  // Investment Timeline
                  SliverToBoxAdapter(
                    child: InvestmentTimelineWidget(
                      performanceData: _performanceData,
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
            ),
    );
  }
}