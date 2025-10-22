import 'package:agridash/core/app_export.dart';

class ProjectCard extends StatelessWidget {
  final CropProject project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Project Image
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: project.imageUrls.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(project.imageUrls.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: project.imageUrls.isEmpty
                        ? AppConstants.primaryColor.withOpacity(0.1)
                        : null,
                  ),
                  child: project.imageUrls.isEmpty
                      ? Center(
                          child: Text(
                            _getCropEmoji(project.cropType),
                            style: const TextStyle(fontSize: 40),
                          ),
                        )
                      : null,
                ),
                
                // Progress Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${project.progressPercentage.toStringAsFixed(0)}% financé',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                
                // ROI Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.successColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${project.estimatedROI.toStringAsFixed(0)}% ROI',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Project Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Farmer
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    'Par ${project.farmerName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location and Duration
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppConstants.textColor.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          project.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textColor.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppConstants.textColor.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${project.daysToHarvest} jours',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Investment Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Objectif de financement',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textColor.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            '${project.currentInvestment.toStringAsFixed(0)} / ${project.totalInvestmentNeeded.toStringAsFixed(0)} FCFA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryColor,
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
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: project.canInvest ? onTap : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: project.canInvest 
                            ? AppConstants.primaryColor 
                            : Colors.grey.shade300,
                        foregroundColor: project.canInvest ? Colors.white : Colors.grey.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        project.canInvest ? 'Investir maintenant' : 'Financement complet',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}