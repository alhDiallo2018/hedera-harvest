import 'package:agridash/core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final UserRole userRole;
  final Function(String) onActionSelected;

  const QuickActionsWidget({
    super.key,
    required this.userRole,
    required this.onActionSelected,
  });

  List<Map<String, dynamic>> _getActions() {
    switch (userRole) {
      case UserRole.farmer:
        return [
          {
            'icon': Icons.add_circle_outline,
            'label': 'Créer Projet',
            'color': AppConstants.primaryColor,
            'action': 'create',
          },
          {
            'icon': Icons.visibility_outlined,
            'label': 'Mes Projets',
            'color': AppConstants.accentColor,
            'action': 'portfolio',
          },
          {
            'icon': Icons.bar_chart_outlined,
            'label': 'Statistiques',
            'color': AppConstants.successColor,
            'action': 'tracking',
          },
          {
            'icon': Icons.people_outline,
            'label': 'Investisseurs',
            'color': AppConstants.warningColor,
            'action': 'investors',
          },
        ];
      case UserRole.investor:
        return [
          {
            'icon': Icons.search_outlined,
            'label': 'Découvrir',
            'color': AppConstants.primaryColor,
            'action': 'invest',
          },
          {
            'icon': Icons.wallet_outlined,
            'label': 'Portfolio',
            'color': AppConstants.accentColor,
            'action': 'portfolio',
          },
          {
            'icon': Icons.track_changes_outlined,
            'label': 'Suivi',
            'color': AppConstants.successColor,
            'action': 'tracking',
          },
          {
            'icon': Icons.history_outlined,
            'label': 'Historique',
            'color': AppConstants.warningColor,
            'action': 'history',
          },
        ];
      case UserRole.admin:
        return [
          {
            'icon': Icons.people_outline,
            'label': 'Utilisateurs',
            'color': AppConstants.primaryColor,
            'action': 'users',
          },
          {
            'icon': Icons.assignment_outlined,
            'label': 'Projets',
            'color': AppConstants.accentColor,
            'action': 'projects',
          },
          {
            'icon': Icons.analytics_outlined,
            'label': 'Rapports',
            'color': AppConstants.successColor,
            'action': 'reports',
          },
          {
            'icon': Icons.settings_outlined,
            'label': 'Paramètres',
            'color': AppConstants.warningColor,
            'action': 'settings',
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = _getActions();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions Rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionItem(
                action['icon'] as IconData,
                action['label'] as String,
                action['color'] as Color,
                action['action'] as String,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, String action) {
    return GestureDetector(
      onTap: () => onActionSelected(action),
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}