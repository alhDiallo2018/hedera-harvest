import 'package:agridash/core/app_export.dart';

class AlertSettingsWidget extends StatefulWidget {
  const AlertSettingsWidget({super.key});

  @override
  State<AlertSettingsWidget> createState() => _AlertSettingsWidgetState();
}

class _AlertSettingsWidgetState extends State<AlertSettingsWidget> {
  bool _priceAlerts = true;
  bool _projectUpdates = true;
  bool _monthlyReports = true;
  bool _dividendAlerts = true;
  bool _marketNews = false;

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alertes et Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Configurez les notifications pour rester informé',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Alert Settings
          _buildAlertSetting(
            'Alertes de prix',
            'Notifications lorsque la valeur de vos investissements change significativement',
            _priceAlerts,
            (value) => setState(() => _priceAlerts = value),
            Icons.price_change,
          ),
          
          _buildAlertSetting(
            'Mises à jour des projets',
            'Nouvelles photos et rapports de croissance des cultures',
            _projectUpdates,
            (value) => setState(() => _projectUpdates = value),
            Icons.update,
          ),
          
          _buildAlertSetting(
            'Rapports mensuels',
            'Résumé mensuel de la performance de votre portefeuille',
            _monthlyReports,
            (value) => setState(() => _monthlyReports = value),
            Icons.analytics,
          ),
          
          _buildAlertSetting(
            'Alertes de dividendes',
            'Notifications lorsque des dividendes sont distribués',
            _dividendAlerts,
            (value) => setState(() => _dividendAlerts = value),
            Icons.account_balance_wallet,
          ),
          
          _buildAlertSetting(
            'Nouvelles du marché',
            'Actualités et tendances du marché agricole',
            _marketNews,
            (value) => setState(() => _marketNews = value),
            Icons.newspaper,
          ),
          
          const SizedBox(height: 16),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sauvegarder les paramètres',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertSetting(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
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
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConstants.primaryColor,
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    NavigationService().showSuccessDialog('Paramètres d\'alertes sauvegardés avec succès');
  }
}