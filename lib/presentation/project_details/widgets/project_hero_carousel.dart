import 'package:agridash/core/app_export.dart';

class ProjectHeroCarousel extends StatefulWidget {
  final CropProject project;
  final VoidCallback onBack;

  const ProjectHeroCarousel({
    super.key,
    required this.project,
    required this.onBack,
  });

  @override
  State<ProjectHeroCarousel> createState() => _ProjectHeroCarouselState();
}

class _ProjectHeroCarouselState extends State<ProjectHeroCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-slide toutes les 3 secondes
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final images = widget.project.imageUrls.isNotEmpty
          ? widget.project.imageUrls
          : ['https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800'];

      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.project.imageUrls.isNotEmpty
        ? widget.project.imageUrls
        : ['https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800'];

    debugPrint('🖼️ Nombre d’images dans le carrousel: ${images.length}');
    debugPrint('🔗 URLs des images: $images');

    return Stack(
      children: [
        // Carrousel d’images
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
              },
            );
          },
        ),

        // Dégradé sombre pour lisibilité
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Bouton retour
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.onBack,
            ),
          ),
        ),

        // Indicateurs de pages
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 10 : 8,
                  height: isActive ? 10 : 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
