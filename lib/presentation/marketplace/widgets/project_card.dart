import 'package:agridash/core/app_export.dart';

class ProjectCard extends StatelessWidget {
  final CropProject project;
  final VoidCallback onTap;
  final double calculatedROI;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.calculatedROI,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec image et titre
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du projet
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      image: project.imageUrls.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(project.imageUrls.first),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: project.imageUrls.isEmpty
                        ? Icon(
                            Icons.eco,
                            size: 40,
                            color: AppConstants.primaryColor,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Titre et informations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 4),
                        Text(
                          project.farmerName,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Barre de progression
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${project.progressPercentage.toStringAsFixed(0)}% financé',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      Text(
                        '${project.currentInvestment.toStringAsFixed(0)} FCFA / ${project.totalInvestmentNeeded.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: project.progressPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      project.progressPercentage >= 100
                          ? AppConstants.successColor
                          : AppConstants.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Métriques
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric(
                    'ROI Estimé',
                    '${project.estimatedROI.toStringAsFixed(1)}%',
                    Icons.trending_up,
                  ),
                  _buildMetric(
                    'Jours restants',
                    '${project.daysToHarvest}',
                    Icons.calendar_today,
                  ),
                  _buildMetric(
                    'Tokens disponibles',
                    '${project.availableTokens}',
                    Icons.token,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Statut
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(project.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(project.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  project.statusDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(project.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(height: 4),
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
            color: AppConstants.textColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.funding:
        return Colors.orange;
      case ProjectStatus.active:
        return Colors.green;
      case ProjectStatus.harvested:
        return Colors.blue;
      case ProjectStatus.completed:
        return AppConstants.successColor;
      case ProjectStatus.cancelled:
        return Colors.red;
      case ProjectStatus.draft:
        return Colors.grey;
    }
  }
}