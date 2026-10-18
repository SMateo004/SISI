import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../permissions/permission_primer.dart';
import 'picked_image.dart';

/// Pregunta si la foto sale de la cámara o de la galería. La primera vez que se elige la
/// cámara se explica para qué (ADR-0051) antes de que el sistema pida el permiso.
Future<ImageOrigin?> showImageSourceSheet(BuildContext context) async {
  final origin = await showModalBottomSheet<ImageOrigin>(
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
  if (origin != ImageOrigin.camera || !context.mounted) return origin;
  final ok = await explainOnce(
    context,
    ProviderScope.containerOf(context).read(primerStoreProvider),
    PrimedPermission.camera,
    icon: Icons.photo_camera_outlined,
    title: 'Tu cámara',
    message:
        'Usamos la cámara solo para las fotos que tú tomas: tu carnet y tu selfie para '
        'verificarte, la foto de perfil, las fotos de una solicitud y el comprobante de pago.',
  );
  return ok ? origin : null;
}
