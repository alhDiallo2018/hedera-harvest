class CropInvestment {
  final String id;
  final String name;
  final String type;
  final double investedAmount;
  final double currentValue;
  final double returnPercentage;
  final String duration;
  final String status;
  final String? tokenId;
  final String farmerId;
  final int totalTokens;
  final int availableTokens;
  final double tokenPrice;
  final DateTime harvestDate;
  final double estimatedYield;
  final String? transactionHash;

  CropInvestment({
    required this.id,
    required this.name,
    required this.type,
    required this.investedAmount,
    required this.currentValue,
    required this.returnPercentage,
    required this.duration,
    required this.status,
    this.tokenId,
    required this.farmerId,
    required this.totalTokens,
    required this.availableTokens,
    required this.tokenPrice,
    required this.harvestDate,
    required this.estimatedYield,
    this.transactionHash,
  });

  factory CropInvestment.fromJson(Map<String, dynamic> json) {
    return CropInvestment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      investedAmount: (json['investedAmount'] ?? 0).toDouble(),
      currentValue: (json['currentValue'] ?? 0).toDouble(),
      returnPercentage: (json['returnPercentage'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      status: json['status'] ?? '',
      tokenId: json['tokenId'],
      farmerId: json['farmerId'] ?? '',
      totalTokens: json['totalTokens'] ?? 0,
      availableTokens: json['availableTokens'] ?? 0,
      tokenPrice: (json['tokenPrice'] ?? 0).toDouble(),
      harvestDate: DateTime.parse(json['harvestDate'] ?? DateTime.now().toIso8601String()),
      estimatedYield: (json['estimatedYield'] ?? 0).toDouble(),
      transactionHash: json['transactionHash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'investedAmount': investedAmount,
      'currentValue': currentValue,
      'returnPercentage': returnPercentage,
      'duration': duration,
      'status': status,
      'tokenId': tokenId,
      'farmerId': farmerId,
      'totalTokens': totalTokens,
      'availableTokens': availableTokens,
      'tokenPrice': tokenPrice,
      'harvestDate': harvestDate.toIso8601String(),
      'estimatedYield': estimatedYield,
      'transactionHash': transactionHash,
    };
  }

  // Méthode utilitaire pour vérifier si c'est tokenisé
  bool get isTokenized => tokenId != null && tokenId!.isNotEmpty;

  // Méthode pour obtenir le pourcentage de financement
  double get fundingPercentage {
    if (totalTokens == 0) return 0;
    return ((totalTokens - availableTokens) / totalTokens * 100);
  }

  // Méthode pour créer une copie avec des valeurs mises à jour
  CropInvestment copyWith({
    String? id,
    String? name,
    String? type,
    double? investedAmount,
    double? currentValue,
    double? returnPercentage,
    String? duration,
    String? status,
    String? tokenId,
    String? farmerId,
    int? totalTokens,
    int? availableTokens,
    double? tokenPrice,
    DateTime? harvestDate,
    double? estimatedYield,
    String? transactionHash,
  }) {
    return CropInvestment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      investedAmount: investedAmount ?? this.investedAmount,
      currentValue: currentValue ?? this.currentValue,
      returnPercentage: returnPercentage ?? this.returnPercentage,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      tokenId: tokenId ?? this.tokenId,
      farmerId: farmerId ?? this.farmerId,
      totalTokens: totalTokens ?? this.totalTokens,
      availableTokens: availableTokens ?? this.availableTokens,
      tokenPrice: tokenPrice ?? this.tokenPrice,
      harvestDate: harvestDate ?? this.harvestDate,
      estimatedYield: estimatedYield ?? this.estimatedYield,
      transactionHash: transactionHash ?? this.transactionHash,
    );
  }
}