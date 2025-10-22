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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status - Version compacte
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getCropEmoji(project.cropType),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      project.farmerName,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(project.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _getStatusColor(project.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  project.statusDisplay,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(project.status),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress Bar - Version compacte
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${project.progressPercentage.toStringAsFixed(0)}% financé',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textColor,
                    ),
                  ),
                  Text(
                    '${project.currentInvestment.toStringAsFixed(0)} / ${project.totalInvestmentNeeded.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: project.progressPercentage / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  project.progressPercentage >= 100 
                      ? AppConstants.successColor 
                      : AppConstants.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Key Metrics - Version compacte
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('ROI', '${project.estimatedROI.toStringAsFixed(0)}%', Icons.trending_up),
              _buildMetric('Jours', '${project.daysToHarvest}', Icons.calendar_today),
              _buildMetric('Rendement', '${project.estimatedYield}', Icons.agriculture),
            ],
          ),
        ],
      ),
    );
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

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppConstants.textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}