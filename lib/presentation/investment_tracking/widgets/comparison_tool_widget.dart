import 'package:agridash/core/app_export.dart';

class ComparisonToolWidget extends StatelessWidget {
  final Map<String, dynamic> portfolioSummary;

  const ComparisonToolWidget({
    super.key,
    required this.portfolioSummary,
  });

  @override
  Widget build(BuildContext context) {
    final overallROI = portfolioSummary['overallROI'] ?? 0.0;
    final marketAverageROI = 15.0; // Demo market average

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
            'Comparaison avec le Marché',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // ROI Comparison
          _buildComparisonItem(
            'Votre ROI',
            '${overallROI.toStringAsFixed(1)}%',
            AppConstants.primaryColor,
          ),
          
          _buildComparisonItem(
            'Moyenne du marché',
            '${marketAverageROI.toStringAsFixed(1)}%',
            Colors.grey.shade600,
          ),
          
          const SizedBox(height: 16),
          
          // Performance Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getPerformanceColor(overallROI, marketAverageROI).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getPerformanceColor(overallROI, marketAverageROI).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getPerformanceIcon(overallROI, marketAverageROI),
                  color: _getPerformanceColor(overallROI, marketAverageROI),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPerformanceTitle(overallROI, marketAverageROI),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPerformanceSubtitle(overallROI, marketAverageROI),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Benchmark Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.insights,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Comparaison basée sur la moyenne des projets agricoles de la plateforme',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textColor.withOpacity(0.8),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double yourROI, double marketROI) {
    if (yourROI > marketROI + 5) {
      return AppConstants.successColor;
    } else if (yourROI > marketROI) {
      return AppConstants.accentColor;
    } else if (yourROI < marketROI - 5) {
      return AppConstants.errorColor;
    } else {
      return AppConstants.warningColor;
    }
  }

  IconData _getPerformanceIcon(double yourROI, double marketROI) {
    if (yourROI > marketROI + 5) {
      return Icons.trending_up;
    } else if (yourROI > marketROI) {
      return Icons.thumb_up;
    } else if (yourROI < marketROI - 5) {
      return Icons.trending_down;
    } else {
      return Icons.remove;
    }
  }

  String _getPerformanceTitle(double yourROI, double marketROI) {
    final difference = yourROI - marketROI;
    
    if (difference > 5) {
      return 'Performance Exceptionnelle';
    } else if (difference > 0) {
      return 'Performance Supérieure';
    } else if (difference < -5) {
      return 'Performance Inférieure';
    } else {
      return 'Performance Similaire';
    }
  }

  String _getPerformanceSubtitle(double yourROI, double marketROI) {
    final difference = yourROI - marketROI;
    
    if (difference > 0) {
      return 'Vous surperformeze le marché de ${difference.toStringAsFixed(1)}%';
    } else if (difference < 0) {
      return 'Vous êtes en dessous du marché de ${difference.abs().toStringAsFixed(1)}%';
    } else {
      return 'Votre performance est alignée avec le marché';
    }
  }
}