import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/social_login_widget.dart';

/// Login Screen for agricultural professionals and investors
/// Provides secure authentication with biometric support
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showBiometricPrompt = false;

  // Mock credentials for testing
  final Map<String, Map<String, dynamic>> _mockCredentials = {
    'farmer@agridash.com': {
      'password': 'farmer123',
      'type': 'farmer',
      'name': 'Jean Dupont'
    },
    'investor@agridash.com': {
      'password': 'investor123',
      'type': 'investor',
      'name': 'Marie Martin'
    },
    'admin@agridash.com': {
      'password': 'admin123',
      'type': 'admin',
      'name': 'Pierre Durand'
    },
  };

  @override
  void initState() {
    super.initState();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(email.toLowerCase())) {
      final userCredentials = _mockCredentials[email.toLowerCase()]!;
      if (userCredentials['password'] == password) {
        // Successful login
        HapticFeedback.mediumImpact();

        setState(() {
          _isLoading = false;
          _showBiometricPrompt = true;
        });

        // Show biometric prompt after successful login
        _showBiometricBottomSheet(userCredentials);
        return;
      }
    }

    // Failed login
    setState(() {
      _isLoading = false;
    });

    HapticFeedback.heavyImpact();
    _showErrorDialog('Identifiants incorrects',
        'Veuillez vérifier votre email et mot de passe.');
  }

  void _showBiometricBottomSheet(Map<String, dynamic> userCredentials) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BiometricPromptWidget(
        onBiometricLogin: () => _handleBiometricSetup(userCredentials),
        onSkip: () => _navigateToDashboard(userCredentials),
      ),
    );
  }

  void _handleBiometricSetup(Map<String, dynamic> userCredentials) {
    Navigator.pop(context); // Close bottom sheet
    HapticFeedback.mediumImpact();

    // Simulate biometric setup
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Authentification biométrique activée'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );

    _navigateToDashboard(userCredentials);
  }

  void _navigateToDashboard(Map<String, dynamic> userCredentials) {
    Navigator.pop(context); // Close bottom sheet if open
    
    // Récupérer le type d'utilisateur et le transmettre au dashboard
    final userType = userCredentials['type'] as String;
    final userName = userCredentials['name'] as String;
    
    // Utiliser AppRoutes.dashboardHome au lieu de '/dashboard-home'
    Navigator.pushReplacementNamed(
      context, 
      AppRoutes.dashboardHome, // Utiliser la constante
      arguments: {
        'userType': userType,
        'userName': userName,
      }
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSignUp() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inscription bientôt disponible'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // Header with branding
                const LoginHeaderWidget(),

                SizedBox(height: 4.h),

                // Welcome text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      Text(
                        'Bienvenue',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Connectez-vous à votre compte AgriDash',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Login Form
                LoginFormWidget(
                  onLogin: _handleLogin,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 3.h),

                // Social Login Options
                const SocialLoginWidget(),

                SizedBox(height: 4.h),

                // Sign Up Link
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nouvel utilisateur? ',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleSignUp,
                        child: Text(
                          'S\'inscrire',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}