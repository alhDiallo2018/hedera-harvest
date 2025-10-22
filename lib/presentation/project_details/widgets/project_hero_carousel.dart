import 'package:agridash/core/app_export.dart';

class ProjectHeroCarousel extends StatelessWidget {
  final CropProject project;
  final VoidCallback onBack;

  const ProjectHeroCarousel({
    super.key,
    required this.project,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final images = project.imageUrls.isNotEmpty 
        ? project.imageUrls 
        : ['https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800'];

    return Stack(
      children: [
        // Image Carousel
        PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
        
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
        ),
        
        // Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              iconSize: 20,
            ),
          ),
        ),
        
        // Image Indicator
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}