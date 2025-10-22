import 'package:agridash/core/app_export.dart';

class ProjectTabsView extends StatefulWidget {
  final CropProject project;
  final TabController tabController;
  final VoidCallback onUpdate;

  const ProjectTabsView({
    super.key,
    required this.project,
    required this.tabController,
    required this.onUpdate,
  });

  @override
  State<ProjectTabsView> createState() => _ProjectTabsViewState();
}

class _ProjectTabsViewState extends State<ProjectTabsView> {
  // ignore: unused_field
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: [
        // Details Tab
        _buildDetailsTab(),
        
        // Updates Tab
        _buildUpdatesTab(),
        
        // Investors Tab
        _buildInvestorsTab(),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.project.description,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Project Details
          Text(
            'Détails du Projet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailItem('Type de culture', widget.project.cropType.name),
          _buildDetailItem('Localisation', widget.project.location),
          _buildDetailItem('Date de début', _formatDate(widget.project.startDate)),
          _buildDetailItem('Date de récolte estimée', _formatDate(widget.project.harvestDate)),
          _buildDetailItem('Rendement estimé', '${widget.project.estimatedYield} ${widget.project.yieldUnit}'),
          _buildDetailItem('Investissement total nécessaire', '${widget.project.totalInvestmentNeeded.toStringAsFixed(0)} FCFA'),
          _buildDetailItem('Retour estimé', '${widget.project.estimatedReturns.toStringAsFixed(0)} FCFA'),
          
          const SizedBox(height: 24),
          
          // Farmer Information
          Text(
            'Informations de l\'Agriculteur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.farmerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Agriculteur expérimenté',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatesTab() {
    final updates = widget.project.updates;
    final user = _authService.currentUser;
    final isFarmer = user?.role == UserRole.farmer && user?.id == widget.project.farmerId;

    return Column(
      children: [
        if (isFarmer)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _showAddUpdateDialog,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une mise à jour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        Expanded(
          child: updates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.update,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune mise à jour pour le moment',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppConstants.textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: updates.length,
                  itemBuilder: (context, index) {
                    final update = updates[index];
                    return _buildUpdateItem(update);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInvestorsTab() {
    // For demo purposes, we'll show mock investors
    final mockInvestors = [
      {'name': 'Marie Investisseur', 'amount': 15000, 'date': '2024-01-15'},
      {'name': 'Pierre Capital', 'amount': 10000, 'date': '2024-01-12'},
      {'name': 'Sophie Finance', 'amount': 8000, 'date': '2024-01-10'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockInvestors.length,
      itemBuilder: (context, index) {
        final investor = mockInvestors[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
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
                      investor['name'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Investi le ${investor['date']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${investor['amount']} FCFA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(ProjectUpdate update) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getUpdateTypeColor(update.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getUpdateTypeText(update.type),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getUpdateTypeColor(update.type),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(update.date),
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            update.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            update.description,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          if (update.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: update.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(update.images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddUpdateDialog(
        onUpdateAdded: widget.onUpdate,
        projectId: widget.project.id,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getUpdateTypeColor(UpdateType type) {
    switch (type) {
      case UpdateType.planting:
        return AppConstants.primaryColor;
      case UpdateType.growth:
        return AppConstants.successColor;
      case UpdateType.maintenance:
        return AppConstants.warningColor;
      case UpdateType.harvest:
        return AppConstants.accentColor;
      default:
        return Colors.grey;
    }
  }

  String _getUpdateTypeText(UpdateType type) {
    switch (type) {
      case UpdateType.planting:
        return 'Plantation';
      case UpdateType.growth:
        return 'Croissance';
      case UpdateType.maintenance:
        return 'Maintenance';
      case UpdateType.harvest:
        return 'Récolte';
      default:
        return 'Général';
    }
  }
}

class _AddUpdateDialog extends StatefulWidget {
  final VoidCallback onUpdateAdded;
  final String projectId;

  const _AddUpdateDialog({
    required this.onUpdateAdded,
    required this.projectId,
  });

  @override
  State<_AddUpdateDialog> createState() => __AddUpdateDialogState();
}

class __AddUpdateDialogState extends State<_AddUpdateDialog> {
  final ProjectService _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  UpdateType _selectedType = UpdateType.general;
  final List<String> _images = [];
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _projectService.addProjectUpdate(
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        images: _images,
      );

      setState(() {
        _isSubmitting = false;
      });

      widget.onUpdateAdded();
      NavigationService().goBack();
      NavigationService().showSuccessDialog('Mise à jour ajoutée avec succès !');
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      NavigationService().showErrorDialog('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une mise à jour'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<UpdateType>(
              value: _selectedType,
              items: UpdateType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getUpdateTypeText(type)),
                );
              }).toList(),
              onChanged: (type) {
                if (type != null) {
                  setState(() {
                    _selectedType = type;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Type de mise à jour'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Photo upload section would go here
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => NavigationService().goBack(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitUpdate,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Ajouter'),
        ),
      ],
    );
  }

  String _getUpdateTypeText(UpdateType type) {
    switch (type) {
      case UpdateType.planting:
        return 'Plantation';
      case UpdateType.growth:
        return 'Croissance';
      case UpdateType.maintenance:
        return 'Maintenance';
      case UpdateType.harvest:
        return 'Récolte';
      default:
        return 'Général';
    }
  }
}