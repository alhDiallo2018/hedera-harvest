import 'package:agridash/core/app_export.dart';

class SortBottomSheet extends StatelessWidget {
  final List<String> sortOptions;
  final String selectedSort;
  final Function(String) onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.sortOptions,
    required this.selectedSort,
    required this.onSortSelected,
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
            'Trier par',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...sortOptions.map((option) {
            final isSelected = selectedSort == option;
            
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? AppConstants.primaryColor : Colors.grey.shade400,
              ),
              title: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: () => onSortSelected(option),
            );
          }).toList(),
        ],
      ),
    );
  }
}