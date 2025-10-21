import 'package:agridash/core/index.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfile user = UserProfile(
    name: 'Jean Koffi',
    email: 'jean.koffi@email.com',
    phone: '+225 07 08 09 10 11',
    joinDate: '15 Jan 2023',
    totalInvestments: 3,
    totalPortfolioValue: 452000,
    averageReturn: 12.5,
  );

  bool notifications = true;
  bool darkMode = false;
  bool biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Naviguer vers les paramètres
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            // Section profil
            _buildProfileSection(),
            SizedBox(height: 3.h),
            
            // Statistiques
            _buildStatsSection(),
            SizedBox(height: 3.h),
            
            // Menu des options
            _buildMenuSection(),
            SizedBox(height: 3.h),
            
            // Section préférences
            _buildPreferencesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            // Avatar et informations
            Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 12.w,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        user.email,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        user.phone,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Investisseur Verifié',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.successLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            
            // Bouton d'édition
            OutlinedButton.icon(
              onPressed: () {
                // Éditer le profil
              },
              icon: const Icon(Icons.edit),
              label: Text(
                'Modifier le profil',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes Statistiques',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Investissements', user.totalInvestments.toString(), Icons.assignment),
                _buildStatItem('Portefeuille', '${(user.totalPortfolioValue / 1000).toStringAsFixed(0)}K', Icons.account_balance_wallet),
                _buildStatItem('Rendement', '${user.averageReturn.toStringAsFixed(1)}%', Icons.trending_up),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 8.w,
          ),
        ),
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
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Mes Documents',
        'subtitle': 'Contrats et rapports',
        'icon': Icons.folder,
        'color': Colors.blue,
      },
      {
        'title': 'Historique',
        'subtitle': 'Transactions et activités',
        'icon': Icons.history,
        'color': Colors.green,
      },
      {
        'title': 'Support',
        'subtitle': 'Centre d\'aide et contact',
        'icon': Icons.support_agent,
        'color': Colors.orange,
      },
      {
        'title': 'Sécurité',
        'subtitle': 'Mot de passe et authentification',
        'icon': Icons.security,
        'color': Colors.red,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menuItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            final Color color = item['color'] as Color;
            final IconData icon = item['icon'] as IconData;
            final String title = item['title'] as String;
            final String subtitle = item['subtitle'] as String;
            
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  // Navigation vers l'écran correspondant
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Préférences',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  'Notifications',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Recevoir les alertes et mises à jour',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                  });
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(
                  'Mode Sombre',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Activer l\'apparence sombre',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = value;
                  });
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(
                  'Authentification Biométrique',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Utiliser l\'empreinte digitale',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                value: biometricAuth,
                onChanged: (value) {
                  setState(() {
                    biometricAuth = value;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        
        // Bouton de déconnexion
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showLogoutDialog();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
              side: BorderSide(color: AppTheme.errorLight),
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Se Déconnecter',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Déconnexion',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter de votre compte ?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: GoogleFonts.roboto(),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Logique de déconnexion
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
            ),
            child: Text(
              'Déconnexion',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String joinDate;
  final int totalInvestments;
  final double totalPortfolioValue;
  final double averageReturn;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.joinDate,
    required this.totalInvestments,
    required this.totalPortfolioValue,
    required this.averageReturn,
  });
}