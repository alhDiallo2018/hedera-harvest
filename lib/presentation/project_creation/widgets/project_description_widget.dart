import 'package:agridash/core/app_export.dart';

class ProjectDescriptionWidget extends StatelessWidget {
  final double estimatedYield;
  final String yieldUnit;
  final List<String> yieldUnits;
  final Function(double) onYieldChanged;
  final Function(String) onYieldUnitChanged;

  const ProjectDescriptionWidget({
    super.key,
    required this.estimatedYield,
    required this.yieldUnit,
    required this.yieldUnits,
    required this.onYieldChanged,
    required this.onYieldUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
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
        
        // Yield Input
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: estimatedYield > 0 ? estimatedYield.toString() : '',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantité estimée',
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
                onChanged: (value) {
                  final yield = double.tryParse(value) ?? 0;
                  onYieldChanged(yield);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez estimer le rendement';
                  }
                  final yield = double.tryParse(value) ?? 0;
                  if (yield <= 0) {
                    return 'Le rendement doit être positif';
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: yieldUnit,
                items: yieldUnits.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (unit) {
                  if (unit != null) {
                    onYieldUnitChanged(unit);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Unité',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Help Information
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Estimez le rendement total que vous prévoyez pour cette culture. Cette information aide les investisseurs à évaluer le potentiel du projet.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Additional Notes
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Notes supplémentaires (optionnel)',
            hintText: 'Ajoutez des informations complémentaires sur votre projet...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          maxLength: 500,
        ),
      ],
    );
  }
}