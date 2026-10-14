import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Foto lista para subir. Tipos permitidos por la API: JPEG, PNG y HEIC hasta 8 MB.
class PickedImage {
  const PickedImage({
    required this.bytes,
    required this.contentType,
    required this.name,
  });

  final Uint8List bytes;
  final String contentType;
  final String name;

  static const maxBytes = 8 * 1024 * 1024;
}

enum ImageOrigin { camera, gallery }

/// Elige una foto de la cámara o la galería y la comprime antes de subirla.
abstract class ImagePickerService {
  Future<PickedImage?> pick(ImageOrigin origin, {bool frontCamera = false});
}

class DeviceImagePicker implements ImagePickerService {
  DeviceImagePicker([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<PickedImage?> pick(
    ImageOrigin origin, {
    bool frontCamera = false,
  }) async {
    final file = await _picker.pickImage(
      source: origin == ImageOrigin.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      preferredCameraDevice: frontCamera
          ? CameraDevice.front
          : CameraDevice.rear,
      // Compresión: lado mayor de 1600 px y calidad 80. En iOS además convierte HEIC a JPEG.
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (file == null) return null;
    return PickedImage(
      bytes: await file.readAsBytes(),
      contentType: contentTypeFor(file.mimeType, file.name),
      name: file.name,
    );
  }
}

/// Deduce el tipo MIME; si no se reconoce se asume JPEG (lo que produce la compresión).
String contentTypeFor(String? mimeType, String name) {
  final mime = mimeType?.toLowerCase();
  if (mime == 'image/png' || mime == 'image/jpeg' || mime == 'image/heic') {
    return mime!;
  }
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
  return 'image/jpeg';
}

final imagePickerProvider = Provider<ImagePickerService>(
  (ref) => DeviceImagePicker(),
);
