import 'package:agridash/core/app_export.dart';
import 'package:agridash/presentation/project_creation/widgets/crop_type_bottom_sheet.dart';

class ProjectBasicInfoForm extends StatefulWidget {
  final String title;
  final String description;
  final CropType selectedCrop;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;
  final Function(CropType) onCropChanged;

  const ProjectBasicInfoForm({
    super.key,
    required this.title,
    required this.description,
    required this.selectedCrop,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onCropChanged,
  });

  @override
  State<ProjectBasicInfoForm> createState() => _ProjectBasicInfoFormState();
}

class _ProjectBasicInfoFormState extends State<ProjectBasicInfoForm> {
  void _showCropTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CropTypeBottomSheet(
        selectedCrop: widget.selectedCrop,
        onCropSelected: (crop) {
          widget.onCropChanged(crop);
          NavigationService().goBack();
        },
      ),
    );
  }

  String _getCropDisplayName(CropType crop) {
    switch (crop) {
      case CropType.maize:
        return 'Maïs';
      case CropType.rice:
        return 'Riz';
      case CropType.tomato:
        return 'Tomate';
      case CropType.coffee:
        return 'Café';
      case CropType.cocoa:
        return 'Cacao';
      case CropType.cotton:
        return 'Coton';
      case CropType.wheat:
        return 'Blé';
      case CropType.soybean:
        return 'Soja';
      default:
        return 'Autre';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de base',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Project Title
        TextFormField(
          initialValue: widget.title,
          decoration: const InputDecoration(
            labelText: 'Titre du projet',
            hintText: 'Ex: Culture de Maïs Bio en Normandie',
            border: OutlineInputBorder(),
          ),
          maxLength: 100,
          onChanged: widget.onTitleChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un titre pour votre projet';
            }
            if (value.length < 10) {
              return 'Le titre doit contenir au moins 10 caractères';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Crop Type Selection
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type de culture',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showCropTypeBottomSheet,
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
                      Icons.eco,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getCropDisplayName(widget.selectedCrop),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Project Description
        TextFormField(
          initialValue: widget.description,
          decoration: const InputDecoration(
            labelText: 'Description du projet',
            hintText: 'Décrivez votre projet en détail...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          maxLength: 1000,
          onChanged: widget.onDescriptionChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une description pour votre projet';
            }
            if (value.length < 50) {
              return 'La description doit contenir au moins 50 caractères';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 8),
        
        // Help Text
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Une description détaillée augmente les chances de financement de votre projet',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}