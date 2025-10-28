import 'dart:convert';

import 'package:http/http.dart' as http;

class HederaBackendService {
  static final HederaBackendService _instance = HederaBackendService._internal();
  factory HederaBackendService() => _instance;
  HederaBackendService._internal();

  // ⚡ URL de ton backend
  static const String _backendBaseUrl = 'http://localhost:3000/api';
  static const String _apiKey = 'change_this_api_key_to_a_strong_value';

  bool _isInitialized = false;

  // 🔄 INITIALISATION DU SERVICE
  Future<void> initialize() async {
    print('🔄 Initialisation du service backend Hedera...');
    _isInitialized = true;
    // Tu peux ajouter ici la récupération des comptes ou statistiques initiales
  }

  bool get isInitialized => _isInitialized;

  // 🌱 CRÉATION D’UN TOKEN AGRICOLE VIA LE BACKEND
  Future<String?> createToken({
    required String tokenName,
    required String tokenSymbol,
    required int initialSupply,
    int decimals = 0,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/token/create'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: json.encode({
          'tokenName': tokenName,
          'tokenSymbol': tokenSymbol,
          'initialSupply': initialSupply,
          'decimals': decimals,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Token créé via backend: ${data['tokenId']}');
        return data['tokenId'] as String?;
      } else {
        print('❌ Erreur backend lors de la création de token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception création token: $e');
      return null;
    }
  }

  // 💸 EXECUTER UN INVESTISSEMENT VIA LE BACKEND
  Future<Map<String, dynamic>> executeInvestment({
    required String tokenId,
    required String investorId,
    required int quantity,
    required double amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/investment/execute'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: json.encode({
          'tokenId': tokenId,
          'investorId': investorId,
          'quantity': quantity,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Investissement exécuté: ${data['transactionHash']}');
        return data;
      } else {
        print('❌ Erreur backend investissement: ${response.statusCode}');
        return {'success': false};
      }
    } catch (e) {
      print('❌ Exception investissement: $e');
      return {'success': false};
    }
  }

  // 💰 DISTRIBUTION DE REVENUS VIA LE BACKEND
  Future<Map<String, dynamic>> distributeRevenue({
    required String tokenId,
    required double totalRevenue,
    required Map<String, int> investorShares,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/revenue/distribute'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: json.encode({
          'tokenId': tokenId,
          'totalRevenue': totalRevenue,
          'investorShares': investorShares,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Revenus distribués pour le token $tokenId');
        return data;
      } else {
        print('❌ Erreur backend distribution: ${response.statusCode}');
        return {'success': false};
      }
    } catch (e) {
      print('❌ Exception distribution: $e');
      return {'success': false};
    }
  }

  // 📊 RÉCUPÉRER LES DONNÉES DU DASHBOARD VIA LE BACKEND
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/dashboard'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Dashboard récupéré');
        return data;
      } else {
        print('❌ Erreur récupération dashboard: ${response.statusCode}');
        return {'success': false};
      }
    } catch (e) {
      print('❌ Exception dashboard: $e');
      return {'success': false};
    }
  }

  // 🪙 RÉCUPÉRER LES MÉTADONNÉES D’UN TOKEN
  Future<Map<String, dynamic>> getTokenMetadata(String tokenId) async {
    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/token/$tokenId'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('❌ Exception getTokenMetadata: $e');
    }
    return {};
  }

  // 👤 RÉCUPÉRER LES INFOS D’UN COMPTE
  Future<Map<String, dynamic>> getAccountInfo(String accountId) async {
    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/account/$accountId'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('❌ Exception getAccountInfo: $e');
    }
    return {};
  }
}
