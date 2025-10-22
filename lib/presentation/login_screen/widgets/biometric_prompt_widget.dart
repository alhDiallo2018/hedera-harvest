import 'package:agridash/core/app_export.dart';

class BiometricPromptWidget extends StatefulWidget {
  const BiometricPromptWidget({super.key});

  @override
  State<BiometricPromptWidget> createState() => _BiometricPromptWidgetState();
}

class _BiometricPromptWidgetState extends State<BiometricPromptWidget> {
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate biometric check
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _handleBiometricAuth() {
    NavigationService().showSuccessDialog('Authentification biométrique simulée avec succès !');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        
        GestureDetector(
          onTap: _handleBiometricAuth,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.fingerprint,
              size: 30,
              color: AppConstants.primaryColor,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Utiliser l\'empreinte',
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}