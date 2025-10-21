import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_row.dart';
import './widgets/filter_modal.dart';
import './widgets/marketplace_header.dart';
import './widgets/project_card.dart';
import './widgets/skeleton_card.dart';
import './widgets/sort_bottom_sheet.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _filteredProjects = [];
  Map<String, dynamic> _currentFilters = {};
  String _currentSort = 'relevance';
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    // Mock data for agricultural investment projects
    _projects = [
      {
        "id": 1,
        "title": "Culture de Maïs Bio - Normandie",
        "cropType": "Maïs",
        "location": "Normandie",
        "image":
            "https://images.unsplash.com/photo-1445724572107-e0b392f39350",
        "semanticLabel":
            "Green corn field with tall stalks under blue sky in rural farming area",
        "fundingProgress": 0.65,
        "expectedROI": "12%",
        "investmentMinimum": "2.500€",
        "duration": "6-12 mois",
        "description":
            "Projet de culture de maïs biologique sur 50 hectares en Normandie avec certification AB.",
        "isFavorite": false,
        "createdAt": DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        "id": 2,
        "title": "Exploitation Viticole - Bourgogne",
        "cropType": "Vigne",
        "location": "Bourgogne-Franche-Comté",
        "image":
            "https://images.unsplash.com/photo-1581727025823-549a48496c72",
        "semanticLabel":
            "Rows of grapevines in vineyard with green leaves during growing season",
        "fundingProgress": 0.45,
        "expectedROI": "18%",
        "investmentMinimum": "5.000€",
        "duration": "1-2 ans",
        "description":
            "Développement d'un vignoble de 25 hectares pour la production de vins de Bourgogne.",
        "isFavorite": true,
        "createdAt": DateTime.now().subtract(const Duration(days: 12)),
      },
      {
        "id": 3,
        "title": "Ferme Maraîchère Bio - Bretagne",
        "cropType": "Légumes",
        "location": "Bretagne",
        "image":
            "https://images.unsplash.com/photo-1569185835836-a9683f3c72a4",
        "semanticLabel":
            "Organic vegetable garden with rows of green leafy vegetables and farming tools",
        "fundingProgress": 0.80,
        "expectedROI": "15%",
        "investmentMinimum": "1.500€",
        "duration": "3-6 mois",
        "description":
            "Production de légumes biologiques diversifiés sur 15 hectares avec vente directe.",
        "isFavorite": false,
        "createdAt": DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        "id": 4,
        "title": "Culture de Tournesol - Occitanie",
        "cropType": "Tournesol",
        "location": "Occitanie",
        "image":
            "https://images.unsplash.com/photo-1569383586020-a55d51a2b4b2",
        "semanticLabel":
            "Field of bright yellow sunflowers facing the sun under clear blue sky",
        "fundingProgress": 0.30,
        "expectedROI": "10%",
        "investmentMinimum": "3.000€",
        "duration": "6-12 mois",
        "description":
            "Plantation de tournesols sur 40 hectares pour la production d'huile végétale.",
        "isFavorite": false,
        "createdAt": DateTime.now().subtract(const Duration(days: 8)),
      },
      {
        "id": 5,
        "title": "Élevage Bovin Bio - Nouvelle-Aquitaine",
        "cropType": "Élevage",
        "location": "Nouvelle-Aquitaine",
        "image":
            "https://images.unsplash.com/photo-1589572149090-76589087982f",
        "semanticLabel":
            "Black and white dairy cows grazing in green pasture with trees in background",
        "fundingProgress": 0.55,
        "expectedROI": "14%",
        "investmentMinimum": "8.000€",
        "duration": "2-5 ans",
        "description":
            "Développement d'un élevage bovin biologique avec 100 têtes de bétail.",
        "isFavorite": true,
        "createdAt": DateTime.now().subtract(const Duration(days: 15)),
      },
      {
        "id": 6,
        "title": "Plantation d'Oliviers - Provence",
        "cropType": "Oliviers",
        "location": "Provence-Alpes-Côte d'Azur",
        "image":
            "https://images.unsplash.com/photo-1691768231776-203e0de0d5fe",
        "semanticLabel":
            "Mediterranean olive grove with mature olive trees and silver-green foliage",
        "fundingProgress": 0.25,
        "expectedROI": "16%",
        "investmentMinimum": "4.000€",
        "duration": "2-5 ans",
        "description":
            "Création d'une oliveraie de 30 hectares pour la production d'huile d'olive premium.",
        "isFavorite": false,
        "createdAt": DateTime.now().subtract(const Duration(days: 20)),
      },
      {
        "id": 7,
        "title": "Culture de Blé Dur - Centre-Val de Loire",
        "cropType": "Blé",
        "location": "Centre-Val de Loire",
        "image":
            "https://images.unsplash.com/photo-1627459258630-d571946266c6",
        "semanticLabel":
            "Golden wheat field ready for harvest with grain heads swaying in the wind",
        "fundingProgress": 0.70,
        "expectedROI": "11%",
        "investmentMinimum": "2.000€",
        "duration": "6-12 mois",
        "description":
            "Production de blé dur sur 60 hectares avec contrats de vente sécurisés.",
        "isFavorite": false,
        "createdAt": DateTime.now().subtract(const Duration(days: 7)),
      },
      {
        "id": 8,
        "title": "Ferme Apicole - Auvergne-Rhône-Alpes",
        "cropType": "Apiculture",
        "location": "Auvergne-Rhône-Alpes",
        "image":
            "https://images.unsplash.com/photo-1657751774799-0701b4f384d0",
        "semanticLabel":
            "Wooden beehives in mountain meadow surrounded by wildflowers and alpine landscape",
        "fundingProgress": 0.40,
        "expectedROI": "20%",
        "investmentMinimum": "1.200€",
        "duration": "1-2 ans",
        "description":
            "Développement d'une exploitation apicole avec 200 ruches en montagne.",
        "isFavorite": true,
        "createdAt": DateTime.now().subtract(const Duration(days: 10)),
      },
    ];

    _filteredProjects = List.from(_projects);

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProjects();
    }
  }

  void _loadMoreProjects() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more projects
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage++;
        });
      }
    });
  }

  void _onSearchChanged() {
    _filterProjects();
  }

  void _filterProjects() {
    setState(() {
      _filteredProjects = _projects.where((project) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            (project['title'] as String).toLowerCase().contains(searchQuery) ||
            (project['cropType'] as String)
                .toLowerCase()
                .contains(searchQuery) ||
            (project['location'] as String).toLowerCase().contains(searchQuery);

        if (!matchesSearch) return false;

        // Crop type filter
        final cropTypes = _currentFilters['cropTypes'] as List<String>?;
        if (cropTypes != null && cropTypes.isNotEmpty) {
          if (!cropTypes.contains(project['cropType'])) return false;
        }

        // Location filter
        final locations = _currentFilters['locations'] as List<String>?;
        if (locations != null && locations.isNotEmpty) {
          if (!locations.contains(project['location'])) return false;
        }

        // Investment range filter
        final minInvestment = _currentFilters['minInvestment'] as double?;
        final maxInvestment = _currentFilters['maxInvestment'] as double?;
        if (minInvestment != null || maxInvestment != null) {
          final projectMinimum = double.tryParse(
                  (project['investmentMinimum'] as String)
                      .replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;

          if (minInvestment != null && projectMinimum < minInvestment)
            return false;
          if (maxInvestment != null && projectMinimum > maxInvestment)
            return false;
        }

        // Duration filter
        final durations = _currentFilters['durations'] as List<String>?;
        if (durations != null && durations.isNotEmpty) {
          if (!durations.contains(project['duration'])) return false;
        }

        // ROI filter
        final minROI = _currentFilters['minROI'] as double?;
        final maxROI = _currentFilters['maxROI'] as double?;
        if (minROI != null || maxROI != null) {
          final projectROI = double.tryParse(
                  (project['expectedROI'] as String).replaceAll('%', '')) ??
              0.0;

          if (minROI != null && projectROI < minROI) return false;
          if (maxROI != null && projectROI > maxROI) return false;
        }

        return true;
      }).toList();

      _sortProjects();
    });
  }

  void _sortProjects() {
    switch (_currentSort) {
      case 'roi':
        _filteredProjects.sort((a, b) {
          final roiA = double.tryParse(
                  (a['expectedROI'] as String).replaceAll('%', '')) ??
              0.0;
          final roiB = double.tryParse(
                  (b['expectedROI'] as String).replaceAll('%', '')) ??
              0.0;
          return roiA.compareTo(roiB);
        });
        break;
      case 'roi_desc':
        _filteredProjects.sort((a, b) {
          final roiA = double.tryParse(
                  (a['expectedROI'] as String).replaceAll('%', '')) ??
              0.0;
          final roiB = double.tryParse(
                  (b['expectedROI'] as String).replaceAll('%', '')) ??
              0.0;
          return roiB.compareTo(roiA);
        });
        break;
      case 'amount':
        _filteredProjects.sort((a, b) {
          final amountA = double.tryParse((a['investmentMinimum'] as String)
                  .replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          final amountB = double.tryParse((b['investmentMinimum'] as String)
                  .replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          return amountA.compareTo(amountB);
        });
        break;
      case 'amount_desc':
        _filteredProjects.sort((a, b) {
          final amountA = double.tryParse((a['investmentMinimum'] as String)
                  .replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          final amountB = double.tryParse((b['investmentMinimum'] as String)
                  .replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
          return amountB.compareTo(amountA);
        });
        break;
      case 'date':
        _filteredProjects.sort((a, b) =>
            (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
        break;
      case 'date_desc':
        _filteredProjects.sort((a, b) =>
            (a['createdAt'] as DateTime).compareTo(b['createdAt'] as DateTime));
        break;
      default: // relevance
        _filteredProjects.sort((a, b) => (b['fundingProgress'] as double)
            .compareTo(a['fundingProgress'] as double));
        break;
    }
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModal(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _filterProjects();
        },
      ),
    );
  }

  void _onSortPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _filterProjects();
        },
      ),
    );
  }

  void _onProjectTap(Map<String, dynamic> project) {
    Navigator.pushNamed(
      context,
      '/project-details',
      arguments: project,
    );
  }

  void _onFavoriteToggle(Map<String, dynamic> project) {
    setState(() {
      project['isFavorite'] = !(project['isFavorite'] ?? false);
    });

    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: project['isFavorite'] ? 'Ajouté aux favoris' : 'Retiré des favoris',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onShare(Map<String, dynamic> project) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: 'Partage du projet: ${project['title']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onContact(Map<String, dynamic> project) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: 'Contact agriculteur pour: ${project['title']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onClearFilters() {
    setState(() {
      _currentFilters.clear();
      _searchController.clear();
    });
    _filterProjects();
  }

  List<String> _getActiveFilterLabels() {
    List<String> labels = [];

    final cropTypes = _currentFilters['cropTypes'] as List<String>?;
    if (cropTypes != null && cropTypes.isNotEmpty) {
      labels.addAll(cropTypes);
    }

    final locations = _currentFilters['locations'] as List<String>?;
    if (locations != null && locations.isNotEmpty) {
      labels.addAll(locations);
    }

    final durations = _currentFilters['durations'] as List<String>?;
    if (durations != null && durations.isNotEmpty) {
      labels.addAll(durations);
    }

    final minInvestment = _currentFilters['minInvestment'] as double?;
    final maxInvestment = _currentFilters['maxInvestment'] as double?;
    if (minInvestment != null || maxInvestment != null) {
      labels.add(
          '${minInvestment?.toInt() ?? 0}€ - ${maxInvestment?.toInt() ?? 0}€');
    }

    final minROI = _currentFilters['minROI'] as double?;
    final maxROI = _currentFilters['maxROI'] as double?;
    if (minROI != null || maxROI != null) {
      labels.add('ROI: ${minROI?.toInt() ?? 0}% - ${maxROI?.toInt() ?? 0}%');
    }

    return labels;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _currentPage = 1;
      });
      _filterProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            MarketplaceHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onFilterPressed: _onFilterPressed,
              onSortPressed: _onSortPressed,
            ),

            // Filter chips
            FilterChipsRow(
              activeFilters: _getActiveFilterLabels(),
              onClearFilters: _onClearFilters,
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) => const SkeletonCard(),
                    )
                  : _filteredProjects.isEmpty
                      ? EmptyStateWidget(onClearFilters: _onClearFilters)
                      : RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _filteredProjects.length +
                                (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _filteredProjects.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final project = _filteredProjects[index];
                              return ProjectCard(
                                project: project,
                                onTap: () => _onProjectTap(project),
                                onFavoriteToggle: () =>
                                    _onFavoriteToggle(project),
                                onShare: () => _onShare(project),
                                onContact: () => _onContact(project),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
