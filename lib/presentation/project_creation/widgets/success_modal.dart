import 'package:agridash/core/app_export.dart';

class SuccessModal extends StatelessWidget {
  final CropProject project;
  final String tokenId;
  final VoidCallback onContinue;

  const SuccessModal({
    super.key,
    required this.project,
    required this.tokenId,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppConstants.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 40,
                color: AppConstants.successColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              'Projet créé avec succès !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Message
            Text(
              'Votre projet "${project.title}" a été créé et est maintenant visible sur la marketplace.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textColor.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Project Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Token ID', tokenId),
                  _buildDetailRow('Investissement nécessaire', '${project.totalInvestmentNeeded.toStringAsFixed(0)} FCFA'),
                  _buildDetailRow('Tokens créés', '${project.totalTokens} tokens'),
                  _buildDetailRow('Prix du token', '${project.tokenPrice} FCFA'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Next Steps
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prochaines étapes :',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildNextStep('Partagez votre projet sur les réseaux sociaux'),
                  _buildNextStep('Suivez les investissements en temps réel'),
                  _buildNextStep('Ajoutez des mises à jour régulières'),
                  _buildNextStep('Préparez-vous pour la récolte'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      NavigationService().toProjectDetails(project.id);
                      onContinue();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppConstants.primaryColor),
                    ),
                    child: const Text('Voir le projet'),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      NavigationService().toMarketplace();
                      onContinue();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Marketplace'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            TextButton(
              onPressed: onContinue,
              child: Text(
                'Retour au tableau de bord',
                style: TextStyle(
                  color: AppConstants.textColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppConstants.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.textColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}