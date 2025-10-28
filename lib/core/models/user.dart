class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phone;
  final String? location;
  final double balance;
  final String? hederaAccountId;
  final String? hederaPublicKey;
  final Map<String, dynamic>? profileData;
  final DateTime joinedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.location,
    this.balance = 0.0,
    this.hederaAccountId,
    this.hederaPublicKey,
    this.profileData,
    required this.joinedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: _parseUserRole(json['role']),
      phone: json['phone'],
      location: json['location'],
      balance: (json['balance'] ?? 0).toDouble(),
      hederaAccountId: json['hederaAccountId'],
      hederaPublicKey: json['hederaPublicKey'],
      profileData: json['profileData'] is Map ? Map<String, dynamic>.from(json['profileData']) : null,
      joinedDate: DateTime.parse(json['joinedDate'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'phone': phone,
      'location': location,
      'balance': balance,
      'hederaAccountId': hederaAccountId,
      'hederaPublicKey': hederaPublicKey,
      'profileData': profileData,
      'joinedDate': joinedDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static UserRole _parseUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'farmer':
        return UserRole.farmer;
      case 'investor':
        return UserRole.investor;
      default:
        return UserRole.farmer;
    }
  }
}

enum UserRole {
  admin,
  farmer,
  investor;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.farmer:
        return 'Agriculteur';
      case UserRole.investor:
        return 'Investisseur';
    }
  }
}