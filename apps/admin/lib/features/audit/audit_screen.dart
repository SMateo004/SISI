import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/server_table.dart';

/// Auditoría del panel (ADR-0041): quién hizo qué, sobre qué, con qué motivo y cuándo.
class AuditScreen extends ConsumerStatefulWidget {
  const AuditScreen({super.key});

  @override
  ConsumerState<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends ConsumerState<AuditScreen> {
  final _action = TextEditingController();
  final _target = TextEditingController();
  ({String? action, String? targetId}) _filters = (
    action: null,
    targetId: null,
  );

  @override
  void dispose() {
    _action.dispose();
    _target.dispose();
    super.dispose();
  }

  void _apply() {
    String? clean(String v) => v.trim().isEmpty ? null : v.trim();
    setState(
      () => _filters = (
        action: clean(_action.text),
        targetId: clean(_target.text),
      ),
    );
  }

  void _show(AuditEntryDto e) {
    const encoder = JsonEncoder.withIndent('  ');
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(e.action),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow('Cuándo', formatDateTime(e.createdAt)),
                InfoRow('Admin', '${e.adminName ?? ''} ${e.adminPhone}'),
                InfoRow('Objetivo', '${e.targetType} ${e.targetId}'),
                InfoRow('Motivo', e.reason ?? '—'),
                InfoRow(
                  'IP',
                  '${e.ip ?? '—'}${e.forwardedFor == null ? '' : ' (X-Forwarded-For: ${e.forwardedFor})'}',
                ),
                const SizedBox(height: 8),
                const Text('Antes'),
                SelectableText(
                  e.before == null ? '—' : encoder.convert(e.before),
                ),
                const SizedBox(height: 8),
                const Text('Después'),
                SelectableText(
                  e.after == null ? '—' : encoder.convert(e.after),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeader(
        'Auditoría',
        subtitle:
            'Toda acción del panel que cambia algo, de la más nueva a la más vieja',
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 220,
              child: TextField(
                key: const Key('audit-action'),
                controller: _action,
                decoration: const InputDecoration(
                  labelText: 'Acción (ej.: billing.)',
                ),
                onSubmitted: (_) => _apply(),
              ),
            ),
            SizedBox(
              width: 320,
              child: TextField(
                key: const Key('audit-target'),
                controller: _target,
                decoration: const InputDecoration(labelText: 'Id del objetivo'),
                onSubmitted: (_) => _apply(),
              ),
            ),
            OutlinedButton(
              key: const Key('audit-apply'),
              onPressed: _apply,
              child: const Text('Filtrar'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: ServerTable<AuditEntryDto>(
          key: const Key('audit-table'),
          reloadKey: _filters,
          empty: 'No hay registros con esos filtros.',
          load: (cursor) async {
            final res = await ref
                .read(adminApiProvider)
                .adminAuditControllerList(
                  action: _filters.action,
                  targetId: _filters.targetId,
                  cursor: cursor,
                );
            return PageResult(res.data!.items, res.data!.nextCursor);
          },
          onTap: _show,
          columns: [
            ServerColumn('Cuándo', (e) => Text(formatDateTime(e.createdAt))),
            ServerColumn('Admin', (e) => Text(e.adminName ?? e.adminPhone)),
            ServerColumn('Acción', (e) => Text(e.action)),
            ServerColumn(
              'Objetivo',
              (e) => Text('${e.targetType} · ${e.targetId}'),
            ),
            ServerColumn(
              'Motivo',
              (e) => SizedBox(
                width: 280,
                child: Text(
                  e.reason ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
