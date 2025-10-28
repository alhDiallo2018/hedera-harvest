import 'package:agridash/core/app_export.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerWidget extends StatefulWidget {
  final String location;
  final Function(String) onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final Map<String, List<String>> _regions = {
    'Sénégal': [
      'Dakar',
      'Thiès',
      'Kaolack',
      'Diourbel',
      'Fatick',
      'Saint-Louis',
      'Ziguinchor',
      'Kolda',
      'Tambacounda',
      'Matam',
    ],
    'Côte d’Ivoire': [
      'Abidjan',
      'Bouaké',
      'Yamoussoukro',
      'Korhogo',
      'Man',
      'Daloa',
    ],
    'Mali': [
      'Bamako',
      'Sikasso',
      'Mopti',
      'Kayes',
      'Segou',
      'Gao',
    ],
  };

  String? _selectedCountry;
  bool _isDetecting = false;

  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionnez votre région'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Choix du pays
              DropdownButton<String>(
                hint: const Text('Choisir un pays'),
                value: _selectedCountry,
                isExpanded: true,
                items: _regions.keys.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCountry = val),
              ),

              const SizedBox(height: 16),

              // Liste dynamique des régions selon le pays
              if (_selectedCountry != null)
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _regions[_selectedCountry]!
                        .map((r) => _buildLocationOption(context, "$r, $_selectedCountry"))
                        .toList(),
                  ),
                )
              else
                const Text(
                  "Veuillez choisir un pays pour voir les régions.",
                  style: TextStyle(color: Colors.grey),
                ),
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
        widget.onLocationChanged(locationName);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _detectCurrentLocation() async {
    try {
      setState(() => _isDetecting = true);
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Activez la localisation GPS")),
        );
        setState(() => _isDetecting = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission de localisation refusée")),
        );
        setState(() => _isDetecting = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      final detected = "Lat: ${position.latitude.toStringAsFixed(3)}, "
          "Lon: ${position.longitude.toStringAsFixed(3)}";
      widget.onLocationChanged(detected);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    } finally {
      setState(() => _isDetecting = false);
    }
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
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showLocationPicker(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: AppConstants.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.location.isEmpty
                              ? 'Sélectionnez une localisation'
                              : widget.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.location.isEmpty
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
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _isDetecting ? null : _detectCurrentLocation,
              icon: _isDetecting
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.my_location, color: Colors.blue),
              tooltip: "Détecter ma position actuelle",
            ),
          ],
        ),
        if (widget.location.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green.shade600, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Localisation sélectionnée ou détectée avec succès',
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
