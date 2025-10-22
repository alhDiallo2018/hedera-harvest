import 'package:agridash/core/app_export.dart';

import 'widgets/index.dart';

class ProjectCreation extends StatefulWidget {
  const ProjectCreation({super.key});

  @override
  State<ProjectCreation> createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();
  
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  int _currentPage = 0;
  bool _isSubmitting = false;

  // Form data
  String _title = '';
  String _description = '';
  CropType _selectedCrop = CropType.maize;
  String _location = '';
  double _investmentNeeded = 50000;
  DateTime _startDate = DateTime.now();
  DateTime _harvestDate = DateTime.now().add(const Duration(days: 180));
  double _estimatedYield = 0;
  String _yieldUnit = 'kg';
  List<String> _images = [];

  final List<String> _yieldUnits = ['kg', 'tonnes', 'sacs', 'litres', 'unités'];

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _harvestDate = _startDate.add(const Duration(days: 180));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    } else {
      NavigationService().goBack();
    }
  }

  Future<void> _submitProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final result = await _projectService.createProject(
        farmerId: user.id,
        farmerName: user.name,
        title: _title,
        description: _description,
        cropType: _selectedCrop,
        location: _location,
        totalInvestmentNeeded: _investmentNeeded,
        startDate: _startDate,
        harvestDate: _harvestDate,
        estimatedYield: _estimatedYield,
        yieldUnit: _yieldUnit,
        imageUrls: _images,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (result['success'] == true) {
        _showSuccessModal(result['project'] as CropProject, result['tokenId'] as String);
      } else {
        NavigationService().showErrorDialog(result['error'] ?? 'Erreur lors de la création du projet');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      NavigationService().showErrorDialog('Erreur: $e');
    }
  }

  void _showSuccessModal(CropProject project, String tokenId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessModal(
        project: project,
        tokenId: tokenId,
        onContinue: () {
          NavigationService().goBack(); // Close modal
          NavigationService().goBack(); // Go back to previous screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            ProjectFormHeader(
              currentPage: _currentPage,
              totalPages: 3,
              onBack: _previousPage,
            ),

            // Progress Bar
            LinearProgressIndicator(
              value: (_currentPage + 1) / 3,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Page 1: Basic Information
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ProjectBasicInfoForm(
                            title: _title,
                            description: _description,
                            selectedCrop: _selectedCrop,
                            onTitleChanged: (value) => setState(() => _title = value),
                            onDescriptionChanged: (value) => setState(() => _description = value),
                            onCropChanged: (crop) => setState(() => _selectedCrop = crop),
                          ),
                          const SizedBox(height: 32),
                          CreateProjectButton(
                            text: 'Continuer',
                            onPressed: _nextPage,
                          ),
                        ],
                      ),
                    ),

                    // Page 2: Details and Investment
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          LocationPickerWidget(
                            location: _location,
                            onLocationChanged: (value) => setState(() => _location = value),
                          ),
                          const SizedBox(height: 24),
                          ProjectDurationWidget(
                            startDate: _startDate,
                            harvestDate: _harvestDate,
                            onStartDateChanged: (date) => setState(() => _startDate = date),
                            onHarvestDateChanged: (date) => setState(() => _harvestDate = date),
                          ),
                          const SizedBox(height: 24),
                          InvestmentAmountWidget(
                            investmentNeeded: _investmentNeeded,
                            onInvestmentChanged: (value) => setState(() => _investmentNeeded = value),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _previousPage,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppConstants.textColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retour'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CreateProjectButton(
                                  text: 'Continuer',
                                  onPressed: _nextPage,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Page 3: Final Details and Submission
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ProjectDescriptionWidget(
                            estimatedYield: _estimatedYield,
                            yieldUnit: _yieldUnit,
                            yieldUnits: _yieldUnits,
                            onYieldChanged: (value) => setState(() => _estimatedYield = value),
                            onYieldUnitChanged: (unit) => setState(() => _yieldUnit = unit),
                          ),
                          const SizedBox(height: 24),
                          PhotoUploadWidget(
                            images: _images,
                            onImagesChanged: (images) => setState(() => _images = images),
                          ),
                          const SizedBox(height: 24),
                          CategoryTagsWidget(
                            selectedCrop: _selectedCrop,
                            onCropChanged: (crop) => setState(() => _selectedCrop = crop),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _previousPage,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppConstants.textColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retour'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CreateProjectButton(
                                  text: _isSubmitting ? 'Création...' : 'Créer le Projet',
                                  onPressed: _isSubmitting ? null : _submitProject,
                                  isLoading: _isSubmitting,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}