class CropInvestment {
  final String id;
  final String projectId;
  final String investorId;
  final String farmerId;
  final double investedAmount;
  final int tokensPurchased;
  final double tokenPrice;
  final DateTime investmentDate;
  final InvestmentStatus status;
  final double? returns;
  final DateTime? returnDate;

  CropInvestment({
    required this.id,
    required this.projectId,
    required this.investorId,
    required this.farmerId,
    required this.investedAmount,
    required this.tokensPurchased,
    required this.tokenPrice,
    required this.investmentDate,
    this.status = InvestmentStatus.active,
    this.returns,
    this.returnDate,
  });

  factory CropInvestment.fromJson(Map<String, dynamic> json) {
    return CropInvestment(
      id: json['id'],
      projectId: json['projectId'],
      investorId: json['investorId'],
      farmerId: json['farmerId'],
      investedAmount: (json['investedAmount'] ?? 0).toDouble(),
      tokensPurchased: json['tokensPurchased'] ?? 0,
      tokenPrice: (json['tokenPrice'] ?? 0).toDouble(),
      investmentDate: DateTime.parse(json['investmentDate']),
      status: InvestmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => InvestmentStatus.active,
      ),
      returns: json['returns']?.toDouble(),
      returnDate: json['returnDate'] != null 
          ? DateTime.parse(json['returnDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'investorId': investorId,
      'farmerId': farmerId,
      'investedAmount': investedAmount,
      'tokensPurchased': tokensPurchased,
      'tokenPrice': tokenPrice,
      'investmentDate': investmentDate.toIso8601String(),
      'status': status.name,
      'returns': returns,
      'returnDate': returnDate?.toIso8601String(),
    };
  }

  double get potentialReturns {
    switch (status) {
      case InvestmentStatus.completed:
        return returns ?? 0.0;
      case InvestmentStatus.active:
        return investedAmount * 1.25; // 25% return estimate
      default:
        return 0.0;
    }
  }

  String get statusDisplay {
    switch (status) {
      case InvestmentStatus.active:
        return 'Actif';
      case InvestmentStatus.completed:
        return 'Terminé';
      case InvestmentStatus.cancelled:
        return 'Annulé';
      case InvestmentStatus.pending:
        return 'En attente';
    }
  }
}

enum InvestmentStatus {
  active,
  completed,
  cancelled,
  pending,
}