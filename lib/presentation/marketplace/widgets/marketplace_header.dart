import 'package:agridash/core/app_export.dart';

class MarketplaceHeader extends StatelessWidget {
  final int projectCount;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;

  const MarketplaceHeader({
    super.key,
    required this.projectCount,
    required this.onFilterTap,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Titre et compteur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marché d\'Investissement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$projectCount projets disponibles',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Bouton de tri
          IconButton(
            onPressed: onSortTap,
            icon: Icon(
              Icons.sort,
              color: AppConstants.primaryColor,
            ),
            tooltip: 'Trier les projets',
          ),

          // Bouton de filtre
          IconButton(
            onPressed: onFilterTap,
            icon: Icon(
              Icons.filter_list,
              color: AppConstants.primaryColor,
            ),
            tooltip: 'Filtrer les projets',
          ),
        ],
      ),
    );
  }
}