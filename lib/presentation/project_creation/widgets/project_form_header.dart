import 'package:agridash/core/app_export.dart';

class ProjectFormHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onBack;

  const ProjectFormHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onBack,
  });

  String _getPageTitle(int page) {
    switch (page) {
      case 0:
        return 'Informations de base';
      case 1:
        return 'Détails du projet';
      case 2:
        return 'Finalisation';
      default:
        return 'Création de projet';
    }
  }

  String _getPageSubtitle(int page) {
    switch (page) {
      case 0:
        return 'Décrivez votre projet agricole';
      case 1:
        return 'Définissez les détails et le financement';
      case 2:
        return 'Ajoutez les informations finales';
      default:
        return 'Créez votre projet d\'agriculture';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and progress
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppConstants.textColor,
              ),
              const Spacer(),
              Text(
                'Étape ${currentPage + 1}/$totalPages',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Title and subtitle
          Text(
            _getPageTitle(currentPage),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            _getPageSubtitle(currentPage),
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}