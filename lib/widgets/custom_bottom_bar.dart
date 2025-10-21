import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data for the bottom navigation bar
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;
  final bool showBadge;
  final String? badgeText;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
    this.showBadge = false,
    this.badgeText,
  });
}

/// Custom Bottom Navigation Bar optimized for agricultural fintech applications
/// Provides quick access to main application sections with visual feedback
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  /// Elevation of the bottom bar
  final double elevation;

  /// Whether to show labels for all items
  final bool showLabels;

  /// Type of bottom navigation bar
  final BottomNavigationBarType type;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.showLabels = true,
    this.type = BottomNavigationBarType.fixed,
  });

  /// Navigation items for agricultural fintech app
  static const List<BottomNavItem> _navigationItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard-home',
    ),
    BottomNavItem(
      icon: Icons.add_business_outlined,
      activeIcon: Icons.add_business,
      label: 'Create',
      route: '/project-creation',
    ),
    BottomNavItem(
      icon: Icons.store_outlined,
      activeIcon: Icons.store,
      label: 'Market',
      route: '/marketplace',
    ),
    BottomNavItem(
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up,
      label: 'Investments',
      route: '/investment-tracking',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine effective colors
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveSelectedColor = selectedItemColor ?? colorScheme.primary;
    final effectiveUnselectedColor =
        unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: _NavigationItem(
                  item: item,
                  isSelected: isSelected,
                  selectedColor: effectiveSelectedColor,
                  unselectedColor: effectiveUnselectedColor,
                  showLabel: showLabels,
                  onTap: () => _handleNavigation(context, index, item.route),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Handle navigation with haptic feedback and route management
  void _handleNavigation(BuildContext context, int index, String route) {
    // Provide haptic feedback for better user experience
    HapticFeedback.lightImpact();

    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route if it's different from current
    if (index != currentIndex) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != route) {
        Navigator.pushReplacementNamed(context, route);
      }
    }
  }

  /// Factory constructor for dashboard usage
  factory CustomBottomBar.dashboard({
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showLabels: true,
    );
  }

  /// Factory constructor for minimal design
  factory CustomBottomBar.minimal({
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.shifting,
      showLabels: false,
      elevation: 4.0,
    );
  }
}

/// Individual navigation item widget
class _NavigationItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isSelected ? selectedColor : unselectedColor;
    final effectiveIcon =
        isSelected && item.activeIcon != null ? item.activeIcon! : item.icon;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(4),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: selectedColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Icon(
                    effectiveIcon,
                    size: 24,
                    color: effectiveColor,
                  ),
                ),

                // Badge indicator
                if (item.showBadge)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: item.badgeText != null
                          ? Text(
                              item.badgeText!,
                              style: GoogleFonts.roboto(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                  ),
              ],
            ),

            // Label
            if (showLabel) ...[
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: effectiveColor,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Extension to get current index based on route
extension CustomBottomBarExtension on CustomBottomBar {
  /// Get the current index based on the current route
  static int getCurrentIndex(String? currentRoute) {
    if (currentRoute == null) return 0;

    for (int i = 0; i < CustomBottomBar._navigationItems.length; i++) {
      if (CustomBottomBar._navigationItems[i].route == currentRoute) {
        return i;
      }
    }
    return 0; // Default to dashboard
  }

  /// Get navigation items for external use
  static List<BottomNavItem> get navigationItems =>
      CustomBottomBar._navigationItems;
}
