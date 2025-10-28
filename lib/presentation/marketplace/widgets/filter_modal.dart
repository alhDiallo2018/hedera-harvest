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
      _minROI = -100;
      _maxROI = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
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
              IconButton(
                onPressed: () => NavigationService().goBack(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Catégorie
          Text(
            'Catégorie',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.categories.map((category) {
              final isSelected = category == _selectedCategory;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Investissement
          Text(
            'Investissement par token (FCFA)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(_minInvestment, _maxInvestment),
            min: -100,
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

          const SizedBox(height: 20),

          // ROI
          Text(
            'ROI Estimé (%)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
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

          const SizedBox(height: 30),

          // Boutons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  child: const Text('Réinitialiser'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}