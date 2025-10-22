import 'package:agridash/core/app_export.dart';

class InvestmentSection extends StatefulWidget {
  final CropProject project;
  final Function(double) onInvest;
  final bool isInvesting;

  const InvestmentSection({
    super.key,
    required this.project,
    required this.onInvest,
    required this.isInvesting,
  });

  @override
  State<InvestmentSection> createState() => _InvestmentSectionState();
}

class _InvestmentSectionState extends State<InvestmentSection> {
  double _investmentAmount = 1000;
  final List<double> _presetAmounts = [1000, 5000, 10000, 25000, 50000];

  double get _tokensToReceive => _investmentAmount / widget.project.tokenPrice;
  double get _potentialReturns => _investmentAmount * (widget.project.estimatedROI / 100);

  void _handleInvestment() {
    if (_investmentAmount > 0) {
      widget.onInvest(_investmentAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Investir dans le projet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              IconButton(
                onPressed: () => NavigationService().goBack(),
                icon: const Icon(Icons.close),
                color: AppConstants.textColor,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Project Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Prix du token: ${widget.project.tokenPrice} FCFA',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Investment Amount
          Text(
            'Montant d\'investissement (FCFA)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Amount Input
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: 'FCFA ',
              hintText: 'Entrez le montant',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0;
              setState(() {
                _investmentAmount = amount;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Preset Amounts
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetAmounts.map((amount) {
              return FilterChip(
                selected: _investmentAmount == amount,
                label: Text('${amount.toInt()} FCFA'),
                onSelected: (selected) {
                  setState(() {
                    _investmentAmount = amount;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppConstants.primaryColor.withOpacity(0.1),
                checkmarkColor: AppConstants.primaryColor,
                labelStyle: TextStyle(
                  color: _investmentAmount == amount 
                      ? AppConstants.primaryColor 
                      : AppConstants.textColor,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: _investmentAmount == amount 
                      ? AppConstants.primaryColor 
                      : Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Investment Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Tokens à recevoir', _tokensToReceive.toStringAsFixed(2)),
                _buildSummaryRow('ROI estimé', '${widget.project.estimatedROI.toStringAsFixed(0)}%'),
                _buildSummaryRow('Retour potentiel', '${_potentialReturns.toStringAsFixed(0)} FCFA'),
                const SizedBox(height: 8),
                Divider(color: Colors.grey.shade300),
                _buildSummaryRow(
                  'Total investi', 
                  '${_investmentAmount.toStringAsFixed(0)} FCFA',
                  isTotal: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Invest Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isInvesting ? null : _handleInvestment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: widget.isInvesting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Confirmer l\'investissement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Disclaimer
          Text(
            'En investissant, vous acceptez les conditions générales d\'utilisation et reconnaissez les risques associés.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(isTotal ? 1.0 : 0.7),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}