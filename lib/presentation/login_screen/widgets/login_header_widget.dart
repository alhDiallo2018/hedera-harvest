import 'package:agridash/core/app_export.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => NavigationService().goBack(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.eco,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Title
        Text(
          'Bienvenue',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Connectez-vous à votre compte AgroSense',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppConstants.textColor.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}