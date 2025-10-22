import 'package:agridash/core/app_export.dart';

class KeyMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> portfolioSummary;

  const KeyMetricsWidget({
    super.key,
    required this.portfolioSummary,
  });

  @override
  Widget build(BuildContext context) {
    final activeInvestments = portfolioSummary['activeInvestments'] ?? 0;
    final completedInvestments = portfolioSummary['completedInvestments'] ?? 0;
    final totalInvested = portfolioSummary['totalInvested'] ?? 0.0;
    final currentValue = portfolioSummary['currentValue'] ?? 0.0;

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
            'Indicateurs Clés',
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
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Investissements Actifs',
                activeInvestments.toString(),
                Icons.trending_up,
                AppConstants.primaryColor,
              ),
              _buildMetricCard(
                'Projets Terminés',
                completedInvestments.toString(),
                Icons.check_circle,
                AppConstants.successColor,
              ),
              _buildMetricCard(
                'Total Investi',
                '${totalInvested.toStringAsFixed(0)} FCFA',
                Icons.account_balance_wallet,
                AppConstants.accentColor,
              ),
              _buildMetricCard(
                'Valeur Actuelle',
                '${currentValue.toStringAsFixed(0)} FCFA',
                Icons.attach_money,
                AppConstants.warningColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
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