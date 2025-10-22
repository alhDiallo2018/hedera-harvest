import 'package:agridash/core/app_export.dart';

class WeatherWidget extends StatelessWidget {
  final String location;

  const WeatherWidget({
    super.key,
    required this.location,
  });

  Map<String, dynamic> _getWeatherData() {
    // Demo weather data
    return {
      'temperature': 22,
      'condition': 'Ensoleillé',
      'icon': Icons.wb_sunny,
      'humidity': 65,
      'precipitation': 10,
      'wind': 12,
    };
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'ensoleillé':
        return const Color(0xFFFFA726);
      case 'nuageux':
        return const Color(0xFF78909C);
      case 'pluie':
        return const Color(0xFF42A5F5);
      case 'orage':
        return const Color(0xFF5C6BC0);
      default:
        return AppConstants.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = _getWeatherData();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getWeatherColor(weather['condition']).withOpacity(0.8),
            _getWeatherColor(weather['condition']).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Météo Agricole',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Icon(
                weather['icon'],
                size: 40,
                color: Colors.white,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Temperature
          Center(
            child: Text(
              '${weather['temperature']}°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Center(
            child: Text(
              weather['condition'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Weather Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail('Humidité', '${weather['humidity']}%', Icons.opacity),
              _buildWeatherDetail('Précipitation', '${weather['precipitation']}%', Icons.water_drop),
              _buildWeatherDetail('Vent', '${weather['wind']} km/h', Icons.air),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Weather Alert
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Conditions optimales pour les cultures de saison',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}