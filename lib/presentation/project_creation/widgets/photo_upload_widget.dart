import 'package:agridash/core/app_export.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadWidget extends StatefulWidget {
  final List<String> images;
  final Function(List<String>) onImagesChanged;
  final Future<void> Function()? onPickImages;
  final Function(int)? onRemove;

  const PhotoUploadWidget({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.onPickImages,
    this.onRemove,
  });

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  final int _maxImages = 5;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImagesInternal() async {
    if (widget.images.length >= _maxImages) {
      NavigationService().showErrorDialog('Maximum $_maxImages images autorisées');
      return;
    }

    final picked = await _picker.pickMultiImage(imageQuality: 70);
    if (picked.isEmpty) return;

    final List<String> newImages = [];
    for (final file in picked) {
      final bytes = await file.readAsBytes();
      final base64Image = 'data:image/${file.path.split('.').last};base64,${base64Encode(bytes)}';
      newImages.add(base64Image);
    }

    final updatedList = [...widget.images, ...newImages];
    widget.onImagesChanged(updatedList);
  }

  void _removeImageInternal(int index) {
    final updatedList = List<String>.from(widget.images)..removeAt(index);
    widget.onImagesChanged(updatedList);
    widget.onRemove?.call(index);
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: widget.images.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.images.length) {
              return GestureDetector(
                onTap: widget.onPickImages ?? _pickImagesInternal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 32, color: Colors.grey),
                      SizedBox(height: 4),
                      Text('Ajouter', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              children: [
                GestureDetector(
                  onTap: () => _viewImage(widget.images[index]),
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
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImageInternal(index),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _viewImage(String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => NavigationService().goBack(),
                ),
              ],
            ),
            Image.network(url, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
