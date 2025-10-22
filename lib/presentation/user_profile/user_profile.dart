import 'package:agridash/core/app_export.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _authService = AuthService();
  final PortfolioService _portfolioService = PortfolioService();
  
  UserModel? _user;
  Map<String, dynamic> _portfolioData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _user = _authService.currentUser;
      if (_user != null) {
        if (_user!.role == UserRole.farmer) {
          _portfolioData = await _portfolioService.getFarmerPortfolio(_user!.id);
        } else if (_user!.role == UserRole.investor) {
          _portfolioData = await _portfolioService.getPortfolioSummary(_user!.id);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur lors du chargement du profil: $e');
    }
  }

  void _editProfile() {
    NavigationService().showSuccessDialog('Édition du profil en cours de développement');
  }

  void _showSettings() {
    NavigationService().showSuccessDialog('Paramètres en cours de développement');
  }

  void _showHelp() {
    NavigationService().showSuccessDialog('Centre d\'aide en cours de développement');
  }

  Future<void> _logout() async {
    final confirmed = await NavigationService().showConfirmationDialog(
      title: 'Déconnexion',
      message: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      confirmText: 'Déconnexion',
      cancelText: 'Annuler',
    );

    if (confirmed == true) {
      await _authService.logout();
      NavigationService().toLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Utilisateur non connecté',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => NavigationService().toLogin(),
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    // Header
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: Text(
                        'Mon Profil',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: _editProfile,
                          icon: const Icon(Icons.edit_outlined),
                          color: AppConstants.textColor,
                        ),
                      ],
                    ),

                    // Profile Header
                    SliverToBoxAdapter(
                      child: _buildProfileHeader(),
                    ),

                    // Statistics
                    SliverToBoxAdapter(
                      child: _buildStatistics(),
                    ),

                    // Menu Items
                    SliverList(
                      delegate: SliverChildListDelegate([
                        _buildMenuSection('Compte', [
                          _buildMenuItem(
                            'Informations personnelles',
                            Icons.person_outline,
                            _editProfile,
                          ),
                          _buildMenuItem(
                            'Sécurité',
                            Icons.security_outlined,
                            _showSettings,
                          ),
                          _buildMenuItem(
                            'Notifications',
                            Icons.notifications_outlined,
                            _showSettings,
                          ),
                        ]),
                        
                        _buildMenuSection('Support', [
                          _buildMenuItem(
                            'Centre d\'aide',
                            Icons.help_outline,
                            _showHelp,
                          ),
                          _buildMenuItem(
                            'Contactez-nous',
                            Icons.email_outlined,
                            _showHelp,
                          ),
                          _buildMenuItem(
                            'Conditions d\'utilisation',
                            Icons.description_outlined,
                            _showHelp,
                          ),
                        ]),
                        
                        _buildMenuSection('Application', [
                          _buildMenuItem(
                            'À propos',
                            Icons.info_outline,
                            _showHelp,
                          ),
                          _buildMenuItem(
                            'Version ${AppConstants.appVersion}',
                            Icons.phone_iphone_outlined,
                            () {},
                            showTrailing: false,
                          ),
                        ]),
                        
                        // Logout Button
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: OutlinedButton(
                            onPressed: _logout,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppConstants.errorColor,
                              side: BorderSide(color: AppConstants.errorColor),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Déconnexion',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ]),
                    ),
                  ],
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Name
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _user!.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _user!.email,
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _user!.role.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Additional Info
          if (_user!.location != null || _user!.phone != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (_user!.location != null) ...[
                    _buildInfoItem(Icons.location_on_outlined, _user!.location!),
                    const SizedBox(width: 16),
                  ],
                  if (_user!.phone != null)
                    _buildInfoItem(Icons.phone_outlined, _user!.phone!),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    if (_user!.role == UserRole.admin) {
      return const SizedBox(); // Admins don't have portfolio stats
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _user!.role == UserRole.farmer ? 'Mes Statistiques' : 'Mes Investissements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: _user!.role == UserRole.farmer 
                ? _buildFarmerStats()
                : _buildInvestorStats(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFarmerStats() {
    final totalProjects = _portfolioData['totalProjects'] ?? 0;
    final completedProjects = _portfolioData['completedProjects'] ?? 0;
    final totalRaised = _portfolioData['totalRaised'] ?? 0.0;
    final averageROI = _portfolioData['averageROI'] ?? 0.0;

    return [
      _buildStatItem('Projets', '$totalProjects', Icons.business_center),
      _buildStatItem('Terminés', '$completedProjects', Icons.check_circle),
      _buildStatItem('Levés', '${totalRaised.toStringAsFixed(0)}', Icons.attach_money),
      _buildStatItem('ROI Moyen', '${averageROI.toStringAsFixed(1)}%', Icons.trending_up),
    ];
  }

  List<Widget> _buildInvestorStats() {
    final totalInvested = _portfolioData['totalInvested'] ?? 0.0;
    final currentValue = _portfolioData['currentValue'] ?? 0.0;
    final activeInvestments = _portfolioData['activeInvestments'] ?? 0;
    final overallROI = _portfolioData['overallROI'] ?? 0.0;

    return [
      _buildStatItem('Investi', '${totalInvested.toStringAsFixed(0)}', Icons.account_balance_wallet),
      _buildStatItem('Valeur Actuelle', '${currentValue.toStringAsFixed(0)}', Icons.attach_money),
      _buildStatItem('Investissements', '$activeInvestments', Icons.business_center),
      _buildStatItem('ROI Total', '${overallROI.toStringAsFixed(1)}%', Icons.analytics),
    ];
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppConstants.textColor.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor.withOpacity(0.8),
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap, {bool showTrailing = true}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppConstants.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: AppConstants.textColor,
        ),
      ),
      trailing: showTrailing
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppConstants.textColor.withOpacity(0.5),
            )
          : null,
      onTap: onTap,
    );
  }
}