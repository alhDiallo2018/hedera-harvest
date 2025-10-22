import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _usersKey = 'registered_users';

  UserModel? _currentUser;
  String? _authToken;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    _authToken = prefs.getString(_tokenKey);

    if (userJson != null) {
      _currentUser = UserModel.fromJson(json.decode(userJson));
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      final List<dynamic> users = usersJson != null ? json.decode(usersJson) : [];

      // Check if user exists
      final userData = users.firstWhere(
        (user) => user['email'] == email && user['role'] == role.name,
        orElse: () => null,
      );

      if (userData == null) {
        throw Exception('Utilisateur non trouvé');
      }

      // In real app, verify password with backend
      if (password != 'password123') { // Default demo password
        throw Exception('Mot de passe incorrect');
      }

      final user = UserModel.fromJson(userData);
      _currentUser = user;
      _authToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save to shared preferences
      await prefs.setString(_userKey, json.encode(user.toJson()));
      await prefs.setString(_tokenKey, _authToken!);

      return {
        'success': true,
        'user': user,
        'token': _authToken,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phone,
    String? location,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      final List<dynamic> users = usersJson != null ? json.decode(usersJson) : [];

      // Check if email already exists
      if (users.any((user) => user['email'] == email)) {
        throw Exception('Cet email est déjà utilisé');
      }

      // Create new user
      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: role,
        phone: phone,
        location: location,
        balance: role == UserRole.investor ? 100000.0 : 0.0,
        joinedDate: DateTime.now(),
        profileData: {
          'completedProjects': 0,
          'totalInvested': 0.0,
          'rating': 0.0,
        },
      );

      users.add(newUser.toJson());
      await prefs.setString(_usersKey, json.encode(users));

      // Auto-login after registration
      return await login(email: email, password: password, role: role);
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    
    _currentUser = null;
    _authToken = null;
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson != null) {
      final List<dynamic> users = json.decode(usersJson);
      final userIndex = users.indexWhere((user) => user['id'] == updatedUser.id);
      
      if (userIndex != -1) {
        users[userIndex] = updatedUser.toJson();
        await prefs.setString(_usersKey, json.encode(users));
        _currentUser = updatedUser;
        await prefs.setString(_userKey, json.encode(updatedUser.toJson()));
      }
    }
  }

  // Demo data initialization
  Future<void> initializeDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (prefs.getString(_usersKey) == null) {
      final demoUsers = [
        UserModel(
          id: 'admin_001',
          email: 'admin@agrosense.com',
          name: 'Admin AgroSense',
          role: UserRole.admin,
          balance: 0.0,
          joinedDate: DateTime.now(),
          profileData: {'systemAccess': true},
        ).toJson(),
        UserModel(
          id: 'farmer_001',
          email: 'farmer@agrosense.com',
          name: 'Jean Dupont Agriculteur',
          role: UserRole.farmer,
          phone: '+33 6 12 34 56 78',
          location: 'Normandie, France',
          balance: 0.0,
          joinedDate: DateTime.now(),
          profileData: {
            'farmSize': 50,
            'specialty': 'Céréales',
            'experienceYears': 15,
            'completedProjects': 3,
            'rating': 4.8,
          },
        ).toJson(),
        UserModel(
          id: 'investor_001',
          email: 'investor@agrosense.com',
          name: 'Marie Investisseur',
          role: UserRole.investor,
          phone: '+33 6 98 76 54 32',
          location: 'Paris, France',
          balance: 150000.0,
          joinedDate: DateTime.now(),
          profileData: {
            'investmentFocus': 'Agriculture durable',
            'riskTolerance': 'Modéré',
            'totalInvested': 75000.0,
            'activeInvestments': 2,
            'averageROI': 18.5,
          },
        ).toJson(),
      ];

      await prefs.setString(_usersKey, json.encode(demoUsers));
    }
  }
}