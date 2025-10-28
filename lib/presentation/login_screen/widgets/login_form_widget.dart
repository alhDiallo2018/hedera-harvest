import 'package:agridash/core/app_export.dart';

class LoginFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required Null Function(String email, String password) onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Field
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Adresse email',
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: 'votre@email.com',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre email';
            }
            if (!value.contains('@')) {
              return 'Veuillez entrer un email valide';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Password Field
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Entrez votre mot de passe',
            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre mot de passe';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
        ),

        const SizedBox(height: 8),

        // Demo Credentials Hint
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Utilisez le mot de passe correspondant au rôle (ex. : farmer123, admin123, investor123) pour accéder aux comptes de démonstration.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
