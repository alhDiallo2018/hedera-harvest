import 'package:agridash/routes/navigation_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/models/crop_investment.dart';
import '../../theme/app_theme.dart';

class PortfolioManagementScreen extends StatefulWidget {
  const PortfolioManagementScreen({super.key});

  @override
  State<PortfolioManagementScreen> createState() => _PortfolioManagementScreenState();
}

class _PortfolioManagementScreenState extends State<PortfolioManagementScreen> {
  final List<CropInvestment> investments = [
    CropInvestment(
      id: '1',
      name: 'Maïs Premium',
      type: 'Céréales',
      investedAmount: 150000,
      currentValue: 175000,
      returnPercentage: 16.7,
      duration: '12 mois',
      status: 'Actif',
      tokenId: '0.0.1234567',
      farmerId: 'farmer_001',
      totalTokens: 100,
      availableTokens: 40,
      tokenPrice: 1500,
      harvestDate: DateTime.now().add(Duration(days: 120)),
      estimatedYield: 8.5,
    ),
    CropInvestment(
      id: '2',
      name: 'Riz Bio',
      type: 'Riziculture',
      investedAmount: 80000,
      currentValue: 92000,
      returnPercentage: 15.0,
      duration: '8 mois',
      status: 'Actif',
      tokenId: '0.0.1234568',
      farmerId: 'farmer_002',
      totalTokens: 80,
      availableTokens: 25,
      tokenPrice: 1000,
      harvestDate: DateTime.now().add(Duration(days: 90)),
      estimatedYield: 7.2,
    ),
    CropInvestment(
      id: '3',
      name: 'Café Arabica',
      type: 'Plantation',
      investedAmount: 200000,
      currentValue: 185000,
      returnPercentage: -7.5,
      duration: '18 mois',
      status: 'En attente',
      tokenId: '0.0.1234569',
      farmerId: 'farmer_003',
      totalTokens: 200,
      availableTokens: 200,
      tokenPrice: 1000,
      harvestDate: DateTime.now().add(Duration(days: 180)),
      estimatedYield: 6.8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalInvestment = investments.fold<double>(0, (sum, item) => sum + item.investedAmount);
    final totalCurrentValue = investments.fold<double>(0, (sum, item) => sum + item.currentValue);
    final totalReturn = totalCurrentValue - totalInvestment;
    final double totalReturnPercentage = totalInvestment > 0 ? (totalReturn / totalInvestment * 100) : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion de Portefeuille',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_chart),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte de résumé du portefeuille
            _buildPortfolioSummaryCard(totalInvestment, totalCurrentValue, totalReturn, totalReturnPercentage),
            SizedBox(height: 3.h),
            
            // Graphique de répartition
            _buildAllocationChart(),
            SizedBox(height: 3.h),
            
            // En-tête des investissements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mes Investissements',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${investments.length} actifs',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            
            // Liste des investissements
            ...investments.map((investment) => _buildInvestmentCard(investment)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers l'écran de nouvel investissement
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPortfolioSummaryCard(double totalInvestment, double totalCurrentValue, double totalReturn, double totalReturnPercentage) {
    final isPositive = totalReturn >= 0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valeur du Portefeuille',
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '${totalCurrentValue.toStringAsFixed(0)} FCFA',
              style: GoogleFonts.roboto(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Investissement Total',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${totalInvestment.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rendement Total',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                          size: 16.sp,
                        ),
                        Text(
                          '${totalReturnPercentage.toStringAsFixed(1)}%',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Répartition des Cultures',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 20.h,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = investments.fold<double>(0, (sum, item) => sum + item.investedAmount);
    
    return investments.map((investment) {
      final percentage = (investment.investedAmount / total * 100);
      final color = _getColorForCropType(investment.type);
      
      return PieChartSectionData(
        color: color,
        value: investment.investedAmount.toDouble(), // CORRECTION: Conversion explicite en double
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForCropType(String type) {
    switch (type) {
      case 'Céréales':
        return AppTheme.primaryLight;
      case 'Riziculture':
        return AppTheme.secondaryLight;
      case 'Plantation':
        return AppTheme.accentLight;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInvestmentCard(CropInvestment investment) {
    final isPositive = investment.returnPercentage >= 0;
    
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        investment.name,
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        investment.type,
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                  decoration: BoxDecoration(
                    color: AppTheme.getStatusColor(investment.status, isLight: true).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    investment.status,
                    style: GoogleFonts.roboto(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.getStatusColor(investment.status, isLight: true),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Investi',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${investment.investedAmount.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Valeur actuelle',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${investment.currentValue.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rendement',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                          size: 14.sp,
                        ),
                        Text(
                          '${investment.returnPercentage.toStringAsFixed(1)}%',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              value: investment.currentValue / investment.investedAmount,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isPositive ? AppTheme.successLight : AppTheme.errorLight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Durée: ${investment.duration}',
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    NavigationService.navigateToCropDetail(
                      context: context,
                      investment: investment, // objet CropInvestment réel
                    );
                  },
                  child: Text(
                    'Voir détails',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}