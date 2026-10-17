import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../../shared/categories/category.dart';
import '../../../shared/dates.dart';
import '../../../shared/money.dart';
import '../application/job_providers.dart';
import '../domain/job_models.dart';

/// Historial de trabajos (R8.3). Como trabajador, con la comisión y el neto de cada uno.
class JobHistoryScreen extends ConsumerWidget {
  const JobHistoryScreen({super.key, required this.role});

  /// worker o employer.
  final String role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(jobHistoryProvider(role));
    return Scaffold(
      appBar: AppBar(title: const Text('Mis trabajos')),
      body: switch (page) {
        AsyncData(:final value) when value.items.isEmpty => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Todavía no tienes trabajos.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(jobHistoryProvider(role));
            await ref.read(jobHistoryProvider(role).future);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: value.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => JobHistoryTile(job: value.items[i]),
          ),
        ),
        AsyncError(:final error) => Center(
          child: Text(ApiException.from(error).message),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class JobHistoryTile extends StatelessWidget {
  const JobHistoryTile({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = job.iAmWorker && job.commissionBs != null
        ? 'Comisión ${formatBs(job.commissionBs!)} · Recibes ${formatBs(job.netBs ?? job.finalPriceBs)}'
        : null;
    return Card(
      key: Key('job-${job.id}'),
      child: ListTile(
        leading: Icon(
          categoryIcon(job.categorySlug),
          color: theme.colorScheme.primary,
        ),
        title: Text('${job.categoryName} · ${formatBs(job.finalPriceBs)}'),
        subtitle: Text(
          [
            '${job.status.label} · ${formatDate(job.timeline.assignedAt)} · ${job.counterpartShortName}',
            ?money,
          ].join('\n'),
        ),
        isThreeLine: money != null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(Routes.job(job.id)),
      ),
    );
  }
}

/// En el inicio: acceso directo al trabajo activo, si hay uno.
class ActiveJobCard extends ConsumerWidget {
  const ActiveJobCard({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(activeJobProvider(role)).value;
    if (job == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Card(
      key: const Key('active-job'),
      color: theme.colorScheme.primaryContainer,
      child: ListTile(
        leading: Icon(categoryIcon(job.categorySlug)),
        title: Text('Trabajo ${job.status.label.toLowerCase()}'),
        subtitle: Text('${job.categoryName} con ${job.counterpartShortName}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(Routes.job(job.id)),
      ),
    );
  }
}
