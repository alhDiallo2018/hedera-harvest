import 'package:agridash/core/app_export.dart';

class DocumentsSectionWidget extends StatelessWidget {
  const DocumentsSectionWidget({super.key});

  List<Map<String, dynamic>> get _documents {
    return [
      {
        'name': 'Contrat d\'Investissement',
        'type': 'PDF',
        'size': '2.4 MB',
        'date': '15 Jan 2024',
        'icon': Icons.description,
        'color': AppConstants.primaryColor,
      },
      {
        'name': 'Rapport de Performance',
        'type': 'PDF',
        'size': '1.8 MB',
        'date': '10 Jan 2024',
        'icon': Icons.bar_chart,
        'color': AppConstants.successColor,
      },
      {
        'name': 'Certificat de Tokens',
        'type': 'PDF',
        'size': '1.2 MB',
        'date': '05 Jan 2024',
        'icon': Icons.verified,
        'color': AppConstants.accentColor,
      },
      {
        'name': 'Déclaration Fiscale',
        'type': 'PDF',
        'size': '3.1 MB',
        'date': '01 Jan 2024',
        'icon': Icons.receipt,
        'color': AppConstants.warningColor,
      },
    ];
  }

  void _downloadDocument(String documentName) {
    NavigationService().showSuccessDialog('Téléchargement de $documentName simulé');
  }

  void _viewDocument(String documentName) {
    NavigationService().showSuccessDialog('Visualisation de $documentName simulée');
  }

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
            'Documents et Rapports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Tous vos documents d\'investissement en un seul endroit',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ..._documents.map((document) => _buildDocumentItem(document)),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Document Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: document['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              document['icon'],
              color: document['color'],
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Document Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '${document['type']} • ${document['size']} • ${document['date']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Actions
          Row(
            children: [
              IconButton(
                onPressed: () => _viewDocument(document['name']),
                icon: Icon(
                  Icons.visibility_outlined,
                  color: AppConstants.primaryColor,
                ),
                tooltip: 'Voir',
              ),
              
              IconButton(
                onPressed: () => _downloadDocument(document['name']),
                icon: Icon(
                  Icons.download_outlined,
                  color: AppConstants.primaryColor,
                ),
                tooltip: 'Télécharger',
              ),
            ],
          ),
        ],
      ),
    );
  }
}