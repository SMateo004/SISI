import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/http/api_client.dart';
import '../../core/realtime/counters.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/server_table.dart';

/// Cola de verificaciones (R1.3, R1.4): de la más antigua a la más nueva.
class VerificationsScreen extends ConsumerWidget {
  const VerificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(countersProvider.select((c) => c.verifications));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          'Verificaciones',
          subtitle: '$pending por revisar, de la más antigua a la más nueva',
        ),
        Expanded(
          child: ServerTable<VerificationRowDto>(
            key: const Key('verifications-table'),
            reloadKey: pending,
            empty: 'No hay solicitudes de trabajador por revisar.',
            load: (cursor) async {
              final res = await ref
                  .read(adminApiProvider)
                  .verificationsControllerQueue(cursor: cursor);
              return PageResult(res.data!.items, res.data!.nextCursor);
            },
            onTap: (row) => context.go('/verificaciones/${row.userId}'),
            columns: [
              ServerColumn(
                'Enviada',
                (r) => Text(formatDateTime(r.submittedAt)),
              ),
              ServerColumn('Nombre', (r) => Text(r.name ?? 'Sin nombre')),
              ServerColumn('Celular', (r) => Text(r.phone)),
              ServerColumn('Ciudad', (r) => Text(r.cityName)),
              ServerColumn('Categorías', (r) => Text(r.categories.join(', '))),
            ],
          ),
        ),
      ],
    );
  }
}
