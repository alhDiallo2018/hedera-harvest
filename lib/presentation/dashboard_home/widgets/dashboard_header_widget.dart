import 'package:agridash/core/app_export.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;

  const DashboardHeaderWidget({
    super.key,
    required this.user,
    required this.onProfileTap,
    required this.onNotificationTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  String _getUserSpecificGreeting() {
    switch (user.role) {
      case UserRole.farmer:
        return 'Prêt pour une nouvelle récolte ?';
      case UserRole.investor:
        return 'Découvrez de nouvelles opportunités';
      case UserRole.admin:
        return 'Gérez votre plateforme';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final userName = user.name.split(' ').first;
    final userGreeting = _getUserSpecificGreeting();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Avatar and Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    Text(
                      ', $userName ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const Text(
                      '👋',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  userGreeting,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                // User Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              // Notification Icon
              IconButton(
                onPressed: onNotificationTap,
                icon: Badge(
                  smallSize: 8,
                  backgroundColor: AppConstants.errorColor,
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppConstants.textColor,
                    size: 24,
                  ),
                ),
              ),

              // Profile Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}