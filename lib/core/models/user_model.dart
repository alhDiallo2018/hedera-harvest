class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phone;
  final String? location;
  final double balance;
  final DateTime joinedDate;
  final Map<String, dynamic>? profileData;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.location,
    this.balance = 0.0,
    required this.joinedDate,
    this.profileData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      phone: json['phone'],
      location: json['location'],
      balance: (json['balance'] ?? 0).toDouble(),
      joinedDate: DateTime.parse(json['joinedDate']),
      profileData: json['profileData'],
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
      'joinedDate': joinedDate.toIso8601String(),
      'profileData': profileData,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? phone,
    String? location,
    double? balance,
    DateTime? joinedDate,
    Map<String, dynamic>? profileData,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      balance: balance ?? this.balance,
      joinedDate: joinedDate ?? this.joinedDate,
      profileData: profileData ?? this.profileData,
    );
  }
}

enum UserRole { admin, farmer, investor }

extension UserRoleExtension on UserRole {
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

  List<String> get permissions {
    switch (this) {
      case UserRole.admin:
        return [
          'manage_users',
          'view_all_projects',
          'manage_system',
          'view_reports'
        ];
      case UserRole.farmer:
        return [
          'create_projects',
          'manage_own_projects',
          'view_investments',
          'update_crop_status'
        ];
      case UserRole.investor:
        return [
          'invest_in_projects',
          'view_portfolio',
          'track_investments',
          'withdraw_earnings'
        ];
    }
  }
}