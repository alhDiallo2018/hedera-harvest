import 'package:agridash/core/app_export.dart';

class InvestmentAmountWidget extends StatefulWidget {
  final double investmentNeeded;
  final Function(double) onInvestmentChanged;

  const InvestmentAmountWidget({
    super.key,
    required this.investmentNeeded,
    required this.onInvestmentChanged,
  });

  @override
  State<InvestmentAmountWidget> createState() => _InvestmentAmountWidgetState();
}

class _InvestmentAmountWidgetState extends State<InvestmentAmountWidget> {
  final List<double> _presetAmounts = [10000, 25000, 50000, 75000, 100000, 150000];
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.investmentNeeded.toInt().toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateAmount(double amount) {
    setState(() {
      widget.onInvestmentChanged(amount);
      _amountController.text = amount.toInt().toString();
    });
  }

  void _onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    if (amount > 0) {
      widget.onInvestmentChanged(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = (widget.investmentNeeded / 100).round(); // 1 token = 100 FCFA

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financement nécessaire',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Amount Input
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Montant total (FCFA)',
            prefixText: 'FCFA ',
            border: const OutlineInputBorder(),
            suffixText: 'FCFA',
          ),
          onChanged: _onAmountChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un montant';
            }
            final amount = double.tryParse(value) ?? 0;
            if (amount < 10000) {
              return 'Le montant minimum est de 10,000 FCFA';
            }
            if (amount > 1000000) {
              return 'Le montant maximum est de 1,000,000 FCFA';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Preset Amounts
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetAmounts.map((amount) {
            return FilterChip(
              selected: widget.investmentNeeded == amount,
              label: Text('${amount.toInt()} FCFA'),
              onSelected: (selected) {
                if (selected) {
                  _updateAmount(amount);
                }
              },
              backgroundColor: Colors.white,
              selectedColor: AppConstants.primaryColor.withOpacity(0.1),
              checkmarkColor: AppConstants.primaryColor,
              labelStyle: TextStyle(
                color: widget.investmentNeeded == amount 
                    ? AppConstants.primaryColor 
                    : AppConstants.textColor,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: widget.investmentNeeded == amount 
                    ? AppConstants.primaryColor 
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Amount Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajuster le montant',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: widget.investmentNeeded,
              min: 10000,
              max: 500000,
              divisions: 49,
              label: '${widget.investmentNeeded.toInt()} FCFA',
              onChanged: (value) {
                _updateAmount(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '10,000 FCFA',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
                Text(
                  '500,000 FCFA',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Investissement total', '${widget.investmentNeeded.toInt()} FCFA'),
              _buildSummaryRow('Nombre de tokens', '$tokens tokens'),
              _buildSummaryRow('Prix par token', '100 FCFA'),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              _buildSummaryRow(
                'Retour estimé (25%)', 
                '${(widget.investmentNeeded * 1.25).toInt()} FCFA',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(isHighlighted ? 1.0 : 0.7),
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}