import 'package:agridash/core/app_export.dart';

class CategoryTagsWidget extends StatelessWidget {
  final CropType selectedCrop;
  final Function(CropType) onCropChanged;

  const CategoryTagsWidget({
    super.key,
    required this.selectedCrop,
    required this.onCropChanged,
  });

  Map<CropType, String> get _cropTags {
    return {
      CropType.maize: 'Céréales',
      CropType.rice: 'Céréales',
      CropType.wheat: 'Céréales',
      CropType.tomato: 'Légumes',
      CropType.coffee: 'Plantations',
      CropType.cocoa: 'Plantations',
      CropType.cotton: 'Fibres',
      CropType.soybean: 'Légumineuses',
      CropType.other: 'Autre',
    };
  }

  List<String> get _sustainablePractices {
    return [
      'Agriculture Biologique',
      'Rotation des Cultures',
      'Gestion de l\'Eau',
      'Sols Durables',
      'Biodiversité',
      'Énergie Renouvelable',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final category = _cropTags[selectedCrop] ?? 'Autre';

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
        
        // Main Category
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.category,
                color: AppConstants.primaryColor,
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
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ],
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
          children: _sustainablePractices.map((practice) {
            return FilterChip(
              selected: false,
              label: Text(practice),
              onSelected: (selected) {
                // Handle practice selection
              },
              backgroundColor: Colors.white,
              selectedColor: AppConstants.successColor.withOpacity(0.1),
              checkmarkColor: AppConstants.successColor,
              labelStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Certification Info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 16,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Les projets durables attirent 40% plus d\'investissements',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade800,
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