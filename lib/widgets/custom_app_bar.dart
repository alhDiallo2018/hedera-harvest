import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget optimized for agricultural fintech applications
/// Provides consistent navigation and branding across the application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true when there's a previous route)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title (defaults to true for agricultural context)
  final bool centerTitle;

  /// Custom background color (defaults to theme primary color)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons
  final Color? foregroundColor;

  /// Elevation of the app bar (defaults to 2.0 for subtle depth)
  final double elevation;

  /// Whether to show a bottom border for additional definition
  final bool showBottomBorder;

  /// Custom bottom widget (like TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.showBottomBorder = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canPop = Navigator.of(context).canPop();

    // Determine colors based on theme and provided overrides
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
    final effectiveForegroundColor = foregroundColor ??
        (backgroundColor != null
            ? _getContrastingColor(backgroundColor!)
            : colorScheme.onPrimary);

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: effectiveForegroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      shadowColor: theme.shadowColor,
      surfaceTintColor: Colors.transparent,

      // Leading widget logic
      leading: leading ??
          (canPop && showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Back',
                )
              : null),

      // Actions with haptic feedback
      actions: actions?.map((action) {
        if (action is IconButton) {
          return IconButton(
            icon: action.icon,
            onPressed: () {
              HapticFeedback.lightImpact();
              action.onPressed?.call();
            },
            tooltip: action.tooltip,
          );
        }
        return action;
      }).toList(),

      // Bottom widget (like TabBar)
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: bottom!.preferredSize,
              child: Container(
                decoration: showBottomBorder
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                effectiveForegroundColor.withValues(alpha: 0.2),
                            width: 1.0,
                          ),
                        ),
                      )
                    : null,
                child: bottom!,
              ),
            )
          : showBottomBorder
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(
                    height: 1.0,
                    color: effectiveForegroundColor.withValues(alpha: 0.2),
                  ),
                )
              : null,

      // System UI overlay style for status bar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _getBrightness(effectiveBackgroundColor),
        statusBarBrightness: _getBrightness(effectiveBackgroundColor),
      ),
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    } else if (showBottomBorder) {
      height += 1.0;
    }
    return Size.fromHeight(height);
  }

  /// Factory constructor for dashboard screens
  factory CustomAppBar.dashboard({
    required String title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: false,
      actions: actions,
      bottom: bottom,
      elevation: 1.0,
    );
  }

  /// Factory constructor for detail screens
  factory CustomAppBar.detail({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      showBottomBorder: true,
    );
  }

  /// Factory constructor for form screens
  factory CustomAppBar.form({
    required String title,
    VoidCallback? onSave,
    VoidCallback? onCancel,
  }) {
    return CustomAppBar(
      title: title,
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onCancel();
            },
            child: const Text('Cancel'),
          ),
        if (onSave != null)
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onSave();
            },
            child: const Text('Save'),
          ),
      ],
    );
  }

  /// Factory constructor with search functionality
  factory CustomAppBar.search({
    required String title,
    required VoidCallback onSearchPressed,
    List<Widget>? additionalActions,
  }) {
    return CustomAppBar(
      title: title,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            HapticFeedback.lightImpact();
            onSearchPressed();
          },
          tooltip: 'Search',
        ),
        ...?additionalActions,
      ],
    );
  }

  /// Helper method to determine contrasting color
  Color _getContrastingColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Helper method to determine brightness for system UI
  Brightness _getBrightness(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Brightness.dark : Brightness.light;
  }
}
