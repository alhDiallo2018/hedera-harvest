import 'package:agridash/core/app_export.dart';

class ProjectSummaryCard extends StatelessWidget {
  final CropProject project;

  const ProjectSummaryCard({super.key, required this.project});

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
    padding: const EdgeInsets.all(10), // Padding réduit
    color: Colors.white,
    height: 120,
    child: Column(
      children: [
        // Ligne 1: Titre et Status (45px de hauteur fixe)
        SizedBox(
          height: 45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    _getCropEmoji(project.cropType),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Titre et nom
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      project.farmerName,
                      style: TextStyle(
                        fontSize: 9,
                        color: AppConstants.textColor.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: _getStatusColor(project.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _getStatusColor(project.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  project.statusDisplay,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(project.status),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Ligne 2: Barre de progression (30px de hauteur fixe)
        SizedBox(
          height: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${project.progressPercentage.toStringAsFixed(0)}% financé',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textColor,
                    ),
                  ),
                  Text(
                    '${project.currentInvestment.toStringAsFixed(0)}/${project.totalInvestmentNeeded.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              LinearProgressIndicator(
                value: project.progressPercentage / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  project.progressPercentage >= 100 
                      ? AppConstants.successColor 
                      : AppConstants.primaryColor,
                ),
                borderRadius: BorderRadius.circular(1),
                minHeight: 2,
              ),
            ],
          ),
        ),
        
        // Ligne 3: Métriques (25px de hauteur fixe) - VERSION ULTRA COMPACTE
        SizedBox(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUltraCompactMetric('ROI', '${project.estimatedROI.toStringAsFixed(0)}%'),
              _buildUltraCompactMetric('Jours', '${project.daysToHarvest}'),
              _buildUltraCompactMetric('Rend.', '${project.estimatedYield.toInt()}'),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildUltraCompactMetric(String label, String value) {
  return SizedBox(
    width: 60, // Largeur fixe pour éviter les débordements
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 10, // Très petit
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
            height: 1.9, // Réduit l'espace entre les lignes
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8, // Très petit
            color: AppConstants.textColor.withOpacity(0.6),
            height: 0.8, // Réduit l'espace entre les lignes
          ),
        ),
      ],
    ),
  );
}
}