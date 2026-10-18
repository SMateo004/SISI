import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/server_table.dart';

/// Búsqueda de usuarios por teléfono o nombre.
class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _q = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _q.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => setState(() => _query = value.trim()),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeader('Usuarios'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          key: const Key('users-search'),
          controller: _q,
          onChanged: _onChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Celular o nombre',
          ),
        ),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: ServerTable<UserRowDto>(
          key: const Key('users-table'),
          reloadKey: _query,
          empty: 'Nadie coincide con la búsqueda.',
          load: (cursor) async {
            final res = await ref
                .read(adminApiProvider)
                .adminUsersControllerSearch(
                  q: _query.isEmpty ? null : _query,
                  cursor: cursor,
                );
            return PageResult(res.data!.items, res.data!.nextCursor);
          },
          onTap: (u) => context.go('/usuarios/${u.id}'),
          columns: [
            ServerColumn('Nombre', (u) => Text(u.name ?? 'Sin nombre')),
            ServerColumn('Celular', (u) => Text(u.phone)),
            ServerColumn('Ciudad', (u) => Text(u.cityName)),
            ServerColumn(
              'Modo',
              (u) => Text(
                u.activeMode.value == 'worker' ? 'Trabajador' : 'Empleador',
              ),
            ),
            ServerColumn(
              'Trabajador',
              (u) => u.workerStatus == null
                  ? const Text('—')
                  : StatusChip(
                      u.workerStatus!,
                      tone: workerTone(u.workerStatus!),
                    ),
            ),
            ServerColumn(
              'Revisar',
              (u) => u.flagged
                  ? const StatusChip('marcado', tone: ChipTone.bad)
                  : const Text(''),
            ),
            ServerColumn('Alta', (u) => Text(formatDate(u.createdAt))),
          ],
        ),
      ),
    ],
  );
}

ChipTone workerTone(String status) => switch (status) {
  'aprobado' => ChipTone.ok,
  'pendiente_revision' => ChipTone.warn,
  'bloqueado_deuda' || 'suspendido_moderacion' || 'rechazado' => ChipTone.bad,
  _ => ChipTone.neutral,
};
