import 'package:agridash/core/app_export.dart';

class ProjectDescriptionWidget extends StatefulWidget {
  final double estimatedYield;
  final String yieldUnit;
  final List<String> yieldUnits;
  final Map<String, dynamic>? cropData;
  final Function(double) onYieldChanged;
  final Function(String) onYieldUnitChanged;

  const ProjectDescriptionWidget({
    super.key,
    required this.estimatedYield,
    required this.yieldUnit,
    required this.yieldUnits,
    this.cropData,
    required this.onYieldChanged,
    required this.onYieldUnitChanged,
  });

  @override
  State<ProjectDescriptionWidget> createState() => _ProjectDescriptionWidgetState();
}

class _ProjectDescriptionWidgetState extends State<ProjectDescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    final cropColor = widget.cropData?['color'] ?? Colors.grey;
    final yieldRange = widget.cropData?['yieldRange'] ?? 'Variable';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rendement estimé',
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
              flex: 2,
              child: TextFormField(
                initialValue: widget.estimatedYield > 0 ? widget.estimatedYield.toString() : '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rendement estimé',
                  border: const OutlineInputBorder(),
                  suffixText: widget.yieldUnit,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: cropColor),
                  ),
                ),
                onChanged: (value) {
                  final yield = double.tryParse(value) ?? 0;
                  widget.onYieldChanged(yield);
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: widget.yieldUnit,
                decoration: InputDecoration(
                  labelText: 'Unité',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: cropColor),
                  ),
                ),
                items: widget.yieldUnits.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.onYieldUnitChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Yield Information
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cropColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.insights,
                size: 16,
                color: cropColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendement typique pour cette culture:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.textColor.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      yieldRange,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cropColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Additional Notes
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Notes supplémentaires (optionnel)',
            hintText: 'Informations sur le sol, irrigation, techniques spéciales...',
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cropColor),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}