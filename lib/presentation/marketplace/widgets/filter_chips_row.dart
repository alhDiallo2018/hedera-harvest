import 'package:agridash/core/app_export.dart';

class FilterChipsRow extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;

  const FilterChipsRow({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  onCategoryChanged(category);
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: AppConstants.primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: isSelected ? AppConstants.primaryColor : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                checkmarkColor: AppConstants.primaryColor,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}