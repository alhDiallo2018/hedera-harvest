import 'package:agridash/core/app_export.dart';

class CropDetailView extends StatefulWidget {
  final CropDetailArgs args;

  const CropDetailView({
    super.key,
    required this.args,
  });

  @override
  State<CropDetailView> createState() => _CropDetailViewState();
}

class _CropDetailViewState extends State<CropDetailView> {
  final ProjectService _projectService = ProjectService();
  
  CropProject? _project;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCropDetails();
  }

  Future<void> _loadCropDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.args.projectId != null) {
        _project = await _projectService.getProjectById(widget.args.projectId!);
      }
      // If no project ID, we could load crop information from another source
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur lors du chargement des détails: $e');
    }
  }

  Map<String, dynamic> _getCropInfo(String cropId) {
    // Demo crop information
    final cropData = {
      'maize': {
        'name': 'Maïs',
        'scientificName': 'Zea mays',
        'family': 'Poaceae',
        'season': 'Printemps',
        'duration': '90-120 jours',
        'climate': 'Tropical à tempéré',
        'soil': 'Sol bien drainé, riche en matière organique',
        'water': 'Modérée à élevée',
        'description': 'Le maïs est une céréale largement cultivée pour ses grains riches en amidon. C\'est une culture de base dans de nombreuses régions du monde.',
        'bestPractices': [
          'Rotation des cultures pour prévenir les maladies',
          'Fertilisation équilibrée en NPK',
          'Contrôle des mauvaises herbes',
          'Irrigation régulière pendant la floraison'
        ],
        'challenges': [
          'Sensibilité à la sécheresse',
          'Ravageurs comme la pyrale du maïs',
          'Maladies fongiques',
          'Concurrence des mauvaises herbes'
        ],
        'marketValue': 'Élevée - culture de base',
        'image': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
      },
      'rice': {
        'name': 'Riz',
        'scientificName': 'Oryza sativa',
        'family': 'Poaceae',
        'season': 'Saison des pluies',
        'duration': '100-150 jours',
        'climate': 'Tropical et subtropical',
        'soil': 'Sol argileux, capacité de rétention d\'eau',
        'water': 'Très élevée (culture inondée)',
        'description': 'Le riz est la céréale la plus consommée au monde, particulièrement en Asie. Il nécessite des conditions spécifiques de culture.',
        'bestPractices': [
          'Préparation soignée des rizières',
          'Gestion précise de l\'eau',
          'Utilisation de variétés adaptées',
          'Contrôle des adventices aquatiques'
        ],
        'challenges': [
          'Besoins en eau importants',
          'Sensibilité aux maladies',
          'Coûts de production élevés',
          'Impact environnemental'
        ],
        'marketValue': 'Très élevée - aliment de base',
        'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=800',
      },
      // Add more crops as needed
    };

    return cropData[cropId] ?? {
      'name': 'Culture',
      'scientificName': 'Non spécifié',
      'family': 'Non spécifié',
      'season': 'Variable',
      'duration': 'Variable',
      'climate': 'Variable',
      'soil': 'Variable',
      'water': 'Variable',
      'description': 'Informations non disponibles pour cette culture.',
      'bestPractices': [],
      'challenges': [],
      'marketValue': 'Variable',
      'image': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cropInfo = _getCropInfo(widget.args.cropId);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header with Image
                SliverAppBar(
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      cropInfo['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => NavigationService().goBack(),
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          cropInfo['name'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Scientific Name
                        Text(
                          cropInfo['scientificName'],
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppConstants.textColor.withOpacity(0.6),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Quick Facts
                        _buildQuickFacts(cropInfo),
                        
                        const SizedBox(height: 24),
                        
                        // Description
                        _buildSection(
                          'Description',
                          cropInfo['description'],
                          Icons.description,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Best Practices
                        if (cropInfo['bestPractices'].isNotEmpty)
                          _buildListSection(
                            'Pratiques Recommandées',
                            cropInfo['bestPractices'],
                            Icons.thumb_up,
                            AppConstants.successColor,
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Challenges
                        if (cropInfo['challenges'].isNotEmpty)
                          _buildListSection(
                            'Défis et Considérations',
                            cropInfo['challenges'],
                            Icons.warning,
                            AppConstants.warningColor,
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Market Info
                        _buildMarketInfo(cropInfo),
                        
                        const SizedBox(height: 32),
                        
                        // Related Projects (if any)
                        if (_project != null) _buildRelatedProjects(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuickFacts(Map<String, dynamic> cropInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildFactItem('Famille', cropInfo['family'], Icons.category),
              _buildFactItem('Saison', cropInfo['season'], Icons.calendar_today),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFactItem('Durée', cropInfo['duration'], Icons.schedule),
              _buildFactItem('Climat', cropInfo['climate'], Icons.wb_sunny),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFactItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppConstants.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<dynamic> items, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _buildListItem(item, color)).toList(),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textColor.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInfo(Map<String, dynamic> cropInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: AppConstants.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Valeur Marchande',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppConstants.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Potentiel de marché: ${cropInfo['marketValue']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Demande stable avec bon potentiel de retour sur investissement',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProjects() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projets Associés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.eco,
                color: AppConstants.primaryColor,
                size: 24,
              ),
            ),
            title: Text(
              _project!.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
            subtitle: Text(
              '${_project!.progressPercentage.toStringAsFixed(0)}% financé • ${_project!.currentInvestment.toStringAsFixed(0)} FCFA',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textColor.withOpacity(0.6),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppConstants.textColor.withOpacity(0.5),
            ),
            onTap: () => NavigationService().toProjectDetails(_project!.id),
          ),
        ],
      ),
    );
  }
}