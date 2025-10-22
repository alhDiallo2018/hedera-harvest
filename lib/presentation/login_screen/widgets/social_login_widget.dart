import 'package:agridash/core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  void _handleSocialLogin(String provider) {
    NavigationService().showErrorDialog(
      'Connexion $provider en cours de développement. Utilisez les comptes de démonstration pour tester l\'application.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ou continuer avec',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Social Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              'Google',
              Icons.g_mobiledata,
              () => _handleSocialLogin('Google'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              'Apple',
              Icons.apple,
              () => _handleSocialLogin('Apple'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              'Facebook',
              Icons.facebook,
              () => _handleSocialLogin('Facebook'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}