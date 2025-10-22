// Arguments for project details screen
class ProjectDetailsArgs {
  final String projectId;
  final bool fromMarketplace;

  ProjectDetailsArgs({
    required this.projectId,
    this.fromMarketplace = false,
  });
}

// Arguments for crop detail screen
class CropDetailArgs {
  final String cropId;
  final String? projectId;

  CropDetailArgs({
    required this.cropId,
    this.projectId,
  });
}

// Arguments for investment screen
class InvestmentArgs {
  final String projectId;
  final double? presetAmount;

  InvestmentArgs({
    required this.projectId,
    this.presetAmount,
  });
}

// Arguments for profile editing
class ProfileEditArgs {
  final bool isEditing;
  final Map<String, dynamic>? initialData;

  ProfileEditArgs({
    this.isEditing = false,
    this.initialData,
  });
}