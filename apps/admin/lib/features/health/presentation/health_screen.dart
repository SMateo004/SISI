import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../data/health_repository.dart';

/// Pantalla inicial de la Fase 0: muestra si la API está disponible.
class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SISI · Administración')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Estado del servidor',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              health.when(
                loading: () => const _StatusTile(
                  icon: Icons.hourglass_top,
                  title: 'Verificando…',
                ),
                error: (_, _) => const _StatusTile(
                  icon: Icons.cloud_off,
                  title: 'Sin conexión',
                  subtitle: 'No se pudo contactar con la API.',
                  isError: true,
                ),
                data: (status) => _HealthDetails(status: status),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: health.isLoading
                    ? null
                    : () => ref.invalidate(healthStatusProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
              const SizedBox(height: 16),
              Text(
                'API: ${Env.apiUrl} · Ambiente: ${Env.appEnv}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthDetails extends StatelessWidget {
  const _HealthDetails({required this.status});

  final HealthStatus status;

  @override
  Widget build(BuildContext context) {
    final postgis = status.postgisVersion == null
        ? 'PostGIS'
        : 'PostGIS ${status.postgisVersion}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatusTile(
          icon: status.ok ? Icons.check_circle : Icons.warning_amber,
          title: status.ok ? 'Conectado' : 'Servicio con problemas',
          isError: !status.ok,
        ),
        const Divider(),
        _CheckRow(label: 'Base de datos', up: status.database),
        _CheckRow(label: postgis, up: status.postgis),
        _CheckRow(label: 'Redis', up: status.redis),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isError ? scheme.error : scheme.primary;
    return ListTile(
      leading: Icon(icon, color: color, size: 32),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle == null ? null : Text(subtitle!),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.up});

  final String label;
  final bool up;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(
        up ? 'Operativo' : 'Caído',
        style: TextStyle(color: up ? scheme.primary : scheme.error),
      ),
    );
  }
}
