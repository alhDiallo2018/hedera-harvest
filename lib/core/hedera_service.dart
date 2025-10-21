import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class HederaService {
  static final HederaService _instance = HederaService._internal();
  factory HederaService() => _instance;
  HederaService._internal();

  // Configuration simulée pour le hackathon
  static const String _testnetNode = 'https://testnet.hashio.io/api';

  // Comptes de démonstration pour le hackathon
  final Map<String, String> _demoAccounts = {
    'farmer_001': '0.0.123456',
    'investor_001': '0.0.123457',
    'investor_002': '0.0.123458',
  };

  Future<void> initialize() async {
    try {
      // Simulation de l'initialisation pour le hackathon
      await Future.delayed(Duration(milliseconds: 500));
      print('✅ Hedera Service initialisé (Mode Simulation)');
    } catch (e) {
      print('⚠️ Erreur initialisation: $e');
    }
  }

  // Tokeniser une future récolte (simulé)
  Future<String> tokenizeCrop({
    required String farmerId,
    required String cropType,
    required int quantity,
    required double estimatedValue,
    required DateTime harvestDate,
  }) async {
    try {
      // Simulation du délai réseau
      await Future.delayed(Duration(seconds: 2));
      
      // Génération d'un token ID réaliste
      final random = Random();
      final tokenId = '0.0.${1000000 + random.nextInt(9000000)}';
      
      // Sauvegarder les métadonnées
      await _saveTokenMetadata(
        tokenId,
        farmerId,
        cropType,
        quantity,
        estimatedValue,
        harvestDate,
      );

      print('🌱 Token Hedera créé: $tokenId pour $cropType');
      
      return tokenId;
    } catch (e) {
      print('❌ Erreur tokenisation: $e');
      // Fallback vers la simulation
      return _generateFallbackTokenId(cropType);
    }
  }

  // Acheter des tokens de récolte (simulé)
  Future<Map<String, dynamic>> purchaseCropTokens({
    required String tokenId,
    required String investorId,
    required int quantity,
    required double amount,
  }) async {
    try {
      // Simulation pour le hackathon
      await Future.delayed(Duration(seconds: 1));
      
      final transactionHash = '0x${_generateRandomHash()}';
      
      // Enregistrer la transaction
      await _recordInvestment(investorId, tokenId, quantity, amount, transactionHash);

      print('💰 Achat simulé: $quantity tokens de $tokenId');

      return {
        'transactionHash': transactionHash,
        'status': 'success',
        'tokenId': tokenId,
        'quantity': quantity,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception("Erreur lors de l'achat: $e");
    }
  }

  // Distribuer les revenus aux investisseurs (simulé)
  Future<Map<String, dynamic>> distributeRevenue({
    required String tokenId,
    required double totalRevenue,
    required Map<String, int> investorShares,
  }) async {
    try {
      // Simulation pour le hackathon
      await Future.delayed(Duration(seconds: 1));

      final distributions = <Map<String, dynamic>>[];
      final transactionHash = '0x${_generateRandomHash()}';

      for (final entry in investorShares.entries) {
        final investorId = entry.key;
        final share = entry.value;
        final amount = (totalRevenue * share / 100);
        
        distributions.add({
          'investorId': investorId,
          'share': share,
          'amount': amount,
          'status': 'distributed',
        });
        
        print('📊 Distribution simulée: ${amount.toStringAsFixed(0)} FCFA à $investorId');
      }

      return {
        'transactionHash': transactionHash,
        'status': 'success',
        'distributions': distributions,
        'totalDistributed': totalRevenue,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception("Erreur lors de la distribution: $e");
    }
  }

  // Obtenir les métadonnées d'un token
  Future<Map<String, dynamic>> getTokenMetadata(String tokenId) async {
    final prefs = await SharedPreferences.getInstance();
    final metadataString = prefs.getString('token_$tokenId');
    if (metadataString != null) {
      return json.decode(metadataString);
    }
    return {};
  }

  // Obtenir l'historique des investissements
  Future<List<Map<String, dynamic>>> getInvestmentHistory(String investorId) async {
    final prefs = await SharedPreferences.getInstance();
    final investments = prefs.getStringList('investments_$investorId') ?? [];
    return investments.map((inv) => json.decode(inv) as Map<String, dynamic>).toList();
  }

  // Obtenir tous les tokens disponibles
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
          tokens.add(metadata);
        }
      }
    }
    
    return tokens;
  }

  // Générer un compte de démonstration
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

  // Vérifier le solde d'un compte (simulé)
  Future<double> getAccountBalance(String accountId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final random = Random();
    return 5000 + random.nextDouble() * 10000; // Solde simulé entre 5000 et 15000
  }

  // Vérifier le statut d'une transaction (simulé)
  Future<Map<String, dynamic>> getTransactionStatus(String transactionHash) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final random = Random();
    final statuses = ['success', 'pending', 'failed'];
    
    return {
      'hash': transactionHash,
      'status': statuses[random.nextInt(statuses.length)],
      'timestamp': DateTime.now().toIso8601String(),
      'blockNumber': random.nextInt(1000000),
      'confirmations': random.nextInt(10),
    };
  }

  // Méthodes privées
  Future<void> _saveTokenMetadata(
    String tokenId,
    String farmerId,
    String cropType,
    int quantity,
    double estimatedValue,
    DateTime harvestDate,
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
      'tokenPrice': estimatedValue / quantity,
      'status': 'active',
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
      'status': 'completed',
      'transactionHash': transactionHash,
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

  String _generateRandomHash() {
    const chars = '0123456789abcdef';
    final random = Random();
    return List.generate(64, (index) => chars[random.nextInt(chars.length)]).join();
  }

  String _generateFallbackTokenId(String cropType) {
    final random = Random();
    return '0.0.${1000000 + random.nextInt(9000000)}';
  }

  // Méthodes utilitaires pour l'interface
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

  // Simulation de la connexion au wallet
  Future<Map<String, dynamic>> connectWallet(String accountType) async {
    await Future.delayed(Duration(seconds: 2));
    final accountId = generateDemoAccount(accountType);
    final balance = await getAccountBalance(accountId);
    
    return {
      'accountId': accountId,
      'balance': balance,
      'network': 'Hedera Testnet',
      'status': 'connected',
      'type': accountType,
      'connectedAt': DateTime.now().toIso8601String(),
    };
  }

  // Déconnexion du wallet (simulé)
  Future<void> disconnectWallet() async {
    await Future.delayed(Duration(milliseconds: 500));
    print('🔒 Wallet déconnecté');
  }

  // Vérifier si un token est encore disponible
  Future<bool> isTokenAvailable(String tokenId, int quantity) async {
    final metadata = await getTokenMetadata(tokenId);
    final availableTokens = metadata['availableTokens'] ?? 0;
    return availableTokens >= quantity;
  }

  // Obtenir le prix total pour une quantité de tokens
  Future<double> calculateTotalPrice(String tokenId, int quantity) async {
    final metadata = await getTokenMetadata(tokenId);
    final tokenPrice = metadata['tokenPrice'] ?? 0;
    return tokenPrice * quantity;
  }
}