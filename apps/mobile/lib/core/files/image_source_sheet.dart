import 'package:flutter/material.dart';

import 'picked_image.dart';

/// Pregunta si la foto sale de la cámara o de la galería.
Future<ImageOrigin?> showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageOrigin>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Tomar foto'),
            onTap: () => Navigator.of(sheetContext).pop(ImageOrigin.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Elegir de la galería'),
            onTap: () => Navigator.of(sheetContext).pop(ImageOrigin.gallery),
          ),
        ],
      ),
    ),
  );
}
