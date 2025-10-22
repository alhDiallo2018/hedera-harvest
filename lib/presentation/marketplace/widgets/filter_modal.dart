import 'package:agridash/core/app_export.dart';

class FilterModal extends StatefulWidget {
  final String selectedCategory;
  final List<String> categories;
  final double minInvestment;
  final double maxInvestment;
  final double minROI;
  final double maxROI;
  final Function(String, double, double, double, double) onFiltersChanged;

  const FilterModal({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.minInvestment,
    required this.maxInvestment,
    required this.minROI,
    required this.maxROI,
    required this.onFiltersChanged,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late String _selectedCategory;
  late double _minInvestment;
  late double _maxInvestment;
  late double _minROI;
  late double _maxROI;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _minInvestment = widget.minInvestment;
    _maxInvestment = widget.maxInvestment;
    _minROI = widget.minROI;
    _maxROI = widget.maxROI;
  }

  void _applyFilters() {
    widget.onFiltersChanged(
      _selectedCategory,
      _minInvestment,
      _maxInvestment,
      _minROI,
      _maxROI,
    );
    NavigationService().goBack();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'Tous';
      _minInvestment = 0;
      _maxInvestment = 100000;
      _minROI = 0;
      _maxROI = 50;
    });
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtres',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Réinitialiser',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Category Section
          Text(
            'Type de Culture',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.categories.map((category) {
              final isSelected = _selectedCategory == category;
              
              return FilterChip(
                selected: isSelected,
                label: Text(category),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : 'Tous';
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppConstants.primaryColor.withOpacity(0.1),
                checkmarkColor: AppConstants.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? AppConstants.primaryColor : AppConstants.textColor,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Investment Range
          Text(
            'Investissement (FCFA)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          RangeSlider(
            values: RangeValues(_minInvestment, _maxInvestment),
            min: 0,
            max: 100000,
            divisions: 10,
            labels: RangeLabels(
              '${_minInvestment.toInt()} FCFA',
              '${_maxInvestment.toInt()} FCFA',
            ),
            onChanged: (values) {
              setState(() {
                _minInvestment = values.start;
                _maxInvestment = values.end;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_minInvestment.toInt()} FCFA'),
              Text('${_maxInvestment.toInt()} FCFA'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // ROI Range
          Text(
            'ROI Estimé (%)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          RangeSlider(
            values: RangeValues(_minROI, _maxROI),
            min: 0,
            max: 50,
            divisions: 10,
            labels: RangeLabels(
              '${_minROI.toInt()}%',
              '${_maxROI.toInt()}%',
            ),
            onChanged: (values) {
              setState(() {
                _minROI = values.start;
                _maxROI = values.end;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_minROI.toInt()}%'),
              Text('${_maxROI.toInt()}%'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Appliquer les filtres',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}