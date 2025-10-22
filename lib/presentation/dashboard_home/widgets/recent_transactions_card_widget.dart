import 'package:agridash/core/app_export.dart';

class RecentTransactionsCardWidget extends StatelessWidget {
  final UserRole userRole;

  const RecentTransactionsCardWidget({
    super.key,
    required this.userRole,
  });

  List<Map<String, dynamic>> _getDemoTransactions() {
    switch (userRole) {
      case UserRole.farmer:
        return [
          {
            'type': 'financement',
            'project': 'Culture de Maïs Bio',
            'amount': 15000.0,
            'date': '2024-01-15',
            'status': 'completed',
            'investor': 'Marie Investisseur',
          },
          {
            'type': 'retrait',
            'project': 'Serres de Tomates',
            'amount': 5000.0,
            'date': '2024-01-12',
            'status': 'completed',
            'investor': '',
          },
          {
            'type': 'financement',
            'project': 'Verger de Pommes',
            'amount': 8000.0,
            'date': '2024-01-10',
            'status': 'pending',
            'investor': 'Pierre Capital',
          },
        ];
      case UserRole.investor:
        return [
          {
            'type': 'investissement',
            'project': 'Culture de Maïs Bio',
            'amount': 15000.0,
            'date': '2024-01-15',
            'status': 'completed',
            'farmer': 'Jean Dupont',
          },
          {
            'type': 'dividende',
            'project': 'Serres de Tomates',
            'amount': 2500.0,
            'date': '2024-01-12',
            'status': 'completed',
            'farmer': 'Jean Dupont',
          },
          {
            'type': 'investissement',
            'project': 'Verger de Pommes',
            'amount': 8000.0,
            'date': '2024-01-10',
            'status': 'pending',
            'farmer': 'Paul Fermier',
          },
        ];
      case UserRole.admin:
        return [
          {
            'type': 'commission',
            'project': 'Culture de Maïs Bio',
            'amount': 750.0,
            'date': '2024-01-15',
            'status': 'completed',
            'users': 'Jean Dupont & Marie Invest.',
          },
          {
            'type': 'frais',
            'project': 'Serres de Tomates',
            'amount': 500.0,
            'date': '2024-01-12',
            'status': 'completed',
            'users': 'Transaction système',
          },
          {
            'type': 'commission',
            'project': 'Verger de Pommes',
            'amount': 400.0,
            'date': '2024-01-10',
            'status': 'pending',
            'users': 'Paul Fermier & Pierre Capital',
          },
        ];
    }
  }

  String _getTransactionTitle(Map<String, dynamic> transaction) {
    switch (userRole) {
      case UserRole.farmer:
        return transaction['type'] == 'financement' 
            ? 'Financement reçu - ${transaction['investor']}'
            : 'Retrait effectué';
      case UserRole.investor:
        return transaction['type'] == 'investissement'
            ? 'Investissement - ${transaction['farmer']}'
            : 'Dividende reçu - ${transaction['farmer']}';
      case UserRole.admin:
        return '${transaction['type']} - ${transaction['users']}';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppConstants.successColor;
      case 'pending':
        return AppConstants.warningColor;
      case 'failed':
        return AppConstants.errorColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Terminé';
      case 'pending':
        return 'En attente';
      case 'failed':
        return 'Échoué';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _getDemoTransactions();

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
            'Transactions Récentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...transactions.map((transaction) => _buildTransactionItem(transaction)),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {
                NavigationService().showSuccessDialog('Historique complet des transactions en cours de développement');
              },
              child: Text(
                'Voir l\'historique complet',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Transaction Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction['type'] == 'investissement' || transaction['type'] == 'financement'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTransactionTitle(transaction),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction['project'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction['amount'].toStringAsFixed(0)} FCFA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusText(transaction['status']),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(transaction['status']),
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