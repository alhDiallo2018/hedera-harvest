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
  
  // Filtres
  String _selectedCategory = 'Tous';
  String _selectedSort = 'Nouveautés';
  double _minInvestment = 0;
  double _maxInvestment = 100000;
  double _minROI = 0;
  double _maxROI = 50;

  final List<String> _categories = ['Tous', 'Maïs', 'Riz', 'Tomate', 'Café', 'Cacao', 'Coton', 'Blé', 'Soja'];
  final List<String> _sortOptions = ['Nouveautés', 'ROI Élevé', 'Financement Urgent', 'Proche de la Récolte'];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _projects = await _projectService.getAvailableProjects();
      _applyFilters();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur lors du chargement des projets: $e');
    }
  }

  void _applyFilters() {
    List<CropProject> filtered = List.from(_projects);

    // Filtre par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((project) {
        return project.cropType.name.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // Filtre par investissement
    filtered = filtered.where((project) {
      return project.tokenPrice >= _minInvestment && project.tokenPrice <= _maxInvestment;
    }).toList();

    // Filtre par ROI
    filtered = filtered.where((project) {
      return project.estimatedROI >= _minROI && project.estimatedROI <= _maxROI;
    }).toList();

    // Tri
    switch (_selectedSort) {
      case 'ROI Élevé':
        filtered.sort((a, b) => b.estimatedROI.compareTo(a.estimatedROI));
        break;
      case 'Financement Urgent':
        filtered.sort((a, b) => a.progressPercentage.compareTo(b.progressPercentage));
        break;
      case 'Proche de la Récolte':
        filtered.sort((a, b) => a.daysToHarvest.compareTo(b.daysToHarvest));
        break;
      default: // Nouveautés
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    setState(() {
      _filteredProjects = filtered;
    });
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
    NavigationService().toProjectDetails(project.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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

                // Projects Grid
                Expanded(
                  child: _filteredProjects.isEmpty
                      ? EmptyStateWidget(
                          title: 'Aucun projet trouvé',
                          message: 'Ajustez vos filtres pour voir plus de projets d\'investissement',
                          onRetry: _loadProjects,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadProjects,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredProjects.length,
                            itemBuilder: (context, index) {
                              return ProjectCard(
                                project: _filteredProjects[index],
                                onTap: () => _handleProjectTap(_filteredProjects[index]),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}