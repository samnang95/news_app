import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

/// Image picker field widget
class ImagePickerField extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final VoidCallback onPickImage;
  final VoidCallback? onRemoveImage;
  final String? labelText;
  final String? errorText;

  const ImagePickerField({
    super.key,
    this.selectedImage,
    this.imageUrl,
    required this.onPickImage,
    this.onRemoveImage,
    this.labelText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onPickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            if ((selectedImage != null ||
                    (imageUrl != null && imageUrl!.isNotEmpty)) &&
                onRemoveImage != null) ...[
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onRemoveImage,
                child: const Text('Remove'),
              ),
            ],
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildImagePreview(context),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    if (selectedImage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedImage!.path.split('/').last,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              selectedImage!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No image selected',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}


