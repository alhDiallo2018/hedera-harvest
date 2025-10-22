import 'package:agridash/core/app_export.dart';

import 'widgets/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  UserRole _selectedRole = UserRole.farmer;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Demo credentials for testing
    _emailController.text = 'farmer@agrosense.com';
    _passwordController.text = 'password123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        NavigationService().showSuccessDialog('Connexion réussie !');
        await Future.delayed(const Duration(milliseconds: 1500));
        NavigationService().toDashboard();
      } else {
        NavigationService().showErrorDialog(result['error'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      NavigationService().showErrorDialog('Erreur: $e');
    }
  }

  void _handleRoleChange(UserRole? role) {
    if (role != null) {
      setState(() {
        _selectedRole = role;
      });
      
      // Update demo credentials based on role
      switch (role) {
        case UserRole.farmer:
          _emailController.text = 'farmer@agrosense.com';
          break;
        case UserRole.investor:
          _emailController.text = 'investor@agrosense.com';
          break;
        case UserRole.admin:
          _emailController.text = 'admin@agrosense.com';
          break;
      }
    }
  }

  void _navigateToRegister() {
    // For demo, we'll show a dialog instead of navigation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inscription'),
        content: const Text('Fonctionnalité d\'inscription en cours de développement. Utilisez les comptes de démonstration pour tester l\'application.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const LoginHeaderWidget(),
                
                const SizedBox(height: 32),
                
                // Role Selection
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Je suis :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildRoleButton(UserRole.farmer, 'Agriculteur', '👨‍🌾'),
                          const SizedBox(width: 12),
                          _buildRoleButton(UserRole.investor, 'Investisseur', '💼'),
                          const SizedBox(width: 12),
                          _buildRoleButton(UserRole.admin, 'Admin', '⚙️'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                LoginFormWidget(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }, onLogin: (String email, String password) {  },
                ),
                
                const SizedBox(height: 24),
                
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      ),
                      elevation: 2,
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
                        : const Text(
                            'Se connecter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Forgot Password
                TextButton(
                  onPressed: () {
                    NavigationService().showErrorDialog('Fonctionnalité de réinitialisation de mot de passe en cours de développement.');
                  },
                  child: Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Social Login
                const SocialLoginWidget(),
                
                const SizedBox(height: 32),
                
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nouveau sur AgroSense ? ',
                      style: TextStyle(
                        color: AppConstants.textColor.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: Text(
                        'Créer un compte',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(UserRole role, String label, String emoji) {
    final isSelected = _selectedRole == role;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleRoleChange(role),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppConstants.primaryColor.withOpacity(0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppConstants.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppConstants.primaryColor : AppConstants.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}