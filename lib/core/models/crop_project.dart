class CropProject {
  final String id;
  final String farmerId;
  final String farmerName;
  final String title;
  final String tokenId;
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
    this.tokenId = '',
    required this.createdAt,
  });

  factory CropProject.fromJson(Map<String, dynamic> json) {
    // 🔍 Correction intelligente pour imageUrls
    List<String> parseImageUrls(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      } else if (data is String) {
        // Si c'est une string séparée par des virgules
        return data.split(',').map((e) => e.trim()).toList();
      }
      return [];
    }

    // 🔍 Correction pour le cropType
    CropType parseCropType(dynamic data) {
      if (data == null) return CropType.other;
      if (data is String) {
        return CropType.values.firstWhere(
          (e) => e.name.toLowerCase() == data.toLowerCase(),
          orElse: () => CropType.other,
        );
      }
      return CropType.other;
    }

    // 🔍 Correction pour le status
    ProjectStatus parseStatus(dynamic data) {
      if (data == null) return ProjectStatus.funding;
      if (data is String) {
        return ProjectStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == data.toLowerCase(),
          orElse: () => ProjectStatus.funding,
        );
      }
      return ProjectStatus.funding;
    }

    // 🔍 Correction pour les mises à jour
    List<ProjectUpdate> parseUpdates(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data.map((update) {
          try {
            return ProjectUpdate.fromJson(update);
          } catch (e) {
            return ProjectUpdate(
              id: '',
              title: 'Mise à jour',
              description: '',
              date: DateTime.now(),
              type: UpdateType.general,
            );
          }
        }).toList();
      }
      return [];
    }

    return CropProject(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      tokenId: json['tokenId']?.toString() ?? '',
      farmerId: json['farmerId']?.toString() ?? '',
      farmerName: json['farmerName']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Projet sans titre',
      description: json['description']?.toString() ?? '',
      cropType: parseCropType(json['cropType']),
      location: json['location']?.toString() ?? '',
      totalInvestmentNeeded: (json['totalInvestmentNeeded'] ?? json['targetAmount'] ?? 0).toDouble(),
      currentInvestment: (json['currentInvestment'] ?? 0).toDouble(),
      totalTokens: (json['totalTokens'] ?? 0).toInt(),
      availableTokens: (json['availableTokens'] ?? 0).toInt(),
      tokenPrice: (json['tokenPrice'] ?? 0).toDouble(),
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ?? DateTime.now(),
      harvestDate: DateTime.tryParse(json['harvestDate']?.toString() ?? '') ?? DateTime.now().add(const Duration(days: 90)),
      status: parseStatus(json['status']),
      imageUrls: parseImageUrls(json['imageUrls']),
      estimatedYield: (json['estimatedYield'] ?? 0).toDouble(),
      yieldUnit: json['yieldUnit']?.toString() ?? 'kg',
      estimatedReturns: (json['estimatedReturns'] ?? 0).toDouble(),
      updates: parseUpdates(json['updates']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
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
      'tokenId': tokenId,
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

  // 🔧 Propriétés calculées compatibles avec l'ancien modèle
  double get progressPercentage {
    return (currentInvestment / totalInvestmentNeeded * 100).clamp(0, 100);
  }

  // 🔧 Alias pour compatibilité avec l'ancien code
  double get targetAmount => totalInvestmentNeeded;
  double get estimatedROI => ((estimatedReturns - totalInvestmentNeeded) / totalInvestmentNeeded * 100);

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
    // 🔍 Correction pour le type de mise à jour
    UpdateType parseUpdateType(dynamic data) {
      if (data == null) return UpdateType.general;
      if (data is String) {
        return UpdateType.values.firstWhere(
          (e) => e.name.toLowerCase() == data.toLowerCase(),
          orElse: () => UpdateType.general,
        );
      }
      return UpdateType.general;
    }

    // 🔍 Correction pour les images
    List<String> parseImages(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    }

    return ProjectUpdate(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Mise à jour',
      description: json['description']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      images: parseImages(json['images']),
      type: parseUpdateType(json['type']),
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