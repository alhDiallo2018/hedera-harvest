import 'package:agridash/core/app_export.dart';
import 'package:agridash/presentation/project_creation/widgets/category_tags_widget.dart';
import 'package:agridash/presentation/project_creation/widgets/project_description_widget.dart';
import 'package:agridash/presentation/project_creation/widgets/project_duration_widget.dart';
import 'package:agridash/presentation/project_creation/widgets/project_form_header.dart';
import 'package:image_picker/image_picker.dart';

class ProjectCreation extends StatefulWidget {
  const ProjectCreation({super.key});

  @override
  State<ProjectCreation> createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation>
    with TickerProviderStateMixin {
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  int _currentPage = 0;
  bool _isSubmitting = false;
  late AnimationController _animationController;

  // Form fields
  String _title = '';
  String _description = '';
  CropType _selectedCrop = CropType.maize;
  String _location = '';
  double _investmentNeeded = 50000;
  DateTime _startDate = DateTime.now();
  DateTime _harvestDate = DateTime.now().add(const Duration(days: 180));
  double _estimatedYield = 0;
  String _yieldUnit = 'kg';
  List<Uint8List> _images = []; // Changé pour Uint8List pour le web
  Set<String> _selectedPractices = {};

  // Controllers et limites
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  final int _titleMax = 50;
  final int _descriptionMax = 500;
  String _titleCount = '0/50';
  String _descriptionCount = '0/500';

  final List<String> _yieldUnits = ['kg', 'tonnes', 'sacs', 'litres', 'unités'];
  final List<String> _sustainablePractices = [
    'Agriculture Biologique',
    'Rotation des Cultures',
    'Gestion de l\'Eau',
    'Sols Durables',
    'Biodiversité',
    'Énergie Renouvelable',
  ];

  final Map<CropType, Map<String, dynamic>> _cropData = {
    CropType.maize: {'name': 'Maïs', 'emoji': '🌽', 'color': Colors.amber},
    CropType.rice: {'name': 'Riz', 'emoji': '🌾', 'color': Colors.green},
    CropType.tomato: {'name': 'Tomate', 'emoji': '🍅', 'color': Colors.red},
    CropType.coffee: {'name': 'Café', 'emoji': '☕', 'color': Colors.brown},
    CropType.cocoa: {'name': 'Cacao', 'emoji': '🍫', 'color': Colors.brown},
    CropType.cotton: {'name': 'Coton', 'emoji': '👕', 'color': Colors.grey},
    CropType.wheat: {'name': 'Blé', 'emoji': '🌾', 'color': Colors.amber},
    CropType.soybean: {'name': 'Soja', 'emoji': '🥜', 'color': Colors.green},
    CropType.other: {'name': 'Autre', 'emoji': '🌱', 'color': Colors.grey},
  };

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();

    _titleController = TextEditingController(text: _title);
    _descriptionController = TextEditingController(text: _description);

    _titleController.addListener(() {
      if (_titleController.text.length > _titleMax) {
        _titleController.text =
            _titleController.text.substring(0, _titleMax);
        _titleController.selection = TextSelection.fromPosition(
          TextPosition(offset: _titleController.text.length),
        );
        _showSnack('Maximum $_titleMax caractères pour le titre');
      }
      setState(() {
        _titleCount = '${_titleController.text.length}/$_titleMax';
      });
      _updateFormData('title', _titleController.text);
    });

    _descriptionController.addListener(() {
      if (_descriptionController.text.length > _descriptionMax) {
        _descriptionController.text =
            _descriptionController.text.substring(0, _descriptionMax);
        _descriptionController.selection = TextSelection.fromPosition(
          TextPosition(offset: _descriptionController.text.length),
        );
        _showSnack('Maximum $_descriptionMax caractères pour la description');
      }
      setState(() {
        _descriptionCount =
            '${_descriptionController.text.length}/$_descriptionMax';
      });
      _updateFormData('description', _descriptionController.text);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    
    // S'assurer que l'état de soumission est reset
    _isSubmitting = false;
    
    super.dispose();
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _title.trim().length >= 10 &&
            _description.trim().length >= 50;
      case 1:
        return _location.isNotEmpty && _investmentNeeded >= 1000;
      case 2:
        return true;
      default:
        return false;
    }
  }

  void _updateFormData(String field, dynamic value) {
    setState(() {
      switch (field) {
        case 'title':
          _title = value;
          break;
        case 'description':
          _description = value;
          break;
        case 'crop':
          _selectedCrop = value;
          break;
        case 'location':
          _location = value;
          break;
        case 'investment':
          _investmentNeeded = value;
          break;
        case 'startDate':
          _startDate = value;
          break;
        case 'harvestDate':
          _harvestDate = value;
          break;
        case 'yield':
          _estimatedYield = value;
          break;
        case 'yieldUnit':
          _yieldUnit = value;
          break;
        case 'images':
          _images = List<Uint8List>.from(value);
          break;
        case 'practice':
          if (_selectedPractices.contains(value)) {
            _selectedPractices.remove(value);
          } else {
            _selectedPractices.add(value);
          }
          break;
      }
    });
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (picked.isNotEmpty) {
        final List<Uint8List> imagesBytes = [];
        for (final xfile in picked) {
          final bytes = await xfile.readAsBytes();
          imagesBytes.add(bytes);
        }
        _updateFormData('images', [..._images, ...imagesBytes]);
      }
    } catch (e) {
      _showSnack('Erreur lors de la sélection des images: $e');
    }
  }

  // Méthode pour afficher les images
  Widget _buildImagePreview() {
    if (_images.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images sélectionnées:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _images.asMap().entries.map((entry) {
            final index = entry.key;
            final imageBytes = entry.value;

            return Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error_outline, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _images.removeAt(index));
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _submitProject() async {
  // Validation renforcée
  if (_title.trim().length < 10) {
    _showSnack('Le titre doit contenir au moins 10 caractères');
    return;
  }

  if (_description.trim().length < 50) {
    _showSnack('La description doit contenir au moins 50 caractères');
    return;
  }

  if (_location.trim().isEmpty) {
    _showSnack('La localisation est requise');
    return;
  }

  if (_investmentNeeded < 1000) {
    _showSnack('L\'investissement minimum est de 1000 FCFA');
    return;
  }

  setState(() => _isSubmitting = true);

  try {
    final user = _authService.currentUser;
    if (user == null) {
      _showSnack('Vous devez être connecté pour créer un projet');
      _resetSubmittingState();
      return;
    }
    
    if (user.name.isEmpty) {
      _showSnack('Erreur: nom d\'utilisateur non défini');
      _resetSubmittingState();
      return;
    }

    print('📋 DONNÉES DU PROJET:');
    print('  Titre: $_title');
    print('  Description: ${_description.length} caractères');
    print('  Localisation: $_location');
    print('  Investissement: $_investmentNeeded FCFA');
    print('  Culture: ${_selectedCrop.name}');
    print('  Nombre d\'images: ${_images.length}');

    final response = await _projectService.createProject(
      farmerId: user.id,
      farmerName: user.name,
      title: _title.trim(),
      description: _description.trim(),
      cropType: _selectedCrop,
      location: _location.trim(),
      totalInvestmentNeeded: _investmentNeeded,
      startDate: _startDate,
      harvestDate: _harvestDate,
      estimatedYield: _estimatedYield,
      yieldUnit: _yieldUnit,
      imageFiles: _images,
    );

    print('📡 RÉPONSE BACKEND COMPLÈTE: $response');

    // CORRECTION : Supprimer le type check inutile
    final bool success = response['success'] == true;
    final dynamic errorMessage = response['error'];
    
    if (success) {
      print('✅ SUCCÈS DÉTECTÉ DANS LA RÉPONSE');
      print('✅ PROJET ID: ${response['project']?['id']}');
      print('✅ TOKEN ID: ${response['token']?['tokenId']}');
    } else {
      print('💥 ERREUR BACKEND: $errorMessage');
    }

    // IMPORTANT: Reset l'état AVANT de traiter le résultat
    _resetSubmittingState();

    if (success) {
      print('🎉 PROJET CRÉÉ AVEC SUCCÈS - NAVIGATION');
      _showSnack('✅ Projet créé avec succès!');
      
      // Rafraîchir les projets
      await _projectService.fetchProjectsFromBackend();
      
      // Navigation avec délai pour stabilité
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      _showSnack('❌ Erreur: ${errorMessage ?? 'Échec de création'}');
    }
  } catch (e, st) {
    print('💥 EXCEPTION CAPTURÉE: $e');
    print('📝 STACK TRACE: $st');
    
    _resetSubmittingState();
    _showSnack('❌ Erreur: ${e.toString()}');
  }
}

  // Méthode dédiée pour reset l'état de soumission
  void _resetSubmittingState() {
    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    } else {
      _isSubmitting = false;
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 2 && _validateCurrentPage()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (!_validateCurrentPage()) {
      _showSnack('Veuillez remplir tous les champs obligatoires');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Color get _cropColor => _cropData[_selectedCrop]?['color'] ?? Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: ProjectFormHeader(
        currentPage: _currentPage,
        totalPages: 3,
        onBack: _previousPage,
        cropColor: _cropColor,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [_buildStep1(), _buildStep2(), _buildStep3()],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Titre du projet',
              counterText: _titleCount,
              border: const OutlineInputBorder(),
              hintText: 'Ex: Plantation de maïs durable',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Le titre est requis';
              }
              if (v.trim().length < 10) {
                return 'Minimum 10 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<CropType>(
            value: _selectedCrop,
            items: CropType.values
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      '${_cropData[c]?['emoji'] ?? ''} ${_cropData[c]?['name'] ?? c.name}',
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => _updateFormData('crop', v),
            decoration: const InputDecoration(
              labelText: 'Culture',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Description du projet',
              counterText: _descriptionCount,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
              hintText: 'Décrivez votre projet agricole en détail...',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'La description est requise';
              }
              if (v.trim().length < 50) {
                return 'Minimum 50 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _validateCurrentPage() ? _nextPage : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _cropColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continuer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            initialValue: _location,
            decoration: const InputDecoration(
              labelText: 'Localisation',
              border: OutlineInputBorder(),
              hintText: 'Ex: Dakar, Sénégal',
            ),
            onChanged: (v) => _updateFormData('location', v),
            validator: (v) => (v == null || v.isEmpty) ? 'La localisation est requise' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.number,
            initialValue: _investmentNeeded.toStringAsFixed(0),
            decoration: const InputDecoration(
              labelText: 'Montant nécessaire (FCFA)',
              border: OutlineInputBorder(),
              prefixText: 'FCFA ',
              hintText: '50000',
            ),
            onChanged: (v) => _updateFormData(
              'investment',
              double.tryParse(v.replaceAll(',', '').replaceAll(' ', '')) ?? 0,
            ),
            validator: (v) {
              final value = double.tryParse(v?.replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0;
              if (value < 1000) {
                return 'Minimum 1000 FCFA';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ProjectDurationWidget(
            startDate: _startDate,
            harvestDate: _harvestDate,
            onStartDateChanged: (d) => _updateFormData('startDate', d),
            onHarvestDateChanged: (d) => _updateFormData('harvestDate', d),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousPage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _cropColor,
                    side: BorderSide(color: _cropColor),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Retour',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _validateCurrentPage() ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cropColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProjectDescriptionWidget(
            estimatedYield: _estimatedYield,
            yieldUnit: _yieldUnit,
            yieldUnits: _yieldUnits,
            cropData: _cropData[_selectedCrop] ?? {},
            onYieldChanged: (v) => _updateFormData('yield', v),
            onYieldUnitChanged: (u) => _updateFormData('yieldUnit', u),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Photos du projet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ajoutez des photos pour illustrer votre projet (optionnel)',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Ajouter des photos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cropColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _buildImagePreview(),
            ],
          ),
          const SizedBox(height: 16),
          CategoryTagsWidget(
            selectedCrop: _selectedCrop,
            selectedPractices: _selectedPractices,
            sustainablePractices: _sustainablePractices,
            cropColor: _cropColor,
            onPracticeSelected: (p) => _updateFormData('practice', p),
            cropCategory: _cropData[_selectedCrop]?['name'] ?? '',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : _previousPage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _cropColor,
                    side: BorderSide(color: _cropColor),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Retour',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitting ? Colors.grey : _cropColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Créer le Projet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}