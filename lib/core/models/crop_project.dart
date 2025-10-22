class CropProject {
  final String id;
  final String farmerId;
  final String farmerName;
  final String title;
  final String description;
  final CropType cropType;
  final String location;
  final double totalInvestmentNeeded;
  final double currentInvestment;
  final int totalTokens;
  final int availableTokens;
  final double tokenPrice;
  final DateTime startDate;
  final DateTime harvestDate;
  final ProjectStatus status;
  final List<String> imageUrls;
  final double estimatedYield;
  final String yieldUnit;
  final double estimatedReturns;
  final List<ProjectUpdate> updates;
  final DateTime createdAt;

  CropProject({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.title,
    required this.description,
    required this.cropType,
    required this.location,
    required this.totalInvestmentNeeded,
    required this.totalTokens,
    required this.tokenPrice,
    required this.startDate,
    required this.harvestDate,
    this.currentInvestment = 0.0,
    this.availableTokens = 0,
    this.status = ProjectStatus.funding,
    this.imageUrls = const [],
    this.estimatedYield = 0.0,
    this.yieldUnit = 'kg',
    this.estimatedReturns = 0.0,
    this.updates = const [],
    required this.createdAt,
  });

  factory CropProject.fromJson(Map<String, dynamic> json) {
    return CropProject(
      id: json['id'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      title: json['title'],
      description: json['description'],
      cropType: CropType.values.firstWhere(
        (e) => e.name == json['cropType'],
        orElse: () => CropType.other,
      ),
      location: json['location'],
      totalInvestmentNeeded: (json['totalInvestmentNeeded'] ?? 0).toDouble(),
      currentInvestment: (json['currentInvestment'] ?? 0).toDouble(),
      totalTokens: json['totalTokens'] ?? 0,
      availableTokens: json['availableTokens'] ?? 0,
      tokenPrice: (json['tokenPrice'] ?? 0).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      harvestDate: DateTime.parse(json['harvestDate']),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.funding,
      ),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      estimatedYield: (json['estimatedYield'] ?? 0).toDouble(),
      yieldUnit: json['yieldUnit'] ?? 'kg',
      estimatedReturns: (json['estimatedReturns'] ?? 0).toDouble(),
      updates: List<Map<String, dynamic>>.from(json['updates'] ?? [])
          .map((update) => ProjectUpdate.fromJson(update))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'title': title,
      'description': description,
      'cropType': cropType.name,
      'location': location,
      'totalInvestmentNeeded': totalInvestmentNeeded,
      'currentInvestment': currentInvestment,
      'totalTokens': totalTokens,
      'availableTokens': availableTokens,
      'tokenPrice': tokenPrice,
      'startDate': startDate.toIso8601String(),
      'harvestDate': harvestDate.toIso8601String(),
      'status': status.name,
      'imageUrls': imageUrls,
      'estimatedYield': estimatedYield,
      'yieldUnit': yieldUnit,
      'estimatedReturns': estimatedReturns,
      'updates': updates.map((update) => update.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  double get progressPercentage {
    return (currentInvestment / totalInvestmentNeeded * 100).clamp(0, 100);
  }

  int get daysToHarvest {
    return harvestDate.difference(DateTime.now()).inDays;
  }

  String get statusDisplay {
    switch (status) {
      case ProjectStatus.draft:
        return 'Brouillon';
      case ProjectStatus.funding:
        return 'En financement';
      case ProjectStatus.active:
        return 'En cours';
      case ProjectStatus.harvested:
        return 'Récolté';
      case ProjectStatus.completed:
        return 'Terminé';
      case ProjectStatus.cancelled:
        return 'Annulé';
    }
  }

  bool get canInvest {
    return status == ProjectStatus.funding && availableTokens > 0;
  }

  double get estimatedROI {
    return ((estimatedReturns - totalInvestmentNeeded) / totalInvestmentNeeded * 100);
  }
}

class ProjectUpdate {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final List<String> images;
  final UpdateType type;

  ProjectUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.images = const [],
    required this.type,
  });

  factory ProjectUpdate.fromJson(Map<String, dynamic> json) {
    return ProjectUpdate(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      images: List<String>.from(json['images'] ?? []),
      type: UpdateType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => UpdateType.general,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'images': images,
      'type': type.name,
    };
  }
}

enum CropType {
  maize,
  rice,
  tomato,
  coffee,
  cocoa,
  cotton,
  wheat,
  soybean,
  other,
}

enum ProjectStatus {
  draft,
  funding,
  active,
  harvested,
  completed,
  cancelled,
}

enum UpdateType {
  planting,
  growth,
  maintenance,
  harvest,
  general,
}