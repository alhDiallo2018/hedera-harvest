import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectHeroCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> semanticLabels;

  const ProjectHeroCarousel({
    super.key,
    required this.imageUrls,
    required this.semanticLabels,
  });

  @override
  State<ProjectHeroCarousel> createState() => _ProjectHeroCarouselState();
}

class _ProjectHeroCarouselState extends State<ProjectHeroCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: double.infinity,
      child: Stack(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 30.h,
              viewportFraction: 1.0,
              enableInfiniteScroll: widget.imageUrls.length > 1,
              autoPlay: false,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: widget.imageUrls.asMap().entries.map((entry) {
              final index = entry.key;
              final imageUrl = entry.value;
              final semanticLabel = index < widget.semanticLabels.length
                  ? widget.semanticLabels[index]
                  : 'Agricultural project image';

              return GestureDetector(
                onTap: () =>
                    _showFullScreenImage(context, imageUrl, semanticLabel),
                child: Container(
                  width: double.infinity,
                  child: CustomImageWidget(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 30.h,
                    fit: BoxFit.cover,
                    semanticLabel: semanticLabel,
                  ),
                ),
              );
            }).toList(),
          ),

          // Image indicators
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageUrls.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Navigation arrows for larger screens
          if (widget.imageUrls.length > 1 &&
              MediaQuery.of(context).size.width > 600)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _carouselController.previousPage(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'chevron_left',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

          if (widget.imageUrls.length > 1 &&
              MediaQuery.of(context).size.width > 600)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _carouselController.nextPage(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, String imageUrl, String semanticLabel) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.contain,
                  semanticLabel: semanticLabel,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
