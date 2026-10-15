import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../matching/presentation/worker_home_panel.dart';
import '../../mode_switch/presentation/mode_switch.dart';
import '../../profile/application/current_user.dart';
import '../../profile/domain/app_user.dart';
import '../../profile/presentation/user_avatar.dart';

/// Pantalla principal: interruptor de modo arriba y contenido según el modo.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SISI'),
        actions: [
          if (user.value != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                tooltip: 'Mi perfil',
                onPressed: () => context.push(Routes.profile),
                icon: UserAvatar(user: user.value!, radius: 16),
              ),
            ),
        ],
      ),
      body: switch (user) {
        AsyncData(:final value?) => _HomeBody(user: value),
        AsyncError(:final error) => _HomeError(
          message: ApiException.from(error).message,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWorker = user.activeMode == ActiveMode.worker;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ModeSwitch(mode: user.activeMode),
        const SizedBox(height: 24),
        Text(
          'Hola, ${user.name?.split(' ').first ?? 'bienvenido'}',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (user.name == null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Completa tu perfil'),
              subtitle: const Text('Agrega tu nombre y tu foto.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.profile),
            ),
          ),
        if (isWorker)
          const WorkerHomePanel()
        else ...[
          // R1.2/R3: solo el modo empleador publica solicitudes.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '¿Qué servicio necesitas?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Publica lo que necesitas y recibe ofertas de trabajadores cerca de ti.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: const Key('new-request'),
                    onPressed: () => context.push(Routes.newRequest),
                    icon: const Icon(Icons.add),
                    label: const Text('Pedir un servicio'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Mis solicitudes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.myRequests),
            ),
          ),
        ],
        if (!isWorker)
          Card(
            child: ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('¿Quieres trabajar en SISI?'),
              subtitle: const Text(
                'Verifica tu identidad y recibe trabajos cerca de ti.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.workerStatus),
            ),
          ),
      ],
    );
  }
}

class _HomeError extends ConsumerWidget {
  const _HomeError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref.invalidate(currentUserProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
