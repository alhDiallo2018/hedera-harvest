import 'package:agridash/core/app_export.dart';

class PhotoUploadWidget extends StatefulWidget {
  final List<String> images;
  final Function(List<String>) onImagesChanged;

  const PhotoUploadWidget({
    super.key,
    required this.images,
    required this.onImagesChanged,
  });

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  final int _maxImages = 5;

  void _addImage() {
    if (widget.images.length >= _maxImages) {
      NavigationService().showErrorDialog('Maximum $_maxImages images autorisées');
      return;
    }

    // Simulate image selection
    final newImage = 'https://images.unsplash.com/photo-${1500000 + widget.images.length * 100000}?w=500';
    
    setState(() {
      widget.images.add(newImage);
    });
    widget.onImagesChanged(widget.images);
  }

  void _removeImage(int index) {
    setState(() {
      widget.images.removeAt(index);
    });
    widget.onImagesChanged(widget.images);
  }

  void _viewImage(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () => NavigationService().goBack(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Image.network(
              widget.images[index],
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos du projet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Ajoutez des photos de votre ferme ou de cultures précédentes (${widget.images.length}/$_maxImages)',
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.textColor.withOpacity(0.6),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Image Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: widget.images.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.images.length) {
              return _buildAddImageButton();
            }
            return _buildImageItem(index);
          },
        ),
        
        const SizedBox(height: 8),
        
        // Upload Tips
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: Colors.orange.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Les projets avec des photos de qualité ont 3 fois plus de chances d\'être financés',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _addImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.none,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 32, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              'Ajouter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _viewImage(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(widget.images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        
        // Remove Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}