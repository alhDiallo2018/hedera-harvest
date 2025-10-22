import 'package:agridash/core/app_export.dart';

class InvestmentHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> portfolioSummary;
  final VoidCallback onRefresh;

  const InvestmentHeaderWidget({
    super.key,
    required this.portfolioSummary,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final totalInvested = portfolioSummary['totalInvested'] ?? 0.0;
    final currentValue = portfolioSummary['currentValue'] ?? 0.0;
    final totalReturns = portfolioSummary['totalReturns'] ?? 0.0;
    final overallROI = portfolioSummary['overallROI'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Refresh
          Row(
            children: [
              IconButton(
                onPressed: () => NavigationService().goBack(),
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppConstants.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Suivi des Investissements',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                color: AppConstants.textColor,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Portfolio Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valeur du portefeuille',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${currentValue.toStringAsFixed(0)} FCFA',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Quick Stats
          Row(
            children: [
              _buildStatItem('Investi', '${totalInvested.toStringAsFixed(0)} FCFA'),
              _buildStatItem('Retours', '${totalReturns.toStringAsFixed(0)} FCFA'),
              _buildStatItem('ROI', '${overallROI.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.primaryColor,
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
}