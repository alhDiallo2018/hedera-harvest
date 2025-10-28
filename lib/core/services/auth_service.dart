import 'dart:convert';

import 'package:agridash/core/models/auth_result.dart';
import 'package:agridash/core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _backendBaseUrl = 'https://backend-agrosense-hedera.onrender.com/api';
  static const String _apiKey = 'change_this_api_key_to_a_strong_value';

  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _usersKey = 'registered_users';

  User? _currentUser;
  String? _authToken;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String? get token => _authToken;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    _authToken = prefs.getString(_tokenKey);

    if (userJson != null && _authToken != null) {
      try {
        _currentUser = User.fromJson(json.decode(userJson));
        print('✅ Utilisateur restauré: ${_currentUser?.name}');
        print('✅ Token restauré: ${_authToken?.substring(0, 20)}...');
      } catch (e) {
        print('❌ Erreur restauration utilisateur: $e');
        await logout();
      }
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
    String? location,
  }) async {
    try {
      print('📝 Tentative d\'inscription: $email');

      final response = await http.post(
        Uri.parse('$_backendBaseUrl/auth/register'),
        headers: {
          'x-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role.name,
          'phone': phone,
          'location': location,
        }),
      ).timeout(const Duration(seconds: 50));

      print('📡 Réponse register: ${response.statusCode}');
      print('Body: ${response.body}');

      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        final user = User.fromJson(data['user']);
        final token = data['token'];
        
        // Sauvegarder le token et l'utilisateur
        await _saveAuthData(token, user);
        
        return AuthResult(success: true, user: user, token: token);
      } else {
        return AuthResult(success: false, error: data['error']);
      }
    } catch (e) {
      print('❌ Erreur register: $e');
      return AuthResult(success: false, error: 'Erreur de connexion: $e');
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      print('🔐 Tentative de connexion: $email');

      final response = await http.post(
        Uri.parse('$_backendBaseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json', 
          'x-api-key': _apiKey
        },
        body: json.encode({
          'email': email,
          'password': password,
          'role': role.name,
        }),
      ).timeout(const Duration(seconds: 40));

      print('📡 Réponse login: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          final userData = data['user'];
          final token = data['token'];
          
          if (userData == null || token == null) {
            throw Exception('Données utilisateur ou token manquantes');
          }

          final user = User.fromJson(userData);
          await _saveAuthData(token, user);

          print('✅ Connexion réussie: ${user.name}');
          print('✅ Token JWT reçu: ${token.substring(0, 20)}...');

          return AuthResult(success: true, user: user, token: token);
        } else {
          return AuthResult(success: false, error: data['error'] ?? 'Erreur de connexion');
        }
      } else {
        final errorData = json.decode(response.body);
        return AuthResult(
          success: false, 
          error: errorData['error'] ?? 'Erreur serveur: ${response.statusCode}'
        );
      }
    } catch (e) {
      print('❌ Erreur login: $e');
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    
    _currentUser = null;
    _authToken = null;
    
    print('✅ Déconnexion réussie');
  }

  // Méthode pour sauvegarder les données d'authentification
  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setString(_tokenKey, token);
    
    _currentUser = user;
    _authToken = token;
  }

  // Méthode pour les requêtes authentifiées
  Map<String, String> get authHeaders {
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': _apiKey,
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // Vérifier si l'utilisateur a un rôle spécifique
  bool hasRole(UserRole role) {
    return _currentUser?.role == role;
  }

  // Vérifier si l'utilisateur peut créer des projets
  bool get canCreateProjects => hasRole(UserRole.farmer) || hasRole(UserRole.admin);

  // Vérifier si l'utilisateur peut investir
  bool get canInvest => hasRole(UserRole.investor) || hasRole(UserRole.admin);

  // Demo data initialization (optionnel)
  Future<void> initializeDemoData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (prefs.getString(_usersKey) == null) {
      final demoUsers = [
        User(
          id: 'admin_001',
          email: 'admin@agrosense.com',
          name: 'Admin AgroSense',
          role: UserRole.admin,
          balance: 0.0,
          joinedDate: DateTime.now(),
          profileData: {'systemAccess': true}, 
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now(),
        ).toJson(),
        User(
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
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now(),
        ).toJson(),
        User(
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
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now(),
        ).toJson(),
      ];

      await prefs.setString(_usersKey, json.encode(demoUsers));
    }
  }
}