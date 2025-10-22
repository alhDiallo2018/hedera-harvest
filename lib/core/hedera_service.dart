import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RealHederaService {
  static const String _accountId = '0.0.6915158';
  static const String _apiBase = 'https://testnet.hashio.io/api';

  // Récupérer le solde réel
  Future<double> getRealBalance() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBase/v1/accounts/$_accountId')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final balance = data['balance']?['balance'] ?? 0;
        return double.parse(balance.toString());
      }
    } catch (e) {
      print('❌ Erreur récupération solde réel: $e');
    }
    return 0.0;
  }

  // Récupérer l'historique des transactions
  Future<List<dynamic>> getTransactionHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBase/v1/accounts/$_accountId/transactions')
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body)['transactions'] ?? [];
      }
    } catch (e) {
      print('❌ Erreur historique transactions: $e');
    }
    return [];
  }

  // Vérifier les tokens détenus
  Future<List<dynamic>> getAccountTokens() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBase/v1/accounts/$_accountId/tokens')
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body)['tokens'] ?? [];
      }
    } catch (e) {
      print('❌ Erreur tokens du compte: $e');
    }
    return [];
  }
}

class HederaService {
  static final HederaService _instance = HederaService._internal();
  factory HederaService() => _instance;
  HederaService._internal();

  // Configuration pour la démonstration
  // ignore: unused_field
  static const String _testnetNode = 'https://testnet.hashio.io/api';
  
  // Compte principal de l'application (simulation)
  static const String _appAccountId = '0.0.6915158';
  static const String _appEvmAddress = '0x2120ea5796e96d8ec88967da1488df98ef32f1e1';

  // Comptes de démonstration pour les utilisateurs
  final Map<String, String> _demoAccounts = {
    'farmer_001': '0.0.6915158',
    'investor_001': '0.0.6915159', 
    'investor_002': '0.0.6915160',
  };

  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      // Simulation de l'initialisation avec délai réseau
      await Future.delayed(Duration(milliseconds: 1000));
      _isInitialized = true;
      
      print('✅ AgroSense Hedera Service initialisé');
      print('📱 Compte App: $_appAccountId');
      print('🔗 EVM Address: $_appEvmAddress');
      print('🌐 Network: Hedera Testnet (Simulation)');
      
    } catch (e) {
      print('⚠️ Erreur initialisation: $e');
      _isInitialized = false;
    }
  }

  // Tokeniser une future récolte (simulation réaliste)
  Future<String> tokenizeCrop({
    required String farmerId,
    required String cropType,
    required int quantity,
    required double estimatedValue,
    required DateTime harvestDate,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      // Simulation du délai réseau Hedera
      await Future.delayed(Duration(seconds: 2));
      
      // Génération d'un token ID réaliste format Hedera
      final random = Random();
      final tokenId = '0.0.${6915000 + random.nextInt(2000)}';
      
      // Calcul du prix unitaire
      final tokenPrice = estimatedValue / quantity;

      // Sauvegarder les métadonnées
      await _saveTokenMetadata(
        tokenId,
        farmerId,
        cropType,
        quantity,
        estimatedValue,
        harvestDate,
        tokenPrice,
      );

      print('🌱 Token Hedera créé: $tokenId');
      print('📊 Détails: $quantity $cropType - ${tokenPrice.toStringAsFixed(2)} FCFA/token');
      print('💰 Valeur estimée: ${estimatedValue.toStringAsFixed(0)} FCFA');
      
      return tokenId;
    } catch (e) {
      print('❌ Erreur tokenisation: $e');
      return _generateFallbackTokenId();
    }
  }

  // Acheter des tokens de récolte (simulation réaliste)
  Future<Map<String, dynamic>> purchaseCropTokens({
    required String tokenId,
    required String investorId,
    required int quantity,
    required double amount,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      // Simulation du délai transaction Hedera
      await Future.delayed(Duration(seconds: 1));
      
      // Génération d'un hash de transaction réaliste
      final transactionHash = _generateHederaTransactionHash();
      
      // Enregistrer la transaction
      await _recordInvestment(investorId, tokenId, quantity, amount, transactionHash);

      print('💰 Achat simulé Hedera: $quantity tokens');
      print('📝 Token: $tokenId');
      print('👤 Investisseur: $investorId');
      print('🔗 Transaction: $transactionHash');

      return {
        'transactionHash': transactionHash,
        'status': 'SUCCESS',
        'tokenId': tokenId,
        'quantity': quantity,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
        'network': 'Hedera Testnet',
        'gasUsed': '0.0001',
        'transactionFee': '0.0001',
      };
    } catch (e) {
      print('❌ Erreur achat tokens: $e');
      throw Exception("Erreur lors de l'achat: $e");
    }
  }

  // Distribuer les revenus aux investisseurs
  Future<Map<String, dynamic>> distributeRevenue({
    required String tokenId,
    required double totalRevenue,
    required Map<String, int> investorShares,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      await Future.delayed(Duration(seconds: 1));

      final distributions = <Map<String, dynamic>>[];
      final transactionHash = _generateHederaTransactionHash();

      for (final entry in investorShares.entries) {
        final investorId = entry.key;
        final share = entry.value;
        final amount = (totalRevenue * share / 100);
        
        distributions.add({
          'investorId': investorId,
          'share': share,
          'amount': amount,
          'status': 'DISTRIBUTED',
          'transactionHash': _generateHederaTransactionHash(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        print('📊 Distribution: ${amount.toStringAsFixed(0)} FCFA à $investorId');
      }

      return {
        'transactionHash': transactionHash,
        'status': 'SUCCESS',
        'distributions': distributions,
        'totalDistributed': totalRevenue,
        'timestamp': DateTime.now().toIso8601String(),
        'network': 'Hedera Testnet',
      };
    } catch (e) {
      print('❌ Erreur distribution: $e');
      throw Exception("Erreur lors de la distribution: $e");
    }
  }

  // Obtenir le solde d'un compte (simulation réaliste)
  Future<double> getAccountBalance(String accountId) async {
    try {
      if (!_isInitialized) await initialize();

      await Future.delayed(Duration(milliseconds: 500));
      
      // Simulation de solde réaliste basée sur l'ID du compte
      final random = Random(accountId.hashCode);
      final baseBalance = switch(accountId) {
        '0.0.6915158' => 15000.0, // Compte principal
        '0.0.6915159' => 8000.0,  // Investisseur 1
        '0.0.6915160' => 12000.0, // Investisseur 2
        _ => 5000 + random.nextDouble() * 10000,
      };
      
      return baseBalance;
    } catch (e) {
      print('❌ Erreur récupération solde: $e');
      final random = Random();
      return 5000 + random.nextDouble() * 10000;
    }
  }

  // Obtenir le solde de tokens d'un compte
  Future<int> getTokenBalance(String accountId, String tokenId) async {
    try {
      // Simulation basée sur l'historique d'investissement
      final investments = await getInvestmentHistory(accountId);
      int totalTokens = 0;
      
      for (final investment in investments) {
        if (investment['tokenId'] == tokenId) {
          totalTokens += (investment['quantity'] as int);
        }
      }
      
      return totalTokens;
    } catch (e) {
      print('❌ Erreur solde tokens: $e');
      return 0;
    }
  }

  // Vérifier le statut d'une transaction
  Future<Map<String, dynamic>> getTransactionStatus(String transactionHash) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      
      // Simulation réaliste du statut Hedera
      return {
        'hash': transactionHash,
        'status': 'SUCCESS',
        'timestamp': DateTime.now().toIso8601String(),
        'confirmations': 17,
        'blockNumber': 3298716,
        'gasUsed': '0.0001',
        'transactionFee': '0.0001',
        'memo': 'AgroSense Token Transfer',
      };
    } catch (e) {
      print('❌ Erreur statut transaction: $e');
      return {
        'hash': transactionHash,
        'status': 'UNKNOWN',
        'timestamp': DateTime.now().toIso8601String(),
        'confirmations': 0,
      };
    }
  }

  // Méthodes privées
  Future<void> _saveTokenMetadata(
    String tokenId,
    String farmerId,
    String cropType,
    int quantity,
    double estimatedValue,
    DateTime harvestDate,
    double tokenPrice,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final metadata = {
      'tokenId': tokenId,
      'farmerId': farmerId,
      'cropType': cropType,
      'quantity': quantity,
      'estimatedValue': estimatedValue,
      'harvestDate': harvestDate.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'availableTokens': quantity,
      'totalTokens': quantity,
      'tokenPrice': tokenPrice,
      'status': 'ACTIVE',
      'tokenSymbol': _getTokenSymbol(cropType),
      'tokenName': '$cropType Agricultural Token',
      'network': 'Hedera Testnet',
      'treasuryAccount': _appAccountId,
    };
    
    await prefs.setString('token_$tokenId', json.encode(metadata));
  }

  Future<void> _recordInvestment(
    String investorId,
    String tokenId,
    int quantity,
    double amount,
    String transactionHash,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final investment = {
      'investorId': investorId,
      'tokenId': tokenId,
      'quantity': quantity,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
      'status': 'COMPLETED',
      'transactionHash': transactionHash,
      'network': 'Hedera Testnet',
      'type': 'TOKEN_PURCHASE',
    };
    
    final investments = prefs.getStringList('investments_$investorId') ?? [];
    investments.add(json.encode(investment));
    await prefs.setStringList('investments_$investorId', investments);

    // Mettre à jour les tokens disponibles
    final metadataString = prefs.getString('token_$tokenId');
    if (metadataString != null) {
      final metadata = json.decode(metadataString);
      final currentAvailable = metadata['availableTokens'] ?? metadata['quantity'];
      metadata['availableTokens'] = currentAvailable - quantity;
      await prefs.setString('token_$tokenId', json.encode(metadata));
    }
  }

  String _generateHederaTransactionHash() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(1000000);
    return '$timestamp-$randomPart@${_appAccountId}';
  }

  String _getTokenSymbol(String cropType) {
    final symbols = {
      'maïs': 'MAIZE',
      'riz': 'RICE', 
      'tomate': 'TOMATO',
      'café': 'COFFEE',
      'cacao': 'COCOA',
      'coton': 'COTTON',
      'blé': 'WHEAT',
      'soja': 'SOYBEAN',
    };
    return symbols[cropType.toLowerCase()] ?? 'AGRO';
  }

  String _generateFallbackTokenId() {
    final random = Random();
    return '0.0.${6915000 + random.nextInt(2000)}';
  }

  // Métadonnées des tokens
  Future<Map<String, dynamic>> getTokenMetadata(String tokenId) async {
    final prefs = await SharedPreferences.getInstance();
    final metadataString = prefs.getString('token_$tokenId');
    if (metadataString != null) {
      return json.decode(metadataString);
    }
    return {};
  }

  // Historique des investissements
  Future<List<Map<String, dynamic>>> getInvestmentHistory(String investorId) async {
    final prefs = await SharedPreferences.getInstance();
    final investments = prefs.getStringList('investments_$investorId') ?? [];
    return investments.map((inv) {
      final decoded = json.decode(inv);
      return Map<String, dynamic>.from(decoded);
    }).toList();
  }

  // Tokens disponibles
  Future<List<Map<String, dynamic>>> getAvailableTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('token_')).toList();
    final tokens = <Map<String, dynamic>>[];
    
    for (final key in keys) {
      final metadataString = prefs.getString(key);
      if (metadataString != null) {
        final metadata = json.decode(metadataString);
        final availableTokens = metadata['availableTokens'] ?? 0;
        if (availableTokens > 0) {
          tokens.add(Map<String, dynamic>.from(metadata));
        }
      }
    }
    
    return tokens;
  }

  // Génération de compte démo
  String generateDemoAccount(String type) {
    switch (type) {
      case 'farmer':
        return _demoAccounts['farmer_001']!;
      case 'investor':
        return _demoAccounts['investor_001']!;
      default:
        return _demoAccounts.values.first;
    }
  }

  // Connexion wallet
  Future<Map<String, dynamic>> connectWallet(String accountType) async {
    await Future.delayed(Duration(seconds: 1));
    final accountId = generateDemoAccount(accountType);
    final balance = await getAccountBalance(accountId);
    
    return {
      'accountId': accountId,
      'balance': balance,
      'network': 'Hedera Testnet',
      'status': 'CONNECTED',
      'type': accountType,
      'connectedAt': DateTime.now().toIso8601String(),
      'evmAddress': _appEvmAddress,
    };
  }

  // Déconnexion
  Future<void> disconnectWallet() async {
    await Future.delayed(Duration(milliseconds: 500));
    print('🔒 Wallet déconnecté');
  }

  // Vérifier disponibilité tokens
  Future<bool> isTokenAvailable(String tokenId, int quantity) async {
    final metadata = await getTokenMetadata(tokenId);
    final availableTokens = metadata['availableTokens'] ?? 0;
    return availableTokens >= quantity;
  }

  // Calcul prix total
  Future<double> calculateTotalPrice(String tokenId, int quantity) async {
    final metadata = await getTokenMetadata(tokenId);
    final tokenPrice = metadata['tokenPrice'] ?? 0;
    return tokenPrice * quantity;
  }

  // Utilitaires d'affichage
  String formatTokenId(String tokenId) {
    return tokenId.length > 12 ? '${tokenId.substring(0, 12)}...' : tokenId;
  }

  String formatAmount(double amount) {
    return '${amount.toStringAsFixed(0)} FCFA';
  }

  String formatShortAddress(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }

  // Informations du compte app
  Map<String, dynamic> getAppAccountInfo() {
    return {
      'accountId': _appAccountId,
      'evmAddress': _appEvmAddress,
      'network': 'Hedera Testnet',
      'type': 'Application Treasury',
      'status': 'ACTIVE',
    };
  }

  // Vérifier l'état du service
  bool get isInitialized => _isInitialized;
}