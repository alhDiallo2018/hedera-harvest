import 'package:agridash/core/app_export.dart';

class ActivityFeedWidget extends StatelessWidget {
  final UserRole userRole;

  const ActivityFeedWidget({
    super.key,
    required this.userRole,
  });

  List<Map<String, dynamic>> _getDemoActivities() {
    final baseActivities = [
      {
        'type': 'project_update',
        'title': 'Mise à jour de projet',
        'description': 'Nouvelles photos de la croissance des cultures ajoutées',
        'time': 'Il y a 2 heures',
        'icon': Icons.photo_camera,
        'color': AppConstants.primaryColor,
      },
      {
        'type': 'investment',
        'title': 'Nouvel investissement',
        'description': 'Un investisseur a rejoint votre projet',
        'time': 'Il y a 5 heures',
        'icon': Icons.attach_money,
        'color': AppConstants.successColor,
      },
      {
        'type': 'system',
        'title': 'Maintenance planifiée',
        'description': 'Maintenance système prévue ce weekend',
        'time': 'Il y a 1 jour',
        'icon': Icons.build,
        'color': AppConstants.warningColor,
      },
    ];

    switch (userRole) {
      case UserRole.farmer:
        return [
          ...baseActivities,
          {
            'type': 'weather',
            'title': 'Alerte météo',
            'description': 'Pluies attendues dans votre région',
            'time': 'Il y a 2 jours',
            'icon': Icons.cloud,
            'color': AppConstants.accentColor,
          },
        ];
      case UserRole.investor:
        return [
          ...baseActivities,
          {
            'type': 'dividend',
            'title': 'Dividende disponible',
            'description': 'Nouveaux dividendes à retirer',
            'time': 'Il y a 3 jours',
            'icon': Icons.account_balance_wallet,
            'color': AppConstants.successColor,
          },
        ];
      case UserRole.admin:
        return [
          ...baseActivities,
          {
            'type': 'user',
            'title': 'Nouvel utilisateur',
            'description': 'Un nouvel agriculteur s\'est inscrit',
            'time': 'Il y a 4 jours',
            'icon': Icons.person_add,
            'color': AppConstants.accentColor,
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities = _getDemoActivities();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flux d\'Activité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              Badge(
                backgroundColor: AppConstants.primaryColor,
                textColor: Colors.white,
                label: Text(activities.length.toString()),
                child: Icon(
                  Icons.notifications_none,
                  color: AppConstants.textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
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
          // Activity Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Activity Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: AppConstants.textColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}