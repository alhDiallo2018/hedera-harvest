import 'package:agridash/core/app_export.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessModal extends StatelessWidget {
  final String projectTitle;
  final String tokenId;
  final VoidCallback onContinue;

  const SuccessModal({
    super.key,
    required this.projectTitle,
    required this.tokenId,
    required this.onContinue,
  });

  String get _tokenExplorer => 'https://hashscan.io/testnet/token/$tokenId';

  Future<void> _openExplorer() async {
    final uri = Uri.parse(_tokenExplorer);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
          const SizedBox(height: 12),
          Text('Projet créé', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(projectTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SelectableText('Token ID: $tokenId', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            ElevatedButton.icon(
              onPressed: _openExplorer,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Voir sur HashScan'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                // Share link or copy to clipboard
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lien copié !')));
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copier l\'ID'),
            ),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
            onPressed: onContinue,
            child: const Text('Terminer'),
          ),
        ]),
      ),
    );
  }
}
