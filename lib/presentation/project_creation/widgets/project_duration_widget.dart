import 'package:agridash/core/app_export.dart';

class ProjectDurationWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime harvestDate;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onHarvestDateChanged;

  const ProjectDurationWidget({
    super.key,
    required this.startDate,
    required this.harvestDate,
    required this.onStartDateChanged,
    required this.onHarvestDateChanged,
  });

  @override
  State<ProjectDurationWidget> createState() => _ProjectDurationWidgetState();
}

class _ProjectDurationWidgetState extends State<ProjectDurationWidget> {
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != widget.startDate) {
      widget.onStartDateChanged(picked);
    }
  }

  Future<void> _selectHarvestDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.harvestDate,
      firstDate: widget.startDate.add(const Duration(days: 30)),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != widget.harvestDate) {
      widget.onHarvestDateChanged(picked);
    }
  }

  int get _totalDuration {
    return widget.harvestDate.difference(widget.startDate).inDays;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Durée du projet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Start Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date de début',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectStartDate,
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
                      Icons.calendar_today_outlined,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(widget.startDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Harvest Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date de récolte estimée',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectHarvestDate,
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
                      Icons.agriculture_outlined,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(widget.harvestDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Duration Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Durée totale du projet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textColor,
                ),
              ),
              Text(
                '$_totalDuration jours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}