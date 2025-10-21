import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AlertSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> alertSettings;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const AlertSettingsWidget({
    super.key,
    required this.alertSettings,
    required this.onSettingsChanged,
  });

  @override
  State<AlertSettingsWidget> createState() => _AlertSettingsWidgetState();
}

class _AlertSettingsWidgetState extends State<AlertSettingsWidget> {
  late Map<String, dynamic> _settings;

  @override
  void initState() {
    super.initState();
    _settings = Map<String, dynamic>.from(widget.alertSettings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Paramètres d\'Alerte',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              CustomIconWidget(
                iconName: 'notifications',
                color: colorScheme.primary,
                size: 24,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Value threshold alerts
          _AlertSection(
            title: 'Seuils de Valeur',
            icon: 'trending_up',
            children: [
              _AlertToggle(
                title: 'Augmentation de valeur',
                subtitle: 'Alerte quand la valeur augmente de plus de 5%',
                value: (_settings['valueIncrease'] as bool?) ?? false,
                onChanged: (value) => _updateSetting('valueIncrease', value),
                theme: theme,
              ),
              _AlertToggle(
                title: 'Diminution de valeur',
                subtitle: 'Alerte quand la valeur diminue de plus de 5%',
                value: (_settings['valueDecrease'] as bool?) ?? false,
                onChanged: (value) => _updateSetting('valueDecrease', value),
                theme: theme,
              ),
              _ThresholdSetting(
                title: 'Seuil personnalisé',
                currentValue: (_settings['customThreshold'] as double?) ?? 5.0,
                onChanged: (value) => _updateSetting('customThreshold', value),
                theme: theme,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Dividend alerts
          _AlertSection(
            title: 'Dividendes',
            icon: 'payments',
            children: [
              _AlertToggle(
                title: 'Paiements de dividendes',
                subtitle: 'Notification lors de chaque paiement',
                value: (_settings['dividendPayments'] as bool?) ?? true,
                onChanged: (value) => _updateSetting('dividendPayments', value),
                theme: theme,
              ),
              _AlertToggle(
                title: 'Rappel de dividendes',
                subtitle: 'Rappel 3 jours avant le paiement prévu',
                value: (_settings['dividendReminder'] as bool?) ?? false,
                onChanged: (value) => _updateSetting('dividendReminder', value),
                theme: theme,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Project updates
          _AlertSection(
            title: 'Mises à Jour du Projet',
            icon: 'update',
            children: [
              _AlertToggle(
                title: 'Étapes importantes',
                subtitle: 'Notification pour les jalons du projet',
                value: (_settings['projectMilestones'] as bool?) ?? true,
                onChanged: (value) =>
                    _updateSetting('projectMilestones', value),
                theme: theme,
              ),
              _AlertToggle(
                title: 'Rapports mensuels',
                subtitle: 'Rapport de performance mensuel',
                value: (_settings['monthlyReports'] as bool?) ?? false,
                onChanged: (value) => _updateSetting('monthlyReports', value),
                theme: theme,
              ),
              _AlertToggle(
                title: 'Actualités du projet',
                subtitle: 'Nouvelles et mises à jour du projet',
                value: (_settings['projectNews'] as bool?) ?? false,
                onChanged: (value) => _updateSetting('projectNews', value),
                theme: theme,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Notification preferences
          _AlertSection(
            title: 'Préférences de Notification',
            icon: 'settings',
            children: [
              _NotificationTimeSetting(
                title: 'Heure préférée',
                currentTime: (_settings['preferredTime'] as String?) ?? '09:00',
                onChanged: (time) => _updateSetting('preferredTime', time),
                theme: theme,
              ),
              _AlertToggle(
                title: 'Mode silencieux',
                subtitle: 'Pas de notifications entre 22h et 8h',
                value: (_settings['quietMode'] as bool?) ?? true,
                onChanged: (value) => _updateSetting('quietMode', value),
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
    widget.onSettingsChanged(_settings);
  }
}

class _AlertSection extends StatelessWidget {
  final String title;
  final String icon;
  final List<Widget> children;

  const _AlertSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...children,
      ],
    );
  }
}

class _AlertToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ThemeData theme;

  const _AlertToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: value
            ? colorScheme.primary.withValues(alpha: 0.05)
            : colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ThresholdSetting extends StatelessWidget {
  final String title;
  final double currentValue;
  final ValueChanged<double> onChanged;
  final ThemeData theme;

  const _ThresholdSetting({
    required this.title,
    required this.currentValue,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${currentValue.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Slider(
            value: currentValue,
            min: 1.0,
            max: 20.0,
            divisions: 19,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _NotificationTimeSetting extends StatelessWidget {
  final String title;
  final String currentTime;
  final ValueChanged<String> onChanged;
  final ThemeData theme;

  const _NotificationTimeSetting({
    required this.title,
    required this.currentTime,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    currentTime,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      onChanged(formattedTime);
    }
  }
}
