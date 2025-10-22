import 'package:agridash/core/app_export.dart';

class CultivationUpdatesCardWidget extends StatelessWidget {
  const CultivationUpdatesCardWidget({super.key});

  List<Map<String, dynamic>> _getDemoUpdates() {
    return [
      {
        'crop': 'Maïs Bio',
        'update': 'Stade de croissance: Floraison',
        'progress': 0.7,
        'date': '2024-01-15',
        'status': 'optimal',
      },
      {
        'crop': 'Tomates Cerises',
        'update': 'Récolte prévue dans 15 jours',
        'progress': 0.9,
        'date': '2024-01-14',
        'status': 'excellent',
      },
      {
        'crop': 'Riz',
        'update': 'Irrigation en cours',
        'progress': 0.4,
        'date': '2024-01-13',
        'status': 'normal',
      },
    ];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'optimal':
      case 'excellent':
        return AppConstants.successColor;
      case 'normal':
        return AppConstants.accentColor;
      case 'warning':
        return AppConstants.warningColor;
      case 'critical':
        return AppConstants.errorColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'optimal':
        return 'Optimal';
      case 'excellent':
        return 'Excellent';
      case 'normal':
        return 'Normal';
      case 'warning':
        return 'Attention';
      case 'critical':
        return 'Critique';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final updates = _getDemoUpdates();

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
            'Mises à jour des Cultures',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...updates.map((update) => _buildUpdateItem(update)),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(Map<String, dynamic> update) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Progress Circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: update['progress'],
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStatusColor(update['status']),
                  ),
                  strokeWidth: 4,
                ),
              ),
              Text(
                '${(update['progress'] * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          // Update Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update['crop'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  update['update'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mise à jour: ${update['date']}',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppConstants.textColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(update['status']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _getStatusColor(update['status']).withOpacity(0.3),
              ),
            ),
            child: Text(
              _getStatusText(update['status']),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(update['status']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}