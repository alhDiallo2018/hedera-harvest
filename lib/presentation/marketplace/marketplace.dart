import 'package:agridash/core/app_export.dart';

import 'widgets/index.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  final ProjectService _projectService = ProjectService();
  
  List<CropProject> _projects = [];
  List<CropProject> _filteredProjects = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // CORRECTION: Plages de ROI élargies pour inclure les valeurs négatives
  String _selectedCategory = 'Tous';
  String _selectedSort = 'Nouveautés';
  double _minInvestment = 0;
  double _maxInvestment = 1000000;
  double _minROI = -100; // Permet les ROI négatifs
  double _maxROI = 100;

  final List<String> _categories = ['Tous', 'Maïs', 'Riz', 'Tomate', 'Café', 'Cacao', 'Coton', 'Blé', 'Soja', 'Autre'];
  final List<String> _sortOptions = ['Nouveautés', 'ROI Élevé', 'Financement Urgent', 'Proche de la Récolte', 'Plus Populaires'];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('🔄 Chargement des projets depuis le marketplace...');
      _projects = await _projectService.getProjects();
      print('✅ ${_projects.length} projets chargés avec succès');
      
      // CORRECTION: Calcul manuel du ROI pour debug
      for (var project in _projects) {
        final calculatedROI = _calculateROI(project);
        print('📋 Projet: ${project.title}');
        print('   - ROI calculé: ${calculatedROI.toStringAsFixed(1)}%');
        print('   - Investissement: ${project.currentInvestment} / ${project.totalInvestmentNeeded}');
        print('   - Retours estimés: ${project.estimatedReturns}');
        print('   - Catégorie: ${project.cropType}');
        print('   - Statut: ${project.status}');
      }
      
      _applyFilters();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur chargement projets: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement des projets: $e';
      });
      NavigationService().showErrorDialog('Erreur lors du chargement des projets: $e');
    }
  }

  // CORRECTION: Méthode de calcul de ROI de secours
  double _calculateROI(CropProject project) {
    if (project.totalInvestmentNeeded <= 0) return 0.0;
    
    // Si estimatedReturns n'est pas défini, utiliser une estimation basée sur l'investissement
    final returns = project.estimatedReturns > 0 
        ? project.estimatedReturns 
        : project.totalInvestmentNeeded * 1.25; // 25% de retour par défaut
    
    final netReturns = returns - project.totalInvestmentNeeded;
    return (netReturns / project.totalInvestmentNeeded) * 100;
  }

  void _applyFilters() {
    List<CropProject> filtered = List.from(_projects);

    print('🔍 Application des filtres sur ${filtered.length} projets');
    print('   - Catégorie: $_selectedCategory');
    print('   - Investissement: $_minInvestment - $_maxInvestment');
    print('   - ROI: $_minROI - $_maxROI');

    // Filtre par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((project) {
        final cropTypeName = _getCropTypeDisplayName(project.cropType);
        return cropTypeName.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // Filtre par investissement minimum (prix du token)
    filtered = filtered.where((project) {
      return project.tokenPrice >= _minInvestment && project.tokenPrice <= _maxInvestment;
    }).toList();

    // Filtre par ROI - CORRECTION: Utiliser le ROI calculé
    filtered = filtered.where((project) {
      final projectROI = _calculateROI(project);
      final matches = projectROI >= _minROI && projectROI <= _maxROI;
      if (!matches) {
        print('   ❌ Filtre ROI: ${project.title} (${projectROI.toStringAsFixed(1)}%) hors plage $_minROI-$_maxROI');
      }
      return matches;
    }).toList();

    // CORRECTION: Tri avec ROI calculé
    switch (_selectedSort) {
      case 'ROI Élevé':
        filtered.sort((a, b) => _calculateROI(b).compareTo(_calculateROI(a)));
        break;
      case 'Financement Urgent':
        filtered.sort((a, b) => a.progressPercentage.compareTo(b.progressPercentage));
        break;
      case 'Proche de la Récolte':
        filtered.sort((a, b) => a.daysToHarvest.compareTo(b.daysToHarvest));
        break;
      case 'Plus Populaires':
        filtered.sort((a, b) => b.currentInvestment.compareTo(a.currentInvestment));
        break;
      default: // Nouveautés
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    print('✅ ${filtered.length} projets après filtrage');

    setState(() {
      _filteredProjects = filtered;
    });
  }

  String _getCropTypeDisplayName(CropType cropType) {
    switch (cropType) {
      case CropType.maize:
        return 'Maïs';
      case CropType.rice:
        return 'Riz';
      case CropType.tomato:
        return 'Tomate';
      case CropType.coffee:
        return 'Café';
      case CropType.cocoa:
        return 'Cacao';
      case CropType.cotton:
        return 'Coton';
      case CropType.wheat:
        return 'Blé';
      case CropType.soybean:
        return 'Soja';
      case CropType.other:
        return 'Autre';
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModal(
        selectedCategory: _selectedCategory,
        categories: _categories,
        minInvestment: _minInvestment,
        maxInvestment: _maxInvestment,
        minROI: _minROI,
        maxROI: _maxROI,
        onFiltersChanged: (category, minInvest, maxInvest, minRoi, maxRoi) {
          setState(() {
            _selectedCategory = category;
            _minInvestment = minInvest;
            _maxInvestment = maxInvest;
            _minROI = minRoi;
            _maxROI = maxRoi;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SortBottomSheet(
        sortOptions: _sortOptions,
        selectedSort: _selectedSort,
        onSortSelected: (sort) {
          setState(() {
            _selectedSort = sort;
          });
          _applyFilters();
          NavigationService().goBack();
        },
      ),
    );
  }

  void _handleProjectTap(CropProject project) {
    print('🎯 Navigation vers les détails du projet: ${project.id}');
    NavigationService().toProjectDetails(project.id);
  }

  Future<void> _handleRefresh() async {
    await _loadProjects();
  }

  void _resetAllFilters() {
    setState(() {
      _selectedCategory = 'Tous';
      _minInvestment = 0;
      _maxInvestment = 1000000;
      _minROI = -100; // CORRECTION: Reset à -100
      _maxROI = 100;
      _selectedSort = 'Nouveautés';
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : Column(
                  children: [
                    // Header
                    MarketplaceHeader(
                      projectCount: _filteredProjects.length,
                      onFilterTap: _showFilterModal,
                      onSortTap: _showSortModal,
                    ),

                    // Filter Chips
                    FilterChipsRow(
                      selectedCategory: _selectedCategory,
                      categories: _categories,
                      onCategoryChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _applyFilters();
                      },
                    ),

                    // Bouton de réinitialisation si pas de résultats
                    if (_filteredProjects.isEmpty && _projects.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Aucun projet ne correspond aux filtres actuels',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppConstants.textColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _resetAllFilters,
                              child: const Text('Tout afficher'),
                            ),
                          ],
                        ),
                      ),

                    // Projects List
                    Expanded(
                      child: _filteredProjects.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _handleRefresh,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredProjects.length,
                                itemBuilder: (context, index) {
                                  final project = _filteredProjects[index];
                                  return ProjectCard(
                                    project: project,
                                    // CORRECTION: Passer le ROI calculé
                                    calculatedROI: _calculateROI(project),
                                    onTap: () => _handleProjectTap(project),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
  
Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProjects,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                _projects.isEmpty ? 'Aucun projet disponible' : 'Aucun projet trouvé',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  _projects.isEmpty
                      ? 'Aucun projet n\'est disponible pour le moment. Revenez plus tard.'
                      : 'Ajustez vos filtres pour voir plus de projets d\'investissement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_projects.isEmpty)
                ElevatedButton(
                  onPressed: _loadProjects,
                  child: const Text('Actualiser'),
                )
              else
                ElevatedButton(
                  onPressed: _resetAllFilters,
                  child: const Text('Afficher tous les projets'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
