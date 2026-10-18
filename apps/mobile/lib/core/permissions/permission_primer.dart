import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Permisos que se explican antes de pedirlos (ADR-0051): el sistema solo pregunta una vez.
enum PrimedPermission { location, camera, notifications }

/// Qué decidió la persona ante la explicación: nada todavía, aceptó o "Ahora no".
enum PrimerAnswer { unknown, accepted, declined }

/// Recuerda las explicaciones ya vistas entre aperturas de la app.
abstract class PrimerStore {
  Future<PrimerAnswer> read(PrimedPermission permission);
  Future<void> write(PrimedPermission permission, PrimerAnswer answer);
}

class SecurePrimerStore implements PrimerStore {
  SecurePrimerStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  String _key(PrimedPermission p) => 'sisi.primer.${p.name}';

  @override
  Future<PrimerAnswer> read(PrimedPermission permission) async {
    final value = await _storage.read(key: _key(permission));
    return PrimerAnswer.values.firstWhere(
      (a) => a.name == value,
      orElse: () => PrimerAnswer.unknown,
    );
  }

  @override
  Future<void> write(PrimedPermission permission, PrimerAnswer answer) =>
      _storage.write(key: _key(permission), value: answer.name);
}

/// Para tests.
class MemoryPrimerStore implements PrimerStore {
  MemoryPrimerStore([Map<PrimedPermission, PrimerAnswer>? initial])
    : answers = {...?initial};

  /// Todas aceptadas: las pantallas no muestran explicaciones (tests que no las prueban).
  factory MemoryPrimerStore.allAccepted() => MemoryPrimerStore({
    for (final p in PrimedPermission.values) p: PrimerAnswer.accepted,
  });

  final Map<PrimedPermission, PrimerAnswer> answers;

  @override
  Future<PrimerAnswer> read(PrimedPermission permission) async =>
      answers[permission] ?? PrimerAnswer.unknown;

  @override
  Future<void> write(PrimedPermission permission, PrimerAnswer answer) async =>
      answers[permission] = answer;
}

final primerStoreProvider = Provider<PrimerStore>((ref) => SecurePrimerStore());

/// Explicación de un permiso, una sola vez (aceptada queda recordada). Devuelve si se puede
/// pedir el permiso del sistema.
Future<bool> explainOnce(
  BuildContext context,
  PrimerStore store,
  PrimedPermission permission, {
  required IconData icon,
  required String title,
  required String message,
  Key? continueKey,
}) async {
  if (await store.read(permission) == PrimerAnswer.accepted) return true;
  if (!context.mounted) return false;
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: Icon(icon),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Ahora no'),
        ),
        FilledButton(
          key: continueKey ?? Key('primer-${permission.name}-continue'),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Continuar'),
        ),
      ],
    ),
  );
  await store.write(
    permission,
    ok == true ? PrimerAnswer.accepted : PrimerAnswer.declined,
  );
  return ok == true;
}
