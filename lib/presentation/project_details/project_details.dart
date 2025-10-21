import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/investment_section.dart';
import './widgets/project_hero_carousel.dart';
import './widgets/project_summary_card.dart';
import './widgets/project_tabs_view.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key, Object? projectData});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  bool _isBookmarked = false;
  bool _isInvestor = true; // This would be determined by user role

  // Mock project data
  final Map<String, dynamic> _projectData = {
    'id': 1,
    'name': 'Culture de Maïs Bio - Région Centre',
    'cropType': 'Maïs Biologique',
    'location': 'Beauce, Centre-Val de Loire',
    'fundingGoal': 25000.0,
    'currentFunding': 18750.0,
    'startDate': '15 Mars 2024',
    'harvestDate': '20 Septembre 2024',
    'expectedReturn': 12.5,
    'riskLevel': 'Modéré',
    'farmerName': 'Pierre Dubois',
    'farmerExperience': 15,
    'farmerAvatar':
        'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'farmerAvatarLabel':
        'Portrait of a middle-aged farmer with a straw hat and plaid shirt standing in a corn field',
    'description':
        '''Ce projet vise à cultiver 10 hectares de maïs biologique dans la région de Beauce, reconnue pour ses terres fertiles. 
    
Notre approche combine techniques traditionnelles et innovations durables pour produire un maïs de qualité supérieure, destiné à l'alimentation animale biologique et à la transformation alimentaire.

Le projet s'inscrit dans une démarche de transition écologique, avec l'utilisation exclusive d'engrais naturels et de méthodes de lutte biologique contre les ravageurs.''',
    'images': [
      'https://images.pexels.com/photos/2132250/pexels-photo-2132250.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1595104/pexels-photo-1595104.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1595108/pexels-photo-1595108.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ],
    'imageLabels': [
      'Vast green corn field with tall stalks under blue sky with white clouds',
      'Close-up view of corn ears growing on stalks with green husks in agricultural field',
      'Farmer inspecting corn plants in field during golden hour with warm sunlight',
    ],
    'financialBreakdown': {
      'totalInvestors': 23,
      'duration': 8,
      'costBreakdown': [
        {
          'category': 'Semences biologiques',
          'amount': 8000,
          'percentage': 32,
          'color': 0xFF2E7D32,
        },
        {
          'category': 'Préparation du sol',
          'amount': 6000,
          'percentage': 24,
          'color': 0xFFFF8F00,
        },
        {
          'category': 'Irrigation et équipement',
          'amount': 5500,
          'percentage': 22,
          'color': 0xFF1976D2,
        },
        {
          'category': 'Main d\'œuvre',
          'amount': 3500,
          'percentage': 14,
          'color': 0xFF66BB6A,
        },
        {
          'category': 'Certification bio',
          'amount': 2000,
          'percentage': 8,
          'color': 0xFFFB8C00,
        },
      ],
    },
    'cultivationDetails': {
      'schedule': [
        {
          'phase': 'Préparation du sol',
          'period': '1-15 Mars 2024',
          'icon': 'agriculture',
        },
        {
          'phase': 'Semis',
          'period': '15-30 Mars 2024',
          'icon': 'scatter_plot',
        },
        {
          'phase': 'Croissance végétative',
          'period': 'Avril - Juin 2024',
          'icon': 'eco',
        },
        {
          'phase': 'Floraison',
          'period': 'Juillet 2024',
          'icon': 'local_florist',
        },
        {
          'phase': 'Formation des épis',
          'period': 'Août 2024',
          'icon': 'grain',
        },
        {
          'phase': 'Récolte',
          'period': '15-30 Septembre 2024',
          'icon': 'agriculture',
        },
      ],
      'methods': [
        'Agriculture biologique',
        'Rotation des cultures',
        'Compostage naturel',
        'Lutte biologique',
        'Irrigation raisonnée',
        'Semis direct',
      ],
    },
    'updates': [
      {
        'id': 1,
        'title': 'Préparation du terrain terminée',
        'content':
            'Le labour et la préparation du sol sont maintenant terminés. Les analyses de sol montrent un excellent taux de matière organique de 3.2%. Nous sommes prêts pour les semis la semaine prochaine.',
        'author': 'Pierre Dubois',
        'authorAvatar':
            'https://images.unsplash.com/photo-1633004591307-1f7dda20c26c',
        'authorAvatarLabel':
            'Portrait of a middle-aged farmer with a straw hat and plaid shirt standing in a corn field',
        'date': '12 Mars 2024',
        'image':
            'https://images.unsplash.com/photo-1652089799111-cf30e90a5586',
        'imageLabel':
            'Freshly plowed agricultural field with dark rich soil ready for planting',
      },
      {
        'id': 2,
        'title': 'Commande des semences biologiques',
        'content':
            'Les semences de maïs biologique certifiées ont été commandées auprès de notre fournisseur habituel. Variété choisie: LG 30.215, adaptée à notre climat et résistante à la sécheresse.',
        'author': 'Pierre Dubois',
        'authorAvatar':
            'https://images.unsplash.com/photo-1633004591307-1f7dda20c26c',
        'authorAvatarLabel':
            'Portrait of a middle-aged farmer with a straw hat and plaid shirt standing in a corn field',
        'date': '8 Mars 2024',
        'image': null,
        'imageLabel': null,
      },
      {
        'id': 3,
        'title': 'Financement à 75%',
        'content':
            'Excellente nouvelle! Nous avons atteint 75% de notre objectif de financement grâce à vos investissements. Merci à tous nos partenaires pour leur confiance.',
        'author': 'Pierre Dubois',
        'authorAvatar':
            'https://images.unsplash.com/photo-1633004591307-1f7dda20c26c',
        'authorAvatarLabel':
            'Portrait of a middle-aged farmer with a straw hat and plaid shirt standing in a corn field',
        'date': '5 Mars 2024',
        'image': null,
        'imageLabel': null,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Custom app bar with project name and actions
          SliverAppBar(
            expandedHeight: 35.h,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back_ios_new',
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'share',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: _shareProject,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
                    color: _isBookmarked
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: _toggleBookmark,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ProjectHeroCarousel(
                imageUrls: _projectData['images'] as List<String>,
                semanticLabels: _projectData['imageLabels'] as List<String>,
              ),
            ),
          ),

          // Project content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project title
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _projectData['name'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Project summary card
                ProjectSummaryCard(projectData: _projectData),

                // Tabs view
                SizedBox(
                  height: 60.h,
                  child: ProjectTabsView(projectData: _projectData),
                ),

                // Investment section
                InvestmentSection(
                  projectData: _projectData,
                  isInvestor: _isInvestor,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),

      // Floating action button for quick actions
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isInvestor ? _quickInvest : _editProject,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: _isInvestor ? 'account_balance_wallet' : 'edit',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          _isInvestor ? 'Investir' : 'Modifier',
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _shareProject() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de partage à implémenter'),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Projet ajouté aux favoris'
              : 'Projet retiré des favoris',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _quickInvest() {
    // Navigate to investment flow or show investment modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Investissement rapide'),
        content: const Text('Voulez-vous investir 100€ dans ce projet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Investissement de 100€ traité avec succès!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Investir'),
          ),
        ],
      ),
    );
  }

  void _editProject() {
    Navigator.pushNamed(context, '/project-creation');
  }
}
