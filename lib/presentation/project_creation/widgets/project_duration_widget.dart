import 'package:agridash/core/app_export.dart';

class QuickDuration {
    final int days;
    final String label;
    final String emoji;

    const QuickDuration({
      required this.days,
      required this.label,
      required this.emoji,
    });
}

class ProjectDurationWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime harvestDate;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onHarvestDateChanged;

  const ProjectDurationWidget({
    super.key,
    required this.startDate,
    required this.harvestDate,
    required this.onStartDateChanged,
    required this.onHarvestDateChanged,
  });

  @override
  State<ProjectDurationWidget> createState() => _ProjectDurationWidgetState();
}

class _ProjectDurationWidgetState extends State<ProjectDurationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  // Classe pour gérer les durées rapides de manière typée
  

  // Liste typée des durées rapides
  final List<QuickDuration> _quickDurations = const [
    QuickDuration(days: 90, label: '3 mois', emoji: '⚡'),
    QuickDuration(days: 180, label: '6 mois', emoji: '📅'),
    QuickDuration(days: 270, label: '9 mois', emoji: '🌱'),
    QuickDuration(days: 365, label: '1 an', emoji: '📊'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: AppConstants.primaryColor,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)), // 3 ans dans le futur
    );
    
    if (picked != null && picked != widget.startDate) {
      // Animation de transition
      _animationController.reverse().then((_) {
        widget.onStartDateChanged(picked);
        // Ajuster automatiquement la date de récolte si nécessaire
        if (picked.isAfter(widget.harvestDate)) {
          widget.onHarvestDateChanged(picked.add(const Duration(days: 180)));
        }
        _animationController.forward();
      });
    }
  }

  Future<void> _selectHarvestDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.harvestDate,
      firstDate: widget.startDate.add(const Duration(days: 30)), // Au moins 30 jours après le début
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)), // 3 ans dans le futur
    );
    
    if (picked != null && picked != widget.harvestDate) {
      _animationController.reverse().then((_) {
        widget.onHarvestDateChanged(picked);
        _animationController.forward();
      });
    }
  }

  int get _totalDuration {
    return widget.harvestDate.difference(widget.startDate).inDays;
  }

  int get _durationInMonths {
    return (_totalDuration / 30).round();
  }

  String get _durationCategory {
    if (_totalDuration < 90) return 'Court terme';
    if (_totalDuration < 180) return 'Moyen terme';
    return 'Long terme';
  }

  Color get _durationColor {
    if (_totalDuration < 90) return Colors.green;
    if (_totalDuration < 180) return Colors.orange;
    return Colors.red;
  }

  String get _durationEmoji {
    if (_totalDuration < 90) return '⚡';
    if (_totalDuration < 180) return '📅';
    return '🌱';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDurationText() {
    if (_durationInMonths < 1) {
      return '$_totalDuration jours';
    } else if (_durationInMonths == 1) {
      return '1 mois';
    } else {
      return '$_durationInMonths mois';
    }
  }

  void _quickSelectDuration(int days) {
    _animationController.reverse().then((_) {
      final newHarvestDate = widget.startDate.add(Duration(days: days));
      widget.onHarvestDateChanged(newHarvestDate);
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Durée du projet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Duration Selection
          _buildQuickDurationSelector(),
          
          const SizedBox(height: 16),
          
          // Start Date
          _buildDateSelector(
            label: 'Date de début',
            date: widget.startDate,
            icon: Icons.calendar_today_outlined,
            onTap: _selectStartDate,
            isStartDate: true,
          ),
          
          const SizedBox(height: 16),
          
          // Harvest Date
          _buildDateSelector(
            label: 'Date de récolte estimée',
            date: widget.harvestDate,
            icon: Icons.agriculture_outlined,
            onTap: _selectHarvestDate,
            isStartDate: false,
          ),
          
          const SizedBox(height: 16),
          
          // Duration Summary avec animations
          _buildDurationSummary(),
        ],
      ),
    );
  }

  Widget _buildQuickDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Durées recommandées',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.textColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickDurations.map((duration) {
            final isSelected = _totalDuration == duration.days;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(duration.emoji),
                    const SizedBox(width: 4),
                    Text(duration.label),
                  ],
                ),
                onSelected: (selected) {
                  _quickSelectDuration(duration.days);
                },
                backgroundColor: Colors.white,
                selectedColor: AppConstants.primaryColor.withOpacity(0.1),
                checkmarkColor: AppConstants.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? AppConstants.primaryColor : AppConstants.textColor,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required IconData icon,
    required VoidCallback onTap,
    required bool isStartDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor.withOpacity(0.8),
              ),
            ),
            if (!isStartDate) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _durationColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _durationCategory,
                  style: TextStyle(
                    fontSize: 10,
                    color: _durationColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _colorAnimation.value ?? Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                    icon,
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
                        _formatDate(date),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      if (!isStartDate) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${_totalDuration} jours après le début',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppConstants.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSummary() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _durationColor.withOpacity(0.05),
            AppConstants.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _durationColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _durationEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Durée totale',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _durationCategory,
                        style: TextStyle(
                          fontSize: 12,
                          color: _durationColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                _getDurationText(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _durationColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _totalDuration / 365, // Progression sur une année
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_durationColor),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Court terme',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                ),
              ),
              Text(
                'Moyen terme',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange,
                ),
              ),
              Text(
                'Long terme',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}