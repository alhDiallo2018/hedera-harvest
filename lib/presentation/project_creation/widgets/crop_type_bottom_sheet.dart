import 'package:agridash/core/app_export.dart';

class CropTypeBottomSheet extends StatelessWidget {
  final CropType selectedCrop;
  final Function(CropType) onCropSelected;

  const CropTypeBottomSheet({
    super.key,
    required this.selectedCrop,
    required this.onCropSelected,
  });

  Map<CropType, Map<String, dynamic>> get _cropData {
    return {
      CropType.maize: {
        'name': 'Maïs',
        'emoji': '🌽',
        'season': 'Printemps',
        'duration': '6 mois',
      },
      CropType.rice: {
        'name': 'Riz',
        'emoji': '🌾',
        'season': 'Saison des pluies',
        'duration': '5 mois',
      },
      CropType.tomato: {
        'name': 'Tomate',
        'emoji': '🍅',
        'season': 'Printemps/Été',
        'duration': '4 mois',
      },
      CropType.coffee: {
        'name': 'Café',
        'emoji': '☕',
        'season': 'Annuelle',
        'duration': '9 mois',
      },
      CropType.cocoa: {
        'name': 'Cacao',
        'emoji': '🍫',
        'season': 'Annuelle',
        'duration': '8 mois',
      },
      CropType.cotton: {
        'name': 'Coton',
        'emoji': '👕',
        'season': 'Été',
        'duration': '7 mois',
      },
      CropType.wheat: {
        'name': 'Blé',
        'emoji': '🌾',
        'season': 'Automne',
        'duration': '9 mois',
      },
      CropType.soybean: {
        'name': 'Soja',
        'emoji': '🥜',
        'season': 'Printemps',
        'duration': '5 mois',
      },
      CropType.other: {
        'name': 'Autre',
        'emoji': '🌱',
        'season': 'Variable',
        'duration': 'Variable',
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sélectionnez le type de culture',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Search Bar (optional)
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher une culture...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // Implement search functionality if needed
            },
          ),
          
          const SizedBox(height: 16),
          
          // Crop List
          Expanded(
            child: ListView(
              children: _cropData.entries.map((entry) {
                final crop = entry.key;
                final data = entry.value;
                final isSelected = selectedCrop == crop;
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppConstants.primaryColor.withOpacity(0.1) 
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        data['emoji'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  title: Text(
                    data['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textColor,
                    ),
                  ),
                  subtitle: Text(
                    '${data['season']} • ${data['duration']}',
                    style: TextStyle(
                      color: AppConstants.textColor.withOpacity(0.6),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: AppConstants.primaryColor,
                        )
                      : null,
                  onTap: () => onCropSelected(crop),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}