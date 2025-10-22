import 'package:agridash/core/app_export.dart';

class InvestmentTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> performanceData;
  final Function(String) onProjectTap;

  const InvestmentTimelineWidget({
    super.key,
    required this.performanceData,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
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
            'Historique des Investissements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...performanceData.map((data) {
            final investment = data['investment'] as CropInvestment;
            final project = data['project'] as CropProject;
            final currentValue = data['currentValue'] as double;
            final growth = data['growth'] as double;
            
            return _buildInvestmentItem(investment, project, currentValue, growth);
          }),
        ],
      ),
    );
  }

  Widget _buildInvestmentItem(
    CropInvestment investment, 
    CropProject project, 
    double currentValue, 
    double growth
  ) {
    final isPositive = growth >= 0;
    
    return GestureDetector(
      onTap: () => onProjectTap(project.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Project Icon
            Container(
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
            
            const SizedBox(width: 12),
            
            // Project Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    'Investi: ${investment.investedAmount.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    '${investment.tokensPurchased} tokens • ${_formatDate(investment.investmentDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Performance
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${currentValue.toStringAsFixed(0)} FCFA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive 
                        ? AppConstants.successColor.withOpacity(0.1)
                        : AppConstants.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? AppConstants.successColor : AppConstants.errorColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${growth.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isPositive ? AppConstants.successColor : AppConstants.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}