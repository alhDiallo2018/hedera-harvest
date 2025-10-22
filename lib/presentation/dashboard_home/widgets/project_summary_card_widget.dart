import 'package:agridash/core/app_export.dart';

class ProjectSummaryCard extends StatelessWidget {
  final CropProject project;

  const ProjectSummaryCard({
    super.key,
    required this.project,
  });

  String _getCropEmoji(CropType cropType) {
    switch (cropType) {
      case CropType.maize:
        return '🌽';
      case CropType.rice:
        return '🌾';
      case CropType.tomato:
        return '🍅';
      case CropType.coffee:
        return '☕';
      case CropType.cocoa:
        return '🍫';
      case CropType.cotton:
        return '👕';
      case CropType.wheat:
        return '🌾';
      case CropType.soybean:
        return '🥜';
      default:
        return '🌱';
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.funding:
        return AppConstants.warningColor;
      case ProjectStatus.active:
        return AppConstants.primaryColor;
      case ProjectStatus.harvested:
        return AppConstants.successColor;
      case ProjectStatus.completed:
        return AppConstants.accentColor;
      case ProjectStatus.cancelled:
        return AppConstants.errorColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // Réduit de 12 à 8
      color: Colors.white,
      height: 90, // Réduit de 100 à 90 pour avoir une marge
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Première ligne : Titre et Status (32px)
          SizedBox(
            height: 32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 28, // Réduit de 32 à 28
                  height: 28, // Réduit de 32 à 28
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      _getCropEmoji(project.cropType),
                      style: const TextStyle(fontSize: 12), // Réduit de 14 à 12
                    ),
                  ),
                ),
                const SizedBox(width: 6), // Réduit de 8 à 6
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: TextStyle(
                          fontSize: 12, // Réduit de 13 à 12
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1), // Réduit de 2 à 1
                      Text(
                        project.farmerName,
                        style: TextStyle(
                          fontSize: 9, // Réduit de 10 à 9
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0), // Réduit
                  decoration: BoxDecoration(
                    color: _getStatusColor(project.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: _getStatusColor(project.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    project.statusDisplay,
                    style: TextStyle(
                      fontSize: 7, // Réduit de 8 à 7
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(project.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Deuxième ligne : Barre de progression (24px)
          SizedBox(
            height: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${project.progressPercentage.toStringAsFixed(0)}% financé',
                      style: TextStyle(
                        fontSize: 9, // Réduit de 10 à 9
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textColor,
                      ),
                    ),
                    Text(
                      '${project.currentInvestment.toStringAsFixed(0)}/${project.totalInvestmentNeeded.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 9, // Réduit de 10 à 9
                        color: AppConstants.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2), // Réduit de 3 à 2
                LinearProgressIndicator(
                  value: project.progressPercentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    project.progressPercentage >= 100 
                        ? AppConstants.successColor 
                        : AppConstants.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(1),
                  minHeight: 2, // Réduit de 3 à 2
                ),
              ],
            ),
          ),
          
          // Troisième ligne : Métriques (26px)
          SizedBox(
            height: 26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildMetric('ROI', '${project.estimatedROI.toStringAsFixed(0)}%'),
                _buildMetric('Jours', '${project.daysToHarvest}'),
                _buildMetric('Rend.', '${project.estimatedYield.toInt()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 10, // Légèrement augmenté pour la lisibilité
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            color: AppConstants.textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}