import 'package:agridash/core/app_export.dart';

class PerformanceChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> performanceData;

  const PerformanceChartWidget({
    super.key,
    required this.performanceData,
  });

  // Demo data for chart
  List<Map<String, dynamic>> get _chartData {
    return [
      {'month': 'Jan', 'value': 50000, 'growth': 0},
      {'month': 'Fév', 'value': 65000, 'growth': 30},
      {'month': 'Mar', 'value': 58000, 'growth': -10},
      {'month': 'Avr', 'value': 72000, 'growth': 25},
      {'month': 'Mai', 'value': 85000, 'growth': 18},
      {'month': 'Jun', 'value': 92000, 'growth': 8},
    ];
  }

  double get _maxValue {
    return _chartData.map((e) => e['value'] as int).reduce((a, b) => a > b ? a : b).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Text(
                'Performance du Portefeuille',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '6 mois',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Chart
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _chartData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final height = (data['value'] as int) / _maxValue * 150;
                final isPositive = (data['growth'] as int) >= 0;
                
                return Expanded(
                  child: Column(
                    children: [
                      // Growth indicator
                      Text(
                        '${data['growth']}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: isPositive ? AppConstants.successColor : AppConstants.errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Bar
                      Container(
                        width: 20,
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppConstants.primaryColor.withOpacity(0.7),
                              AppConstants.primaryColor,
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ),
                      
                      // Month label
                      const SizedBox(height: 8),
                      Text(
                        data['month'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppConstants.primaryColor, 'Valeur du portefeuille'),
              const SizedBox(width: 16),
              _buildLegendItem(AppConstants.successColor, 'Croissance positive'),
              const SizedBox(width: 16),
              _buildLegendItem(AppConstants.errorColor, 'Déclin'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppConstants.textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}