import 'package:agridash/core/index.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // ✅ AJOUTER CET IMPORT


class ProjectService {
  // Singleton
  static final ProjectService _instance = ProjectService._internal();
  factory ProjectService() => _instance;
  ProjectService._internal();

  // Clés de cache local
  static const String _projectsKey = 'crop_projects';
  static const String _investmentsKey = 'crop_investments';

  // Backend
  static const String _backendBaseUrl = 'https://backend-agrosense-hedera.onrender.com/api';
  static const String _apiKey = 'change_this_api_key_to_a_strong_value';
  

  /// --------------------- CACHE LOCAL ---------------------
  Future<void> _saveToCache(String key, List<dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(data));
    } catch (e) {
      print('⚠️ Impossible de mettre en cache $key: $e');
    }
  }

  Future<List<dynamic>> _getFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(key);
      if (jsonData == null) return [];
      return json.decode(jsonData);
    } catch (e) {
      print('⚠️ Erreur lecture cache $key: $e');
      return [];
    }
  }

  /// --------------------- PROJETS ---------------------
  Future<List<CropProject>> getProjects({String? farmerId}) async {
    List<CropProject> projects = [];

    // Lecture cache local
    final cached = await _getFromCache(_projectsKey);
    if (cached.isNotEmpty) {
      projects = cached.map((p) => CropProject.fromJson(p)).toList();
    }

    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/projects'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        projects = data.map((p) => CropProject.fromJson(p)).toList();
        await _saveToCache(_projectsKey, data);
      } else {
        print('❌ Erreur récupération projets backend: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Erreur fetchProjectsFromBackend: $e');
    }

    if (farmerId != null) {
      projects = projects.where((p) => p.farmerId == farmerId).toList();
    }

    return projects;
  }


  Future<CropProject?> getProjectById(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/projects/$projectId'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CropProject.fromJson(data);
      } else {
        print('❌ Impossible de charger le projet: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception getProjectById: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> createProject({
  required String farmerId,
  required String farmerName,
  required String title,
  required String description,
  required CropType cropType,
  required String location,
  required double totalInvestmentNeeded,
  required DateTime startDate,
  required DateTime harvestDate,
  required double estimatedYield,
  required String yieldUnit,
  List<Uint8List>? imageFiles,
}) async {
  try {
    final authService = AuthService();
    final token = authService.token;
    
    if (token == null) {
      return {
        'success': false,
        'error': 'Utilisateur non authentifié. Veuillez vous reconnecter.'
      };
    }

    print('🔐 Token utilisé: ${token.substring(0, 20)}...');
    print('🖼️ Nombre d\'images à envoyer: ${imageFiles?.length ?? 0}');

    final request = http.MultipartRequest(
      'POST', 
      Uri.parse('$_backendBaseUrl/projects')
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-api-key'] = _apiKey;

    request.fields.addAll({
      'farmerId': farmerId,
      'farmerName': farmerName,
      'title': title,
      'description': description,
      'cropType': cropType.name,
      'location': location,
      'totalInvestmentNeeded': totalInvestmentNeeded.toString(),
      'startDate': startDate.toIso8601String(),
      'harvestDate': harvestDate.toIso8601String(),
      'estimatedYield': estimatedYield.toString(),
      'yieldUnit': yieldUnit,
    });

    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (var i = 0; i < imageFiles.length; i++) {
        final imageBytes = imageFiles[i];
        
        // ✅ CORRECTION : Détecter le type MIME de l'image
        final mimeType = _getImageMimeType(imageBytes);
        final extension = _getImageExtension(mimeType);
        
        print('📤 Image $i - Type MIME: $mimeType, Taille: ${imageBytes.length} bytes');

        final multipartFile = http.MultipartFile.fromBytes(
          'images',
          imageBytes,
          filename: 'image_$i$extension',
          contentType: MediaType.parse(mimeType), // ✅ Spécifier le type MIME
        );
        request.files.add(multipartFile);
      }
    } else {
      print('ℹ️ Aucune image à envoyer');
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('📡 Statut réponse création projet: ${response.statusCode}');
    print('📡 Body réponse: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        print('✅ Projet créé avec succès côté backend');
        print('✅ Images enregistrées: ${data['project']?['imageUrls']?.length ?? 0}');
        
        await fetchProjectsFromBackend();

        return {
          'success': true, 
          'project': data['project'],
          'token': data['token']
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Erreur inconnue du backend'
        };
      }
    } else {
      final errorBody = response.body;
      print('❌ Erreur backend détaillée: $errorBody');
      return {
        'success': false,
        'error': 'Erreur backend: ${response.statusCode} - $errorBody'
      };
    }
  } catch (e, st) {
    print('❌ Erreur createProject: $e\n$st');
    return {'success': false, 'error': e.toString()};
  }
}

// ✅ NOUVELLE MÉTHODE : Détecter le type MIME de l'image
String _getImageMimeType(Uint8List imageBytes) {
  // Vérifier les signatures magiques des formats d'image courants
  if (imageBytes.length >= 3 &&
      imageBytes[0] == 0xFF && imageBytes[1] == 0xD8 && imageBytes[2] == 0xFF) {
    return 'image/jpeg';
  }
  
  if (imageBytes.length >= 8 &&
      imageBytes[0] == 0x89 && imageBytes[1] == 0x50 && imageBytes[2] == 0x4E && imageBytes[3] == 0x47 &&
      imageBytes[4] == 0x0D && imageBytes[5] == 0x0A && imageBytes[6] == 0x1A && imageBytes[7] == 0x0A) {
    return 'image/png';
  }
  
  if (imageBytes.length >= 6 &&
      imageBytes[0] == 0x47 && imageBytes[1] == 0x49 && imageBytes[2] == 0x46 &&
      imageBytes[3] == 0x38 && (imageBytes[4] == 0x39 || imageBytes[4] == 0x37) && imageBytes[5] == 0x61) {
    return 'image/gif';
  }
  
  if (imageBytes.length >= 12 &&
      imageBytes[0] == 0x52 && imageBytes[1] == 0x49 && imageBytes[2] == 0x46 && imageBytes[3] == 0x46 &&
      imageBytes[8] == 0x57 && imageBytes[9] == 0x45 && imageBytes[10] == 0x42 && imageBytes[11] == 0x50) {
    return 'image/webp';
  }
  
  // Par défaut, supposer JPEG (le plus courant)
  return 'image/jpeg';
}

// ✅ NOUVELLE MÉTHODE : Obtenir l'extension de fichier
String _getImageExtension(String mimeType) {
  switch (mimeType) {
    case 'image/jpeg':
      return '.jpg';
    case 'image/png':
      return '.png';
    case 'image/gif':
      return '.gif';
    case 'image/webp':
      return '.webp';
    default:
      return '.jpg';
  }
}


  // Méthode alternative pour mobile/desktop avec Multipart (gardée pour référence)
  Future<Map<String, dynamic>> _createProjectWithMultipart({
    required String farmerId,
    required String farmerName,
    required String title,
    required String description,
    required CropType cropType,
    required String location,
    required double totalInvestmentNeeded,
    required DateTime startDate,
    required DateTime harvestDate,
    required double estimatedYield,
    required String yieldUnit,
    List<Uint8List>? imageFiles,
  }) async {
    try {
      final uri = Uri.parse('$_backendBaseUrl/projects');
      
      final request = http.MultipartRequest('POST', uri);

      request.headers['x-api-key'] = _apiKey;

      // Champs texte
      request.fields.addAll({
        'farmerId': farmerId,
        'farmerName': farmerName,
        'title': title,
        'description': description,
        'cropType': cropType.name,
        'location': location,
        'totalInvestmentNeeded': totalInvestmentNeeded.toString(),
        'startDate': startDate.toIso8601String(),
        'harvestDate': harvestDate.toIso8601String(),
        'estimatedYield': estimatedYield.toString(),
        'yieldUnit': yieldUnit,
      });

      // Images en multipart (pour mobile/desktop)
      if (imageFiles != null && imageFiles.isNotEmpty && !kIsWeb) {
        for (var i = 0; i < imageFiles.length; i++) {
          final imageBytes = imageFiles[i];
          final multipartFile = http.MultipartFile.fromBytes(
            'images',
            imageBytes,
            filename: 'image_$i.jpg',
          );
          request.files.add(multipartFile);
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseBody);
        await fetchProjectsFromBackend();
        return {'success': true, 'project': CropProject.fromJson(data)};
      } else {
        return {
          'success': false,
          'error': 'Erreur backend: ${response.statusCode} - $responseBody'
        };
      }
    } catch (e, st) {
      print('❌ Erreur _createProjectWithMultipart: $e\n$st');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addProjectUpdate({
    required String projectId,
    required String title,
    required String description,
    required UpdateType type,
    required List<String> images,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/projects/$projectId/updates'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: json.encode({
          'title': title,
          'description': description,
          'type': type.name,
          'images': images,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await fetchProjectsFromBackend();
        return {'success': true, 'update': data};
      } else {
        return {
          'success': false,
          'error': 'Erreur backend: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> fetchProjectsFromBackend() async {
    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/projects'),
        headers: {'x-api-key': _apiKey},
      );
      if (response.statusCode == 200) {
        final List<dynamic> projects = json.decode(response.body);
        await _saveToCache(_projectsKey, projects);
      }
    } catch (e) {
      print('⚠️ fetchProjectsFromBackend: $e');
    }
  }

  /// --------------------- INVESTISSEMENTS ---------------------
  Future<List<CropInvestment>> getUserInvestments(String userId) async {
    List<CropInvestment> investments = [];

    final cached = await _getFromCache(_investmentsKey);
    if (cached.isNotEmpty) {
      investments = cached.map((i) => CropInvestment.fromJson(i)).toList();
    }

    try {
      final response = await http.get(
        Uri.parse('$_backendBaseUrl/users/$userId/investments'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        investments = data.map((i) => CropInvestment.fromJson(i)).toList();
        await _saveToCache(_investmentsKey, data);
      }
    } catch (e) {
      print('⚠️ fetchInvestmentsFromBackend: $e');
    }

    return investments.where((i) => i.investorId == userId).toList();
  }

  Future<Map<String, dynamic>> investInProject({
  required String projectId,
  required String investorId,
  required double amount,
}) async {
  try {
    final authService = AuthService();
    final token = authService.token;

    if (token == null) {
      return {
        'success': false,
        'error': 'Utilisateur non authentifié. Veuillez vous reconnecter.'
      };
    }
    print('projectId $projectId');
    final response = await http.post(
      Uri.parse('$_backendBaseUrl/investments/$projectId/invest'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'Authorization': 'Bearer $token', // ✅ Utiliser le bon header
      },
      body: json.encode({
        'investorId': investorId,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      await fetchProjectsFromBackend();
      await getUserInvestments(investorId); // mise à jour cache
      return {'success': true, 'investment': data};
    } else {
      final errorBody = response.body;
      return {
        'success': false,
        'error': 'Erreur backend: ${response.statusCode} - $errorBody'
      };
    }
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

}