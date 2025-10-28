import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _backendBaseUrl = 'http://localhost:3000/api';
  static const String _apiKey = 'change_this_api_key_to_a_strong_value';

  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _usersKey = 'registered_users';

  UserModel? _currentUser;
  String? _authToken;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String? get token => _authToken;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    _authToken = prefs.getString(_tokenKey);

    if (userJson != null && _authToken != null) {
      try {
        _currentUser = UserModel.fromJson(json.decode(userJson));
        print('✅ Utilisateur restauré: ${_currentUser?.name}');
        print('✅ Token restauré: ${_authToken?.substring(0, 20)}...');
      } catch (e) {
        print('❌ Erreur restauration utilisateur: $e');
        await logout();
      }
    }
  }

  // VRAI LOGIN AVEC BACKEND
  Future<Map<String, dynamic>> login({
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
      ).timeout(const Duration(seconds: 10));

      print('📡 Réponse login: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // ✅ CORRECTION : Extraire correctement le token JWT
          final userData = data['user'];
          final token = data['token'];
          
          if (userData == null || token == null) {
            throw Exception('Données utilisateur ou token manquantes');
          }

          // Créer l'utilisateur avec les données du backend
          final user = UserModel.fromJson(userData);
          
          _currentUser = user;
          _authToken = token;

          // ✅ CORRECTION : Sauvegarder avec le token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userKey, json.encode(user.toJson()));
          await prefs.setString(_tokenKey, _authToken!);

          print('✅ Connexion réussie: ${user.name}');
          print('✅ Token JWT reçu: ${token.substring(0, 20)}...');

          return {
            'success': true,
            'user': user,
            'token': token,
          };
        } else {
          throw Exception(data['error'] ?? 'Erreur de connexion');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur login: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }


  // VRAI REGISTER AVEC BACKEND
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phone,
    String? location,
  }) async {
    try {
      print('📝 Tentative d\'inscription: $email');

      final response = await http.post(
        Uri.parse('$_backendBaseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'role': role.name,
          'phone': phone,
          'location': location,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 Réponse register: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Auto-login après inscription
          return await login(email: email, password: password, role: role);
        } else {
          throw Exception(data['error'] ?? 'Erreur d\'inscription');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Erreur serveur');
      }
    } catch (e) {
      print('❌ Erreur register: $e');
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
    
    print('✅ Déconnexion réussie');
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