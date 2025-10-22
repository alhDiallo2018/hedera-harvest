import 'package:agridash/core/app_export.dart';

class FilterChipsRow extends StatefulWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategoryChanged;

  const FilterChipsRow({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  State<FilterChipsRow> createState() => _FilterChipsRowState();
}

class _FilterChipsRowState extends State<FilterChipsRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.categories.map((category) {
            final isSelected = widget.selectedCategory == category;
            
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(category),
                onSelected: (selected) {
                  widget.onCategoryChanged(selected ? category : 'Tous');
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}