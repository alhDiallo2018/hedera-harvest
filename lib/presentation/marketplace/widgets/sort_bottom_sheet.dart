import 'package:agridash/core/app_export.dart';

class SortBottomSheet extends StatelessWidget {
  final List<String> sortOptions;
  final String selectedSort;
  final ValueChanged<String> onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.sortOptions,
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trier par',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...sortOptions.map((option) {
            return ListTile(
              title: Text(option),
              trailing: option == selectedSort
                  ? Icon(Icons.check, color: AppConstants.primaryColor)
                  : null,
              onTap: () {
                onSortSelected(option);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}