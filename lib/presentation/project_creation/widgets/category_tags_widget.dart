import 'package:agridash/core/app_export.dart';

class CategoryTagsWidget extends StatelessWidget {
  final CropType selectedCrop;
  final Set<String> selectedPractices;
  final List<String> sustainablePractices;
  final String cropCategory;
  final Color cropColor;
  final Function(String) onPracticeSelected;

  const CategoryTagsWidget({
    super.key,
    required this.selectedCrop,
    required this.selectedPractices,
    required this.sustainablePractices,
    required this.cropCategory,
    required this.cropColor,
    required this.onPracticeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégories et pratiques',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Main Category avec animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cropColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: cropColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.category,
                color: cropColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catégorie principale',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.textColor.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      cropCategory,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cropColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cropColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Recommandé',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Sustainable Practices
        Text(
          'Pratiques durables (optionnel)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Sélectionnez les pratiques durables que vous appliquez',
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.textColor.withOpacity(0.6),
          ),
        ),
        
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sustainablePractices.map((practice) {
            final isSelected = selectedPractices.contains(practice);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: FilterChip(
                selected: isSelected,
                label: Text(practice),
                onSelected: (selected) {
                  onPracticeSelected(practice);
                },
                backgroundColor: Colors.white,
                selectedColor: cropColor.withOpacity(0.1),
                checkmarkColor: cropColor,
                labelStyle: TextStyle(
                  color: isSelected ? cropColor : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? cropColor : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Stats based on selections
        if (selectedPractices.isNotEmpty) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 16,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Avec ${selectedPractices.length} pratique(s) durable(s), votre projet attire ${20 + (selectedPractices.length * 5)}% plus d\'investissements',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Certification Info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 16,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Les projets durables avec pratiques certifiées ont un ROI moyen de 35%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}