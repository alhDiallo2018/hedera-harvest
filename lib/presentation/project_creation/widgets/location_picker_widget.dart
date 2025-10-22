import 'package:agridash/core/app_export.dart';

class LocationPickerWidget extends StatelessWidget {
  final String location;
  final Function(String) onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  void _showLocationPicker(BuildContext context) {
    // For demo, we'll show a simple dialog with predefined locations
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionnez la localisation'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildLocationOption(context, 'Normandie, France'),
              _buildLocationOption(context, 'Bretagne, France'),
              _buildLocationOption(context, 'Provence, France'),
              _buildLocationOption(context, 'Occitanie, France'),
              _buildLocationOption(context, 'Auvergne-Rhône-Alpes, France'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationOption(BuildContext context, String locationName) {
    return ListTile(
      title: Text(locationName),
      leading: const Icon(Icons.location_on),
      onTap: () {
        onLocationChanged(locationName);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localisation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        GestureDetector(
          onTap: () => _showLocationPicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    location.isEmpty ? 'Sélectionnez une localisation' : location,
                    style: TextStyle(
                      fontSize: 16,
                      color: location.isEmpty 
                          ? Colors.grey.shade500 
                          : AppConstants.textColor,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        
        if (location.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Région agricole favorable sélectionnée',
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
      ],
    );
  }
}