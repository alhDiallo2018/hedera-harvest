import 'package:agridash/core/app_export.dart';

class ProjectFormHeader extends StatelessWidget implements PreferredSizeWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onBack;
  final Color cropColor;

  const ProjectFormHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onBack,
    required this.cropColor,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentPage + 1) / totalPages;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: onBack,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Créer un projet', style: TextStyle(color: AppConstants.textColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Étape ${currentPage + 1} sur $totalPages', style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(cropColor),
            minHeight: 6,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
