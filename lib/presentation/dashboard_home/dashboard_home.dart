import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/activity_feed_widget.dart';
import './widgets/cultivation_updates_card_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/investment_opportunities_card_widget.dart';
import './widgets/project_summary_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_transactions_card_widget.dart';
import './widgets/weather_widget.dart';

// Définition d'un widget SafeWidget
class SafeWidget extends StatelessWidget {
  final Widget child;
  const SafeWidget({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: child,
    );
  }
}

class DashboardHome extends StatefulWidget {
  final String userType;
  final String userName;

  const DashboardHome({
    super.key, 
    required this.userType,
    required this.userName,
  });

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      "type": "investment",
      "description": "Investissement Projet Maïs Bio",
      "amount": "+€2,500",
      "date": "19 Oct 2025",
    },
    {
      "type": "dividend",
      "description": "Dividende Culture Tomates",
      "amount": "+€450",
      "date": "18 Oct 2025",
    },
  ];

  final List<Map<String, dynamic>> _cultivationUpdates = [
    {
      "title": "Culture de Maïs - Parcelle A",
      "description": "Phase de croissance active, irrigation programmée",
      "stage": "Croissance",
      "date": "19 Oct 2025",
      "image": "https://images.unsplash.com/photo-1501220706818-35cce932f8ad",
      "semanticLabel": "Champ de maïs en croissance",
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "type": "project_update",
      "title": "Mise à jour Projet Maïs Bio",
      "description": "Nouvelle phase de croissance atteinte",
      "time": "Il y a 2 heures",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabCount(), vsync: this);
    print("DashboardHome - userType: ${widget.userType}, userName: ${widget.userName}");
  }

  int _getTabCount() {
    switch (widget.userType) {
      case 'farmer':
        return 5;
      case 'investor':
        return 4;
      case 'admin':
        return 5;
      default:
        return 5;
    }
  }

  List<Widget> _getTabs() {
    switch (widget.userType) {
      case 'farmer':
        return const [
          Tab(text: 'Accueil'),
          Tab(text: 'Projets'),
          Tab(text: 'Marché'),
          Tab(text: 'Portefeuille'),
          Tab(text: 'Profil'),
        ];
      case 'investor':
        return const [
          Tab(text: 'Accueil'),
          Tab(text: 'Investissements'),
          Tab(text: 'Marché'),
          Tab(text: 'Profil'),
        ];
      case 'admin':
        return const [
          Tab(text: 'Tableau de Bord'),
          Tab(text: 'Utilisateurs'),
          Tab(text: 'Projets'),
          Tab(text: 'Transactions'),
          Tab(text: 'Rapports'),
        ];
      default:
        return const [
          Tab(text: 'Accueil'),
          Tab(text: 'Projets'),
          Tab(text: 'Marché'),
          Tab(text: 'Portefeuille'),
          Tab(text: 'Profil'),
        ];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Données mises à jour avec succès'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToScreen(String route) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, route);
  }

  void _showNotifications() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            const Text('Aucune nouvelle notification'),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Paramètres',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen('/user-profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
              title: const Text('Préférences'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (widget.userType == 'farmer') {
      return FloatingActionButton.extended(
        onPressed: () => _navigateToScreen('/project-creation'),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Nouveau Projet'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      );
    } else if (widget.userType == 'investor') {
      return FloatingActionButton.extended(
        onPressed: () => _navigateToScreen('/marketplace'),
        icon: const Icon(Icons.search),
        label: const Text('Explorer'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header - Utilise le nom de l'utilisateur connecté
            DashboardHeaderWidget(
              userName: widget.userName,
              userAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d",
              userType: widget.userType,
              onNotificationTap: _showNotifications,
              onSettingsTap: _showSettings,
            ),

            // Tab Bar
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: _getTabs(),
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _getTabViews(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  List<Widget> _getTabViews() {
    switch (widget.userType) {
      case 'farmer':
        return [
          _buildFarmerHomeTab(),
          _buildPlaceholderTab('Projets', 'Gestion de vos projets agricoles'),
          _buildPlaceholderTab('Marché', 'Marketplace des investisseurs'),
          _buildPlaceholderTab('Portefeuille', 'Suivi de vos investissements'),
          _buildPlaceholderTab('Profil', 'Paramètres de votre compte'),
        ];
      case 'investor':
        return [
          _buildInvestorHomeTab(),
          _buildPlaceholderTab('Investissements', 'Vos investissements actuels'),
          _buildPlaceholderTab('Marché', 'Découvrir de nouvelles opportunités'),
          _buildPlaceholderTab('Profil', 'Paramètres de votre compte'),
        ];
      case 'admin':
        return [
          _buildAdminHomeTab(),
          _buildPlaceholderTab('Utilisateurs', 'Gestion des utilisateurs'),
          _buildPlaceholderTab('Projets', 'Supervision des projets'),
          _buildPlaceholderTab('Transactions', 'Suivi des transactions'),
          _buildPlaceholderTab('Rapports', 'Analyses et statistiques'),
        ];
      default:
        return [
          _buildFarmerHomeTab(),
          _buildPlaceholderTab('Projets', 'Gestion de vos projets agricoles'),
          _buildPlaceholderTab('Marché', 'Marketplace des investisseurs'),
          _buildPlaceholderTab('Portefeuille', 'Suivi de vos investissements'),
          _buildPlaceholderTab('Profil', 'Paramètres de votre compte'),
        ];
    }
  }

  Widget _buildPlaceholderTab(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 10.h, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
            SizedBox(height: 2.h),
            Text(
              '$title - En construction',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerHomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top - 50,
          ),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              
              SafeWidget(
                child: WeatherWidget(
                  weatherIcon: 'https://openweathermap.org/img/wn/01d@2x.png',
                  location: 'Paris, France',
                  temperature: 22.5,
                  condition: 'Ensoleillé',
                  humidity: 65,
                  windSpeed: 12.0,
                ),
              ),
              
              SizedBox(height: 2.h),
              
              SafeWidget(
                child: ProjectSummaryCardWidget(
                  activeProjects: 8,
                  completedProjects: 12,
                  totalInvestment: 45.2,
                  onTap: () => _navigateToScreen('/project-details'),
                ),
              ),
              
              SizedBox(height: 2.h),
              
              SafeWidget(
                child: InvestmentOpportunitiesCardWidget(
                  availableProjects: 24,
                  averageReturn: 12.8,
                  topCategory: 'Culture Biologique',
                  onTap: () => _navigateToScreen('/marketplace'),
                ),
              ),
              
              SizedBox(height: 2.h),
              
              SafeWidget(
                child: RecentTransactionsCardWidget(
                  transactions: _recentTransactions,
                  onViewAll: () => _navigateToScreen('/investment-tracking'),
                ),
              ),
              
              SizedBox(height: 2.h),
              
              SafeWidget(
                child: CultivationUpdatesCardWidget(
                  cultivationUpdates: _cultivationUpdates,
                  onViewAll: () => _navigateToScreen('/project-details'),
                ),
              ),
              
              SizedBox(height: 2.h),
              
              SafeWidget(
                child: QuickActionsWidget(
                  onCreateProject: () => _navigateToScreen('/project-creation'),
                  onViewMarketplace: () => _navigateToScreen('/marketplace'),
                  onTrackInvestments: () => _navigateToScreen('/investment-tracking'),
                  onManageProfile: () => _navigateToScreen('/user-profile'),
                ),
              ),
              
              SizedBox(height: 2.h),
              
              SafeWidget(
                child: ActivityFeedWidget(
                  activities: _recentActivities,
                  onViewAll: () => _navigateToScreen('/activity-feed'),
                ),
              ),
              
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvestorHomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Text(
              'Tableau de bord Investisseur - ${widget.userName}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            SafeWidget(
              child: _buildInvestorPortfolioCard(),
            ),
            SizedBox(height: 2.h),
            SafeWidget(
              child: _buildInvestmentOpportunitiesCard(),
            ),
            SizedBox(height: 2.h),
            SafeWidget(
              child: _buildRecentInvestmentsCard(),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminHomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Text(
              'Tableau de bord Administrateur - ${widget.userName}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            SafeWidget(
              child: _buildAdminStatsCard(),
            ),
            SizedBox(height: 2.h),
            SafeWidget(
              child: _buildPlatformActivityCard(),
            ),
            SizedBox(height: 2.h),
            SafeWidget(
              child: _buildAdminQuickActions(),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  // Méthodes pour le tableau de bord investisseur
  Widget _buildInvestorPortfolioCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 2.w),
                Text(
                  'Portefeuille',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPortfolioStat('Valeur Total', '125,000 FCFA', Colors.green),
                _buildPortfolioStat('Investissements', '8 projets', Colors.blue),
                _buildPortfolioStat('Rendement', '+15.2%', Colors.orange),
              ],
            ),
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 1.h),
            Text(
              '75% de votre capital investi',
              style: GoogleFonts.roboto(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentOpportunitiesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opportunités d\'Investissement',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Chip(
                  label: Text('12 nouvelles'),
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildOpportunityItem('Maïs Premium', 'Retour: 18%', '15,000 FCFA'),
            _buildOpportunityItem('Riz Bio', 'Retour: 16%', '8,000 FCFA'),
            _buildOpportunityItem('Café Arabica', 'Retour: 22%', '25,000 FCFA'),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityItem(String title, String returnInfo, String amount) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Icon(Icons.agriculture, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title),
      subtitle: Text(returnInfo),
      trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {},
    );
  }

  Widget _buildRecentInvestmentsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investissements Récents',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildInvestmentItem('Maïs Bio', '+2,500 FCFA', '19 Oct'),
            _buildInvestmentItem('Tomates', '+450 FCFA', '18 Oct'),
            _buildInvestmentItem('Élevage', '+800 FCFA', '16 Oct'),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentItem(String project, String amount, String date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.1),
        child: Icon(Icons.trending_up, color: Colors.green, size: 20),
      ),
      title: Text(project),
      subtitle: Text(date),
      trailing: Text(amount, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
    );
  }

  // Méthodes pour le tableau de bord administrateur
  Widget _buildAdminStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aperçu de la Plateforme',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              children: [
                _buildAdminStatCard('Utilisateurs', '1,254', Icons.people, Colors.blue),
                _buildAdminStatCard('Projets', '89', Icons.agriculture, Colors.green),
                _buildAdminStatCard('Transactions', '542', Icons.attach_money, Colors.orange),
                _buildAdminStatCard('Revenus', '2.5M FCFA', Icons.trending_up, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 1.h),
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformActivityCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activité Récente',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildActivityItem('Nouveau projet créé', 'Maïs Premium', '2 min'),
            _buildActivityItem('Investissement effectué', '15,000 FCFA', '5 min'),
            _buildActivityItem('Utilisateur inscrit', 'Jean Koffi', '10 min'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String action, String details, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(action),
      subtitle: Text(details),
      trailing: Text(time, style: TextStyle(color: Colors.grey[600])),
    );
  }

  Widget _buildAdminQuickActions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions Administrateur',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: [
                _buildQuickActionButton('Utilisateurs', Icons.people, () {}),
                _buildQuickActionButton('Projets', Icons.agriculture, () {}),
                _buildQuickActionButton('Transactions', Icons.receipt, () {}),
                _buildQuickActionButton('Rapports', Icons.analytics, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 40.w,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20.sp),
        label: Text(title, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
        ),
      ),
    );
  }
}