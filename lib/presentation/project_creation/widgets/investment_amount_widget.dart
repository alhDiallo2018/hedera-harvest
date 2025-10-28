import 'package:agridash/core/app_export.dart';

class InvestmentAmountWidget extends StatefulWidget {
  final double investmentNeeded;
  final int totalTokens;
  final double estimatedReturns;
  final Function(double) onInvestmentChanged;
  final Color cropColor;

  const InvestmentAmountWidget({
    super.key,
    required this.investmentNeeded,
    required this.totalTokens,
    required this.estimatedReturns,
    required this.onInvestmentChanged,
    required this.cropColor,
  });

  @override
  State<InvestmentAmountWidget> createState() => _InvestmentAmountWidgetState();
}

class _InvestmentAmountWidgetState extends State<InvestmentAmountWidget> {
  final List<double> _presetAmounts = [10000, 25000, 50000, 75000, 100000, 150000];
  final TextEditingController _amountController = TextEditingController();
  late double _currentInvestment;

  @override
  void initState() {
    super.initState();
    _currentInvestment = widget.investmentNeeded;
    _amountController.text = _currentInvestment.toInt().toString();
  }

  @override
  void didUpdateWidget(InvestmentAmountWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.investmentNeeded != _currentInvestment) {
      _currentInvestment = widget.investmentNeeded;
      _amountController.text = _currentInvestment.toInt().toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateAmount(double amount) {
    setState(() {
      _currentInvestment = amount;
    });
    _amountController.text = amount.toInt().toString();
    widget.onInvestmentChanged(amount);
  }

  void _onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    if (amount > 0 && amount != _currentInvestment) {
      _updateAmount(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        
        // Amount Input avec animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border.all(
              color: _currentInvestment >= 10000 ? Colors.green.shade300 : Colors.orange.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Montant total (FCFA)',
              prefixText: 'FCFA ',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              suffixText: 'FCFA',
              suffixStyle: TextStyle(
                color: widget.cropColor,
                fontWeight: FontWeight.bold,
              ),
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
        ),
        
        const SizedBox(height: 16),
        
        // Preset Amounts avec animations
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetAmounts.map((amount) {
            final isSelected = _currentInvestment == amount;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: FilterChip(
                selected: isSelected,
                label: Text('${amount.toInt()} FCFA'),
                onSelected: (selected) {
                  if (selected) {
                    _updateAmount(amount);
                  }
                },
                backgroundColor: Colors.white,
                selectedColor: widget.cropColor.withOpacity(0.1),
                checkmarkColor: widget.cropColor,
                labelStyle: TextStyle(
                  color: isSelected ? widget.cropColor : AppConstants.textColor,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? widget.cropColor : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Amount Slider dynamique
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
              value: _currentInvestment,
              min: 10000,
              max: 500000,
              divisions: 49,
              activeColor: widget.cropColor,
              inactiveColor: Colors.grey.shade300,
              label: '${_currentInvestment.toInt()} FCFA',
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
        
        // Summary avec animations
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.cropColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.cropColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Investissement total', '${_currentInvestment.toInt()} FCFA'),
              _buildSummaryRow('Nombre de tokens', '${(_currentInvestment / 100).round()} tokens'),
              _buildSummaryRow('Prix par token', '100 FCFA'),
              const SizedBox(height: 8),
              Divider(color: widget.cropColor.withOpacity(0.3)),
              _buildSummaryRow(
                'Retour estimé (25%)', 
                '${(_currentInvestment * 1.25).toInt()} FCFA',
                isHighlighted: true,
                valueColor: widget.cropColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {
    bool isHighlighted = false,
    Color? valueColor,
  }) {
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
              color: valueColor ?? AppConstants.textColor,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}