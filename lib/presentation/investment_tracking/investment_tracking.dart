import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alert_settings_widget.dart';
import './widgets/comparison_tool_widget.dart';
import './widgets/documents_section_widget.dart';
import './widgets/investment_header_widget.dart';
import './widgets/investment_timeline_widget.dart';
import './widgets/key_metrics_widget.dart';
import './widgets/performance_chart_widget.dart';

class InvestmentTracking extends StatefulWidget {
  const InvestmentTracking({super.key});

  @override
  State<InvestmentTracking> createState() => _InvestmentTrackingState();
}

class _InvestmentTrackingState extends State<InvestmentTracking>
    with TickerProviderStateMixin {
  String selectedPeriod = '6M';
  late TabController _tabController;

  // Mock investment data
  final Map<String, dynamic> investmentData = {
    'name': 'Culture de Maïs Bio - Ferme Dubois',
    'currentValue': 12750.0,
    'percentageChange': 8.5,
    'initialInvestment': 10000.0,
    'totalReturn': 2750.0,
    'roiPercentage': 27.5,
    'dividendPayments': 1250.0,
    'duration': 18,
  };

  // Mock chart data
  final List<Map<String, dynamic>> chartData = [
    {'date': 'Jan', 'value': 10000.0},
    {'date': 'Fév', 'value': 10200.0},
    {'date': 'Mar', 'value': 10800.0},
    {'date': 'Avr', 'value': 11200.0},
    {'date': 'Mai', 'value': 11800.0},
    {'date': 'Jun', 'value': 12750.0},
  ];

  // Mock timeline data
  final List<Map<String, dynamic>> timelineData = [
    {
      'type': 'investment',
      'title': 'Investissement Initial',
      'date': '15 Janvier 2024',
      'amount': 10000.0,
      'description':
          'Investissement initial dans le projet de culture de maïs biologique. Financement pour l\'achat des semences, préparation du terrain et équipement agricole.',
    },
    {
      'type': 'milestone',
      'title': 'Plantation Terminée',
      'date': '28 Mars 2024',
      'description':
          'Plantation de 50 hectares de maïs biologique terminée avec succès. Conditions météorologiques favorables.',
    },
    {
      'type': 'dividend',
      'title': 'Premier Dividende',
      'date': '15 Juin 2024',
      'amount': 625.0,
      'description':
          'Premier paiement de dividende basé sur les ventes préliminaires et les subventions agricoles.',
    },
    {
      'type': 'milestone',
      'title': 'Récolte Commencée',
      'date': '10 Septembre 2024',
      'description':
          'Début de la récolte avec un rendement estimé à 120% des prévisions initiales.',
    },
    {
      'type': 'dividend',
      'title': 'Dividende Trimestriel',
      'date': '15 Septembre 2024',
      'amount': 625.0,
      'description':
          'Deuxième paiement de dividende suite aux excellents résultats de récolte.',
    },
    {
      'type': 'value_change',
      'title': 'Réévaluation Positive',
      'date': '01 Octobre 2024',
      'description':
          'Augmentation de la valeur de l\'investissement suite aux résultats exceptionnels de la récolte.',
    },
  ];

  // Mock documents data
  final List<Map<String, dynamic>> documents = [
    {
      'name': 'Certificat d\'Investissement',
      'type': 'certificate',
      'size': '2.4 MB',
      'date': '15 Janvier 2024',
    },
    {
      'name': 'Rapport Trimestriel Q2 2024',
      'type': 'report',
      'size': '1.8 MB',
      'date': '30 Juin 2024',
    },
    {
      'name': 'Document Fiscal 2024',
      'type': 'tax',
      'size': '856 KB',
      'date': '15 Septembre 2024',
    },
    {
      'name': 'Contrat d\'Investissement',
      'type': 'contract',
      'size': '3.2 MB',
      'date': '15 Janvier 2024',
    },
    {
      'name': 'Rapport de Récolte',
      'type': 'report',
      'size': '4.1 MB',
      'date': '01 Octobre 2024',
    },
  ];

  // Mock comparison options
  final List<Map<String, dynamic>> comparisonOptions = [
    {
      'id': 'cac40',
      'name': 'CAC 40',
      'description': 'Indice boursier français',
      'icon': 'trending_up',
      'value': 11200.0,
      'roiPercentage': 12.0,
    },
    {
      'id': 'agricultural_index',
      'name': 'Indice Agricole Européen',
      'description': 'Performance du secteur agricole',
      'icon': 'agriculture',
      'value': 10800.0,
      'roiPercentage': 8.0,
    },
    {
      'id': 'other_investment',
      'name': 'Culture de Blé - Ferme Martin',
      'description': 'Autre investissement agricole',
      'icon': 'eco',
      'value': 11500.0,
      'roiPercentage': 15.0,
    },
  ];

  // Mock alert settings
  Map<String, dynamic> alertSettings = {
    'valueIncrease': true,
    'valueDecrease': true,
    'customThreshold': 5.0,
    'dividendPayments': true,
    'dividendReminder': false,
    'projectMilestones': true,
    'monthlyReports': false,
    'projectNews': false,
    'preferredTime': '09:00',
    'quietMode': true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: const Text('Suivi d\'Investissement'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _exportInvestmentStatement,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Exporter le relevé',
          ),
          IconButton(
            onPressed: _refreshData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Actualiser',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: colorScheme.onPrimary,
          tabs: const [
            Tab(text: 'Vue d\'ensemble'),
            Tab(text: 'Chronologie'),
            Tab(text: 'Documents'),
            Tab(text: 'Paramètres'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildTimelineTab(),
            _buildDocumentsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Investment header with period selector
          InvestmentHeaderWidget(
            investmentData: investmentData,
            selectedPeriod: selectedPeriod,
            onPeriodChanged: (period) {
              setState(() {
                selectedPeriod = period;
              });
            },
          ),

          SizedBox(height: 3.h),

          // Performance chart
          PerformanceChartWidget(
            chartData: chartData,
            selectedPeriod: selectedPeriod,
          ),

          SizedBox(height: 3.h),

          // Key metrics grid
          KeyMetricsWidget(
            metricsData: investmentData,
          ),

          SizedBox(height: 3.h),

          // Comparison tool
          ComparisonToolWidget(
            currentInvestment: investmentData,
            comparisonOptions: comparisonOptions,
          ),

          SizedBox(height: 10.h), // Bottom padding for navigation
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          InvestmentTimelineWidget(
            timelineData: timelineData,
          ),

          SizedBox(height: 10.h), // Bottom padding for navigation
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          DocumentsSectionWidget(
            documents: documents,
          ),

          SizedBox(height: 3.h),

          // Transaction history section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
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
                      'Historique des Transactions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextButton(
                      onPressed: _showTransactionHistory,
                      child: const Text('Voir Tout'),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _TransactionItem(
                  title: 'Investissement Initial',
                  date: '15 Janvier 2024',
                  amount: -10000.0,
                  type: 'investment',
                ),
                SizedBox(height: 1.h),
                _TransactionItem(
                  title: 'Dividende Q2',
                  date: '15 Juin 2024',
                  amount: 625.0,
                  type: 'dividend',
                ),
                SizedBox(height: 1.h),
                _TransactionItem(
                  title: 'Dividende Q3',
                  date: '15 Septembre 2024',
                  amount: 625.0,
                  type: 'dividend',
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h), // Bottom padding for navigation
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AlertSettingsWidget(
            alertSettings: alertSettings,
            onSettingsChanged: (newSettings) {
              setState(() {
                alertSettings = newSettings;
              });
            },
          ),

          SizedBox(height: 10.h), // Bottom padding for navigation
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Données mises à jour'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _exportInvestmentStatement() {
    // Handle export functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exporter le Relevé'),
        content: const Text('Choisissez le format d\'export :'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportToPDF();
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportToCSV();
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _exportToPDF() {
    // Handle PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export PDF en cours...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportToCSV() {
    // Handle CSV export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export CSV en cours...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showTransactionHistory() {
    Navigator.pushNamed(context, '/transaction-history');
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final double amount;
  final String type;

  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPositive = amount > 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: _getTypeColor(type).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getTypeIcon(type),
                color: _getTypeColor(type),
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  date,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}€${amount.abs().toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isPositive
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'investment':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'dividend':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'investment':
        return 'account_balance_wallet';
      case 'dividend':
        return 'payments';
      default:
        return 'swap_horiz';
    }
  }
}
