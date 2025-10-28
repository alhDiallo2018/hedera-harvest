import 'package:agridash/core/app_export.dart';

class CropTypeBottomSheet extends StatelessWidget {
  final CropType selectedCrop;
  final Map<CropType, Map<String, dynamic>> cropData;
  final Function(CropType) onCropSelected;

  const CropTypeBottomSheet({
    super.key,
    required this.selectedCrop,
    required this.cropData,
    required this.onCropSelected,
  });

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
              children: cropData.entries.map((entry) {
                final crop = entry.key;
                final data = entry.value;
                final isSelected = selectedCrop == crop;
                final cropColor = data['color'] ?? Colors.grey;
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? cropColor.withOpacity(0.1) 
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
                          color: cropColor,
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