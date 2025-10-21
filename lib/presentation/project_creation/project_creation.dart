import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/hedera_service.dart';
import './widgets/category_tags_widget.dart';
import './widgets/create_project_button.dart';
import './widgets/crop_type_bottom_sheet.dart';
import './widgets/investment_amount_widget.dart';
import './widgets/location_picker_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/project_basic_info_form.dart';
import './widgets/project_description_widget.dart';
import './widgets/project_duration_widget.dart';
import './widgets/project_form_header.dart';
import './widgets/success_modal.dart';

class ProjectCreation extends StatefulWidget {
  const ProjectCreation({super.key});

  @override
  State<ProjectCreation> createState() => _ProjectCreationState();
}

class _ProjectCreationState extends State<ProjectCreation> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final HederaService _hederaService = HederaService();

  // Form state variables
  String _projectName = '';
  String? _selectedCropType;
  String? _selectedLocation;
  LatLng? _selectedCoordinates;
  DateTime? _startDate;
  DateTime? _endDate;
  double _investmentGoal = 10000.0;
  List<XFile> _selectedImages = [];
  String _description = '';
  List<String> _selectedTags = [];
  bool _isCreatingProject = false;
  bool _isDraftSaved = false;

  // Nouveaux champs pour Hedera
  int _quantity = 0;
  double _estimatedValue = 0;
  DateTime? _harvestDate;

  // Form validation
  bool get _isFormValid {
    return _projectName.isNotEmpty &&
        _selectedCropType != null &&
        _selectedLocation != null &&
        _startDate != null &&
        _endDate != null &&
        _description.isNotEmpty &&
        _description.length >= 50 &&
        _quantity > 0 &&
        _estimatedValue > 0 &&
        _harvestDate != null;
  }

  @override
  void initState() {
    super.initState();
    _loadDraftData();
    _hederaService.initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // In a real app, this would load from local storage
    // For demo purposes, we'll leave it empty
  }

  void _saveDraft() {
    // Auto-save draft data
    setState(() => _isDraftSaved = true);

    // In a real app, this would save to local storage
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isDraftSaved = false);
      }
    });
  }

  void _showCropTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CropTypeBottomSheet(
        onCropSelected: (cropType) {
          setState(() => _selectedCropType = cropType);
          _saveDraft();
        },
      ),
    );
  }

  void _onLocationSelected(String location, LatLng coordinates) {
    setState(() {
      _selectedLocation = location;
      _selectedCoordinates = coordinates;
    });
    _saveDraft();
  }

  void _onStartDateSelected(DateTime date) {
    setState(() => _startDate = date);
    _saveDraft();
  }

  void _onEndDateSelected(DateTime date) {
    setState(() => _endDate = date);
    _saveDraft();
  }

  void _onInvestmentGoalChanged(double amount) {
    setState(() => _investmentGoal = amount);
    _saveDraft();
  }

  void _onImagesChanged(List<XFile> images) {
    setState(() => _selectedImages = images);
    _saveDraft();
  }

  void _onDescriptionChanged(String description) {
    setState(() => _description = description);
    _saveDraft();
  }

  void _onTagsChanged(List<String> tags) {
    setState(() => _selectedTags = tags);
    _saveDraft();
  }

  void _onNameChanged(String name) {
    setState(() => _projectName = name);
    _saveDraft();
  }

  // Nouvelles méthodes pour Hedera
  void _onQuantityChanged(String value) {
    final quantity = int.tryParse(value) ?? 0;
    setState(() => _quantity = quantity);
    _saveDraft();
  }

  void _onEstimatedValueChanged(String value) {
    final estimatedValue = double.tryParse(value) ?? 0;
    setState(() => _estimatedValue = estimatedValue);
    _saveDraft();
  }

  void _onHarvestDateSelected(DateTime date) {
    setState(() => _harvestDate = date);
    _saveDraft();
  }

  Future<void> _createProject() async {
    if (!_isFormValid) return;

    setState(() => _isCreatingProject = true);

    try {
      // Étape 1: Tokeniser la récolte sur Hedera
      final tokenId = await _hederaService.tokenizeCrop(
        farmerId: 'farmer_${DateTime.now().millisecondsSinceEpoch}', // ID unique
        cropType: _selectedCropType!,
        quantity: _quantity,
        estimatedValue: _estimatedValue,
        harvestDate: _harvestDate!,
      );

      // Étape 2: Créer les données du projet avec le token ID
      final projectData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _projectName,
        'cropType': _selectedCropType,
        'location': _selectedLocation,
        'coordinates': {
          'latitude': _selectedCoordinates?.latitude,
          'longitude': _selectedCoordinates?.longitude,
        },
        'startDate': _startDate?.toIso8601String(),
        'endDate': _endDate?.toIso8601String(),
        'investmentGoal': _investmentGoal,
        'description': _description,
        'tags': _selectedTags,
        'images': _selectedImages.map((img) => img.path).toList(),
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'active',
        'fundingProgress': 0.0,
        // Données Hedera
        'tokenId': tokenId,
        'quantity': _quantity,
        'estimatedValue': _estimatedValue,
        'harvestDate': _harvestDate?.toIso8601String(),
        'availableTokens': _quantity,
        'tokenPrice': _investmentGoal / _quantity,
      };

      setState(() => _isCreatingProject = false);

      // Afficher le modal de succès avec les infos Hedera
      _showSuccessModal(tokenId);
    } catch (e) {
      setState(() => _isCreatingProject = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création du projet: $e'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _showSuccessModal(String tokenId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessModal(
        projectName: _projectName,
        tokenId: tokenId,
        onViewProject: () {
          Navigator.pushReplacementNamed(context, '/project-details');
        },
        onCreateAnother: () {
          _resetForm();
        },
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _projectName = '';
      _selectedCropType = null;
      _selectedLocation = null;
      _selectedCoordinates = null;
      _startDate = null;
      _endDate = null;
      _investmentGoal = 10000.0;
      _selectedImages = [];
      _description = '';
      _selectedTags = [];
      _quantity = 0;
      _estimatedValue = 0;
      _harvestDate = null;
    });

    _nameController.clear();
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header with progress
          ProjectFormHeader(
            currentStep: _calculateCurrentStep(),
            totalSteps: 9, // Augmenté pour inclure les nouvelles étapes
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Draft save indicator
                  if (_isDraftSaved)
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_done,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Brouillon sauvegardé automatiquement',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 2.h),

                  // Basic Information Form
                  ProjectBasicInfoForm(
                    nameController: _nameController,
                    selectedCropType: _selectedCropType,
                    onCropTypeSelect: _showCropTypeBottomSheet,
                    onNameChanged: _onNameChanged,
                  ),

                  // Location Picker
                  LocationPickerWidget(
                    selectedLocation: _selectedLocation,
                    selectedCoordinates: _selectedCoordinates,
                    onLocationSelected: _onLocationSelected,
                  ),

                  // Project Duration
                  ProjectDurationWidget(
                    startDate: _startDate,
                    endDate: _endDate,
                    onStartDateSelected: _onStartDateSelected,
                    onEndDateSelected: _onEndDateSelected,
                  ),

                  // Section Tokenisation Hedera
                  _buildHederaTokenizationSection(),

                  // Investment Amount
                  InvestmentAmountWidget(
                    investmentGoal: _investmentGoal,
                    onInvestmentGoalChanged: _onInvestmentGoalChanged,
                  ),

                  // Photo Upload
                  PhotoUploadWidget(
                    selectedImages: _selectedImages,
                    onImagesChanged: _onImagesChanged,
                  ),

                  // Project Description
                  ProjectDescriptionWidget(
                    description: _description,
                    onDescriptionChanged: _onDescriptionChanged,
                  ),

                  // Category Tags
                  CategoryTagsWidget(
                    selectedTags: _selectedTags,
                    onTagsChanged: _onTagsChanged,
                  ),

                  SizedBox(height: 10.h), // Space for sticky button
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky create button
      bottomNavigationBar: CreateProjectButton(
        isEnabled: _isFormValid,
        isLoading: _isCreatingProject,
        onPressed: _createProject,
        buttonText: 'Tokeniser sur Hedera', // Texte mis à jour
      ),
    );
  }

  Widget _buildHederaTokenizationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.token,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                'Tokenisation sur Hedera',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Tokenisez votre future récolte pour obtenir du financement décentralisé',
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Quantité estimée
          _buildHederaNumberField(
            label: 'Quantité estimée (sacs)',
            hint: 'Ex: 50',
            onChanged: _onQuantityChanged,
            value: _quantity > 0 ? _quantity.toString() : '',
          ),

          // Valeur estimée
          _buildHederaNumberField(
            label: 'Valeur estimée (FCFA)',
            hint: 'Ex: 500000',
            onChanged: _onEstimatedValueChanged,
            value: _estimatedValue > 0 ? _estimatedValue.toStringAsFixed(0) : '',
          ),

          // Date de récolte
          _buildHarvestDatePicker(),
        ],
      ),
    );
  }

  Widget _buildHederaNumberField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          controller: TextEditingController(text: value),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildHarvestDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date de récolte estimée',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _harvestDate ?? DateTime.now().add(Duration(days: 90)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (selectedDate != null) {
              _onHarvestDateSelected(selectedDate);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _harvestDate != null 
                    ? '${_harvestDate!.day}/${_harvestDate!.month}/${_harvestDate!.year}'
                    : 'Sélectionner une date',
                  style: GoogleFonts.roboto(),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _calculateCurrentStep() {
    int step = 1;

    if (_projectName.isNotEmpty && _selectedCropType != null) step = 2;
    if (_selectedLocation != null) step = 3;
    if (_startDate != null && _endDate != null) step = 4;
    if (_quantity > 0 && _estimatedValue > 0) step = 5;
    if (_harvestDate != null) step = 6;
    if (_investmentGoal > 1000) step = 7;
    if (_selectedImages.isNotEmpty) step = 8;
    if (_description.isNotEmpty && _description.length >= 50) step = 9;

    return step;
  }
}