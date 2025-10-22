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
        children: [
          // Title and Back Button
          Row(
            children: [
              IconButton(
                onPressed: () => NavigationService().goBack(),
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppConstants.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Marketplace',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  NavigationService().showSuccessDialog('Recherche en cours de développement');
                },
                icon: const Icon(Icons.search),
                color: AppConstants.textColor,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats and Actions
          Row(
            children: [
              // Project Count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$projectCount projets',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Sort Button
              OutlinedButton.icon(
                onPressed: onSortTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.textColor,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.sort, size: 16),
                label: const Text('Trier'),
              ),
              
              const SizedBox(width: 8),
              
              // Filter Button
              OutlinedButton.icon(
                onPressed: onFilterTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.textColor,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.filter_list, size: 16),
                label: const Text('Filtrer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}