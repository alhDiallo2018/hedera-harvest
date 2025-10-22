import 'package:agridash/core/app_export.dart';

class ProjectSummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> portfolioSummary;
  final UserRole userRole;

  const ProjectSummaryCardWidget({
    super.key,
    required this.portfolioSummary,
    required this.userRole,
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
            userRole == UserRole.farmer ? 'Résumé de mes Projets' : 'Aperçu des Projets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          
          if (userRole == UserRole.farmer) _buildFarmerSummary(),
          if (userRole == UserRole.admin) _buildAdminSummary(),
        ],
      ),
    );
  }

  Widget _buildFarmerSummary() {
    return Row(
      children: [
        _buildSummaryItem(
          'Total',
          '${portfolioSummary['totalProjects'] ?? 0}',
          'Projets',
          AppConstants.primaryColor,
        ),
        _buildSummaryItem(
          'Actifs',
          '${portfolioSummary['activeProjects'] ?? 0}',
          'Projets',
          AppConstants.successColor,
        ),
        _buildSummaryItem(
          'Terminés',
          '${portfolioSummary['completedProjects'] ?? 0}',
          'Projets',
          AppConstants.accentColor,
        ),
        _buildSummaryItem(
          'ROI Moyen',
          '${portfolioSummary['averageROI']?.toStringAsFixed(1) ?? '0'}%',
          'Retour',
          AppConstants.warningColor,
        ),
      ],
    );
  }

  Widget _buildAdminSummary() {
    return Row(
      children: [
        _buildSummaryItem(
          'Total',
          '${portfolioSummary['totalProjects'] ?? 0}',
          'Projets',
          AppConstants.primaryColor,
        ),
        _buildSummaryItem(
          'Investissements',
          '${portfolioSummary['totalInvestments']?.toStringAsFixed(0) ?? '0'}',
          'FCFA',
          AppConstants.successColor,
        ),
        _buildSummaryItem(
          'Utilisateurs',
          '${portfolioSummary['activeUsers'] ?? 0}',
          'Actifs',
          AppConstants.accentColor,
        ),
        _buildSummaryItem(
          'Taux Réussite',
          '85%',
          'Projets',
          AppConstants.warningColor,
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 10,
              color: AppConstants.textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}