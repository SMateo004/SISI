import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../data/worker_repository.dart';
import '../domain/worker_models.dart';

/// Estado de la verificación de trabajador y la acción siguiente.
class ReviewStatusScreen extends ConsumerWidget {
  const ReviewStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(workerProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tu verificación')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(workerProfileProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            switch (profile) {
              AsyncData(:final value) => _StatusContent(profile: value),
              AsyncError(:final error) => Text(
                ApiException.from(error).message,
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ],
        ),
      ),
    );
  }
}

class _StatusContent extends StatelessWidget {
  const _StatusContent({required this.profile});

  final WorkerProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, title, body) = switch (profile.status) {
      WorkerStatus.sinSolicitar => (
        Icons.badge_outlined,
        'Verifica tu identidad para trabajar',
        'Necesitamos tu carnet (ambos lados), una selfie, tus categorías y cómo te movilizas.',
      ),
      WorkerStatus.pendienteRevision => (
        Icons.hourglass_top,
        'Tu solicitud está en revisión',
        'Revisaremos tus datos y te avisaremos cuando esté lista. Mientras tanto puedes usar SISI como empleador.',
      ),
      WorkerStatus.rechazado => (
        Icons.report_gmailerrorred,
        'Tu solicitud fue rechazada',
        profile.rejectionReason == null
            ? 'Revisa tus datos y vuelve a enviarla.'
            : 'Motivo: ${profile.rejectionReason}',
      ),
      WorkerStatus.aprobado => (
        Icons.verified,
        '¡Tu verificación fue aprobada!',
        'Activa el modo trabajador con el interruptor de la pantalla principal.',
      ),
      WorkerStatus.bloqueadoDeuda => (
        Icons.payments_outlined,
        'Tienes una comisión pendiente',
        'Paga tu comisión para volver a recibir trabajos. Mientras tanto puedes seguir usando SISI como empleador.',
      ),
      WorkerStatus.suspendidoModeracion => (
        Icons.gpp_maybe_outlined,
        'Tu cuenta de trabajador está suspendida',
        'Estamos revisando un reporte. Mientras tanto puedes seguir usando SISI como empleador.',
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          title,
          key: const Key('status-title'),
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(body, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        if (profile.documents.isNotEmpty) ...[
          Text('Documentos', style: theme.textTheme.titleMedium),
          for (final document in profile.documents)
            ListTile(
              dense: true,
              title: Text(document.type.label),
              trailing: Text(_reviewLabel(document.reviewStatus)),
            ),
          const SizedBox(height: 16),
        ],
        if (profile.editable)
          FilledButton(
            onPressed: () => context.push(Routes.workerOnboarding),
            child: Text(
              profile.status == WorkerStatus.rechazado
                  ? 'Corregir y reenviar'
                  : 'Completa tu verificación',
            ),
          ),
        if (profile.status == WorkerStatus.aprobado)
          FilledButton(
            onPressed: () => context.go(Routes.home),
            child: const Text('Ir al inicio'),
          ),
      ],
    );
  }

  static String _reviewLabel(String status) => switch (status) {
    'aprobado' => 'Aprobado',
    'rechazado' => 'Rechazado',
    _ => 'En revisión',
  };
}
