import 'package:agridash/core/app_export.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  // Variables d'état
  UserRole _selectedRole = UserRole.farmer;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        phone: _phoneController.text,
        location: _locationController.text,
      );

      if (result.success) {
        _showSuccessDialog();
      } else {
        setState(() {
          _errorMessage = result.error ?? 'Erreur lors de la création du compte';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppConstants.primaryColor,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Félicitations !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Votre compte a été créé avec succès.\nVous allez être redirigé...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppConstants.textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => NavigationService().toDashboard(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Explorer la plateforme',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header avec effet de vague amélioré
            SliverToBoxAdapter(
              child: _buildEnhancedHeader(),
            ),
            
            // Section type de compte mise en avant
            SliverToBoxAdapter(
              child: _buildRoleSection(),
            ),
            
            // Formulaire
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _buildForm(),
              ),
            ),
            
            // Espace en bas
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withOpacity(0.9),
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Effet de vague
          Positioned.fill(
            child: CustomPaint(
              painter: _EnhancedWavePainter(),
            ),
          ),
          
          // Contenu
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bouton retour
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => NavigationService().goBack(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Titre principal avec meilleur contraste
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commencez votre',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Avenir Agricole',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Sous-titre
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Rejoignez la première plateforme qui connecte agriculteurs et investisseurs',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de section
          Row(
            children: [
              Container(
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Choisissez votre profil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionnez le type de compte qui correspond à vos besoins',
            style: TextStyle(
              color: AppConstants.textColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          
          // Sélecteur de rôle amélioré
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: _buildEnhancedRoleCard(
                      role: UserRole.farmer,
                      title: 'Agriculteur',
                      subtitle: 'Proposer mes projets',
                      icon: Icons.agriculture_rounded,
                      isSelected: _selectedRole == UserRole.farmer,
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildEnhancedRoleCard(
                      role: UserRole.investor,
                      title: 'Investisseur',
                      subtitle: 'Financer des projets',
                      icon: Icons.trending_up_rounded,
                      isSelected: _selectedRole == UserRole.investor,
                      iconColor: Colors.blue,
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

  Widget _buildEnhancedRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : _getGreyColor(context),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icone avec badge de sélection
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppConstants.primaryColor : iconColor,
                    size: 30,
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppConstants.primaryColor,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Titre
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppConstants.textColor,
              ),
            ),
            const SizedBox(height: 4),
            
            // Sous-titre
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white.withOpacity(0.9) : _getGreyColor(context).withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre de section
                _buildFormSectionTitle('Informations personnelles'),
                const SizedBox(height: 20),

                // Champs du formulaire
                _buildFormFields(),

                // Bouton d'inscription
                _buildRegisterButton(),
                const SizedBox(height: 20),

                // Lien vers connexion
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_outline_rounded,
            color: AppConstants.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildModernTextField(
          controller: _nameController,
          label: 'Nom complet *',
          hintText: 'Votre nom complet',
          prefixIcon: Icons.person_outline_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le nom est requis';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        _buildModernTextField(
          controller: _emailController,
          label: 'Adresse email *',
          hintText: 'votre@email.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),
        const SizedBox(height: 16),

        _buildModernTextField(
          controller: _phoneController,
          label: 'Téléphone',
          hintText: '+221 70 123 00 00',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        _buildModernTextField(
          controller: _locationController,
          label: 'Localisation',
          hintText: 'Ville, Région, Pays',
          prefixIcon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),

        _buildModernPasswordField(
          controller: _passwordController,
          label: 'Mot de passe *',
          hintText: 'Minimum 6 caractères',
          obscureText: _obscurePassword,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          validator: _validatePassword,
        ),
        const SizedBox(height: 16),

        _buildModernPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirmer le mot de passe *',
          hintText: 'Répétez votre mot de passe',
          obscureText: _obscureConfirmPassword,
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: AppConstants.textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: _getGreyColor(context)),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(prefixIcon, color: _getGreyColor(context)),
            ),
            filled: true,
            fillColor: _getGreyColor(context).withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(color: AppConstants.textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: _getGreyColor(context)),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(Icons.lock_outline, color: _getGreyColor(context)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: _getGreyColor(context),
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: _getGreyColor(context).withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        if (_errorMessage != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppConstants.primaryColor.withOpacity(0.3),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Créer mon compte',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte ? ',
          style: TextStyle(
            color: AppConstants.textColor.withOpacity(0.6),
          ),
        ),
        GestureDetector(
          onTap: () => NavigationService().toLogin(),
          child: Text(
            'Se connecter',
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Méthode pour résoudre l'erreur const_eval_property_access
  Color _getGreyColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey[400]!
        : Colors.grey[600]!;
  }
}

class _EnhancedWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.7,
        size.width,
        size.height * 0.6,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Seconde vague pour plus de profondeur
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.65,
        size.width * 0.6,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.8,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}