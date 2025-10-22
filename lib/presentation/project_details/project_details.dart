import 'package:agridash/core/app_export.dart';

import 'widgets/index.dart';

class ProjectDetails extends StatefulWidget {
  final ProjectDetailsArgs args;

  const ProjectDetails({
    super.key,
    required this.args,
  });

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> with SingleTickerProviderStateMixin {
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();
  
  late TabController _tabController;
  CropProject? _project;
  bool _isLoading = true;
  bool _isInvesting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProjectDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProjectDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _project = await _projectService.getProjectById(widget.args.projectId);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur lors du chargement du projet: $e');
    }
  }

  Future<void> _handleInvestment(double amount) async {
    if (_project == null) return;

    setState(() {
      _isInvesting = true;
    });

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final result = await _projectService.investInProject(
        projectId: _project!.id,
        investorId: user.id,
        amount: amount,
      );

      setState(() {
        _isInvesting = false;
      });

      if (result['success'] == true) {
        NavigationService().showSuccessDialog('Investissement réalisé avec succès !');
        await _loadProjectDetails(); // Refresh project data
      } else {
        NavigationService().showErrorDialog(result['error'] ?? 'Erreur lors de l\'investissement');
      }
    } catch (e) {
      setState(() {
        _isInvesting = false;
      });
      NavigationService().showErrorDialog('Erreur: $e');
    }
  }

  void _showInvestmentDialog() {
    if (_project == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InvestmentSection(
        project: _project!,
        onInvest: _handleInvestment,
        isInvesting: _isInvesting,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _project == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Projet non trouvé',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => NavigationService().goBack(),
                        child: const Text('Retour'),
                      ),
                    ],
                  ),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 300,
                        floating: false,
                        pinned: true,
                        flexibleSpace: ProjectHeroCarousel(
                          project: _project!,
                          onBack: () => NavigationService().goBack(),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _ProjectHeaderDelegate(
                          project: _project!,
                          tabController: _tabController,
                          onInvest: _showInvestmentDialog,
                        ),
                      ),
                    ];
                  },
                  body: ProjectTabsView(
                    project: _project!,
                    tabController: _tabController,
                    onUpdate: _loadProjectDetails,
                  ),
                ),
    );
  }
}

class _ProjectHeaderDelegate extends SliverPersistentHeaderDelegate {
  final CropProject project;
  final TabController tabController;
  final VoidCallback onInvest;

  _ProjectHeaderDelegate({
    required this.project,
    required this.tabController,
    required this.onInvest,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Project Summary - HAUTEUR PLUS RAISONNABLE
          SizedBox(
            height: 120, // Augmenté à 100px pour plus d'espace
            child: ProjectSummaryCard(project: project),
          ),
          
          // Investment CTA
          if (project.canInvest)
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: AppConstants.primaryColor.withOpacity(0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.rocket_launch,
                    color: AppConstants.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Investissement disponible',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: ElevatedButton(
                      onPressed: onInvest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: const Text(
                        'Investir',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Tabs
          Container(
            height: 48,
            color: Colors.white,
            child: TabBar(
              controller: tabController,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: AppConstants.textColor.withOpacity(0.6),
              indicatorColor: AppConstants.primaryColor,
              tabs: const [
                Tab(text: 'Détails'),
                Tab(text: 'Mises à jour'),
                Tab(text: 'Investisseurs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent {
    if (project.canInvest) {
      return 120 + 32 + 48; // summary (100) + CTA (32) + tabs (48)
    } else {
      return 120 + 48; // summary (100) + tabs (48)
    }
  }

  @override
  double get minExtent {
    return maxExtent;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}