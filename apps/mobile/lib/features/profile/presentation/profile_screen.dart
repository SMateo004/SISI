import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/files/image_source_sheet.dart';
import '../../../core/files/picked_image.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../auth/data/auth_repository.dart';
import '../application/current_user.dart';
import '../domain/app_user.dart';
import 'user_avatar.dart';

/// Perfil básico editable: nombre y foto.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : _ProfileForm(user: user),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.user});

  final AppUser user;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  late final _name = TextEditingController(text: widget.user.name ?? '');
  bool _saving = false;
  bool _uploading = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _toast(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _saveName() async {
    final name = _name.text.trim();
    if (name.length < 2) {
      return _toast('El nombre debe tener al menos 2 letras.');
    }
    setState(() => _saving = true);
    try {
      await ref.read(currentUserProvider.notifier).updateName(name);
      _toast('Nombre guardado.');
    } catch (e) {
      _toast(ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePhoto() async {
    final origin = await showImageSourceSheet(context);
    if (origin == null) return;
    final image = await ref
        .read(imagePickerProvider)
        .pick(origin, frontCamera: true);
    if (image == null) return;
    setState(() => _uploading = true);
    try {
      await ref.read(currentUserProvider.notifier).uploadPhoto(image);
      _toast('Foto actualizada.');
    } catch (e) {
      _toast(ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _logout() async {
    final session = ref.read(sessionProvider.notifier);
    final refresh = session.tokens?.refreshToken;
    if (refresh != null) await ref.read(authRepositoryProvider).logout(refresh);
    await session.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value ?? widget.user;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              UserAvatar(user: user, radius: 48),
              IconButton.filled(
                tooltip: 'Cambiar foto',
                onPressed: _uploading ? null : _changePhoto,
                icon: _uploading
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.photo_camera_outlined),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          key: const Key('name-field'),
          controller: _name,
          textCapitalization: TextCapitalization.words,
          maxLength: 60,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _saving ? null : _saveName,
          child: const Text('Guardar nombre'),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('Celular'),
          subtitle: Text(user.phone),
        ),
        ListTile(
          leading: const Icon(Icons.work_outline),
          title: const Text('Verificación de trabajador'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(Routes.workerStatus),
        ),
        ListTile(
          leading: const Icon(Icons.cloud_outlined),
          title: const Text('Estado del servidor'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(Routes.serverStatus),
        ),
        const Divider(height: 32),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
