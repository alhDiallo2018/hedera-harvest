import 'package:agridash/core/app_export.dart';

class InvestmentOpportunitiesCardWidget extends StatelessWidget {
  final List<CropProject> projects;
  final Function(CropProject) onProjectTap;

  const InvestmentOpportunitiesCardWidget({
    super.key,
    required this.projects,
    required this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Opportunités d\'Investissement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              TextButton(
                onPressed: () => NavigationService().toMarketplace(),
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...projects.map((project) => _buildProjectCard(project)),
        ],
      ),
    );
  }

  Widget _buildProjectCard(CropProject project) {
    return GestureDetector(
      onTap: () => onProjectTap(project),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Project Image/Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: project.imageUrls.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        project.imageUrls.first,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.eco,
                      color: AppConstants.primaryColor,
                      size: 30,
                    ),
            ),
            
            const SizedBox(width: 16),
            
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
                    project.farmerName,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${project.progressPercentage.toStringAsFixed(0)}% financé',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
                      const SizedBox(height: 4),
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
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // ROI Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppConstants.successColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${project.estimatedROI.toStringAsFixed(0)}% ROI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.successColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}