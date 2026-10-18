import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/files/download.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/http/api_error.dart';
import '../../core/realtime/counters.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';
import '../../core/widgets/server_table.dart';
import 'billing_dialogs.dart';

const _tabs = [
  ('periodos', 'Periodos'),
  ('vencidos', 'Vencidos'),
  ('comprobantes', 'Comprobantes'),
  ('qr', 'QR de cobro'),
  ('exportar', 'Exportar'),
];

ChipTone periodTone(String status) => switch (status) {
  'pagado' => ChipTone.ok,
  'vencido' => ChipTone.bad,
  'cerrado_pendiente' => ChipTone.warn,
  _ => ChipTone.neutral,
};

/// Cobros (R7, R8): periodos, vencidos, comprobantes, QR y exportación para el contador.
class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key, required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context) {
    final body = switch (tab) {
      'vencidos' => const _Overdue(),
      'comprobantes' => const _Submissions(),
      'qr' => const _Qr(),
      'exportar' => const _Export(),
      _ => const _Periods(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader('Cobros'),
        SectionTabs(
          tabs: _tabs,
          current: tab,
          onSelect: (t) => context.go('/cobros/$t'),
        ),
        const SizedBox(height: 8),
        Expanded(child: body),
      ],
    );
  }
}

class _Periods extends ConsumerStatefulWidget {
  const _Periods();

  @override
  ConsumerState<_Periods> createState() => _PeriodsState();
}

class _PeriodsState extends ConsumerState<_Periods> {
  String? _status;
  final _week = TextEditingController();
  String? _weekFilter;

  @override
  void dispose() {
    _week.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Wrap(
          spacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownButton<String?>(
              key: const Key('periods-status'),
              value: _status,
              hint: const Text('Todos los estados'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Todos los estados')),
                DropdownMenuItem(value: 'abierto', child: Text('Abiertos')),
                DropdownMenuItem(
                  value: 'cerrado_pendiente',
                  child: Text('Por pagar'),
                ),
                DropdownMenuItem(value: 'vencido', child: Text('Vencidos')),
                DropdownMenuItem(value: 'pagado', child: Text('Pagados')),
              ],
              onChanged: (v) => setState(() => _status = v),
            ),
            SizedBox(
              width: 160,
              child: TextField(
                key: const Key('periods-week'),
                controller: _week,
                decoration: const InputDecoration(
                  labelText: 'Semana (2026-W43)',
                ),
                onSubmitted: (v) => setState(
                  () => _weekFilter = v.trim().isEmpty ? null : v.trim(),
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: ServerTable<PanelPeriodDto>(
          key: const Key('periods-table'),
          reloadKey: (_status, _weekFilter),
          empty: 'No hay periodos con esos filtros.',
          load: (cursor) async {
            final res = await ref
                .read(adminApiProvider)
                .adminBillingControllerPeriods(
                  status: _status,
                  week: _weekFilter,
                  cursor: cursor,
                );
            return PageResult(res.data!.items, res.data!.nextCursor);
          },
          onTap: (p) => context.go('/cobros/trabajador/${p.workerId}'),
          columns: [
            ServerColumn(
              'Semana',
              (p) => Text(
                '${formatDate(p.startAt)} al ${formatDate(p.endAt.subtract(const Duration(days: 1)))}',
              ),
            ),
            ServerColumn(
              'Trabajador',
              (p) => Text(p.workerName ?? p.workerPhone),
            ),
            ServerColumn(
              'Referencia',
              (p) => SelectableText(p.paymentReference),
            ),
            ServerColumn(
              'Estado',
              (p) =>
                  StatusChip(p.status.value, tone: periodTone(p.status.value)),
            ),
            ServerColumn(
              'Comisión',
              (p) => Text(formatBs(p.commissionBs)),
              numeric: true,
            ),
            ServerColumn(
              'Saldo',
              (p) => Text(formatBalance(p.balanceBs)),
              numeric: true,
            ),
            ServerColumn('Vence', (p) => Text(formatDateTime(p.dueAt))),
          ],
        ),
      ),
    ],
  );
}

final overdueProvider = FutureProvider.autoDispose<OverdueListDto>((ref) async {
  final res = await ref.watch(adminApiProvider).adminBillingControllerOverdue();
  return res.data!;
});

class _Overdue extends ConsumerWidget {
  const _Overdue();

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(overdueProvider),
    onRetry: () => ref.invalidate(overdueProvider),
    data: (list) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        Text(
          'Total vencido: ${formatBs(list.totalBs)}',
          key: const Key('overdue-total'),
        ),
        const SizedBox(height: 8),
        if (list.items.isEmpty) const Text('No hay periodos vencidos.'),
        for (final p in list.items)
          Card(
            child: ListTile(
              title: Text(
                '${p.workerName ?? p.workerPhone} · ${formatBs(p.balanceBs)}',
              ),
              subtitle: Text(
                '${p.paymentReference} · ${p.daysLate} días de atraso · ${p.workerStatus.replaceAll('_', ' ')}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/cobros/trabajador/${p.workerId}'),
            ),
          ),
      ],
    ),
  );
}

final submissionsProvider = FutureProvider.autoDispose
    .family<List<AdminPaymentSubmissionDto>, String>((ref, status) async {
      final res = await ref
          .watch(adminApiProvider)
          .adminBillingControllerSubmissions(status: status);
      return res.data!;
    });

class _Submissions extends ConsumerStatefulWidget {
  const _Submissions();

  @override
  ConsumerState<_Submissions> createState() => _SubmissionsState();
}

class _SubmissionsState extends ConsumerState<_Submissions> {
  String _status = 'pendiente';

  Future<void> _register(AdminPaymentSubmissionDto s) async {
    final result = await registerPaymentFlow(
      context,
      ref,
      workerId: s.workerId,
      submission: s,
    );
    if (result != null && mounted) {
      showDone(
        context,
        'Pago registrado. Saldo: ${formatBalance(result.balanceBs)}.',
      );
      ref.invalidate(submissionsProvider(_status));
      ref.read(countersProvider.notifier).refresh();
    }
  }

  Future<void> _reject(AdminPaymentSubmissionDto s) async {
    final ok = await confirmAction<bool>(
      context,
      title: 'Rechazar comprobante',
      message: 'El trabajador ve el motivo y puede enviar otro.',
      confirmLabel: 'Rechazar',
      destructive: true,
      noteLabel: 'Motivo para el trabajador',
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .adminBillingControllerRejectSubmission(
              id: s.id,
              rejectSubmissionDto: RejectSubmissionDto(note: input.note),
            );
        return true;
      },
    );
    if (ok == true && mounted) {
      ref.invalidate(submissionsProvider(_status));
      ref.read(countersProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    children: [
      DropdownButton<String>(
        value: _status,
        items: const [
          DropdownMenuItem(value: 'pendiente', child: Text('Pendientes')),
          DropdownMenuItem(value: 'registrado', child: Text('Registrados')),
          DropdownMenuItem(value: 'rechazado', child: Text('Rechazados')),
        ],
        onChanged: (v) => setState(() => _status = v ?? 'pendiente'),
      ),
      AsyncBody(
        value: ref.watch(submissionsProvider(_status)),
        onRetry: () => ref.invalidate(submissionsProvider(_status)),
        data: (list) => list.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No hay comprobantes.'),
              )
            : Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final s in list)
                    SizedBox(
                      width: 320,
                      child: Card(
                        key: Key('submission-${s.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatDateTime(s.createdAt)} · ${s.declaredAmountBs == null ? 'sin monto' : formatBs(s.declaredAmountBs!)}',
                              ),
                              Text(
                                s.workerName == null
                                    ? s.workerPhone
                                    : '${s.workerName} · ${s.workerPhone}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              if (s.note != null) Text(s.note!),
                              if (s.reviewNote != null)
                                Text('Rechazo: ${s.reviewNote}'),
                              const SizedBox(height: 8),
                              Image.network(
                                s.receiptUrl,
                                height: 260,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) =>
                                    const Text('No se pudo cargar la imagen.'),
                              ),
                              // Wrap: en una tarjeta angosta los botones bajan de línea.
                              Wrap(
                                spacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () => context.go(
                                      '/cobros/trabajador/${s.workerId}',
                                    ),
                                    child: const Text('Ver cobros'),
                                  ),
                                  if (s.status.value == 'pendiente') ...[
                                    TextButton(
                                      key: Key('submission-reject-${s.id}'),
                                      onPressed: () => _reject(s),
                                      child: const Text('Rechazar'),
                                    ),
                                    FilledButton(
                                      key: Key('submission-register-${s.id}'),
                                      onPressed: () => _register(s),
                                      child: const Text('Registrar pago'),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    ],
  );
}

final qrProvider = FutureProvider.autoDispose<String?>((ref) async {
  final res = await ref
      .watch(adminApiProvider)
      .adminBillingControllerCurrentQr();
  return res.data?.qrUrl;
});

class _Qr extends ConsumerWidget {
  const _Qr();

  Future<void> _upload(BuildContext context, WidgetRef ref) async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
    );
    if (file == null || !context.mounted) return;
    final bytes = await file.readAsBytes();
    final type =
        file.mimeType ??
        (file.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg');
    if (!context.mounted) return;
    final ok = await confirmAction<bool>(
      context,
      title: 'Cambiar el QR de cobro',
      message:
          'Los trabajadores verán este QR en "Pagar comisión". Revisa que sea el de la cuenta de la empresa.',
      confirmLabel: 'Guardar QR',
      noteRequired: false,
      noteLabel: 'Nota',
      onConfirm: (_) async {
        final api = ref.read(adminApiProvider);
        final upload = (await api.adminBillingControllerQrUploadUrl(
          fileUploadDto: FileUploadDto(
            contentType: type,
            sizeBytes: bytes.length,
          ),
        )).data!;
        await _put(upload, bytes, type);
        await api.adminBillingControllerSetQr(
          setQrDto: SetQrDto(key: upload.key),
        );
        return true;
      },
    );
    if (ok == true) ref.invalidate(qrProvider);
  }

  static Future<void> _put(
    PresignedUploadDto upload,
    Uint8List bytes,
    String type,
  ) async {
    final headers = <String, dynamic>{'Content-Type': type};
    final extra = upload.headers;
    if (extra is Map) headers.addAll(extra.map((k, v) => MapEntry('$k', v)));
    try {
      await Dio().put<void>(
        upload.uploadUrl,
        data: Stream.value(bytes),
        options: Options(headers: headers),
      );
    } catch (error) {
      throw ApiError(
        'No se pudo subir la imagen: ${ApiError.from(error).message}',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    children: [
      AsyncBody(
        value: ref.watch(qrProvider),
        data: (url) => url == null
            ? const Text('Todavía no hay un QR de cobro.', key: Key('qr-empty'))
            : Align(
                alignment: Alignment.centerLeft,
                child: Image.network(
                  url,
                  key: const Key('qr-image'),
                  height: 320,
                ),
              ),
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.icon(
          key: const Key('qr-upload'),
          onPressed: () => _upload(context, ref),
          icon: const Icon(Icons.upload),
          label: const Text('Subir un QR nuevo'),
        ),
      ),
    ],
  );
}

class _Export extends ConsumerStatefulWidget {
  const _Export();

  @override
  ConsumerState<_Export> createState() => _ExportState();
}

class _ExportState extends ConsumerState<_Export> {
  late DateTimeRange _range = () {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month, now.day),
    );
  }();
  bool _busy = false;
  String? _error;

  Future<void> _download(String kind) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final from = _range.start;
      final to = _range.end.add(const Duration(days: 1));
      final res = await ref
          .read(dioProvider)
          .get<List<int>>(
            '/admin/billing/export/$kind.csv',
            queryParameters: {
              'from': from.toUtc().toIso8601String(),
              'to': to.toUtc().toIso8601String(),
            },
            options: Options(responseType: ResponseType.bytes),
          );
      final name = 'sisi-$kind-${formatDate(from).replaceAll('/', '-')}.csv';
      saveFile(Uint8List.fromList(res.data ?? const []), name, 'text/csv');
      if (mounted) showDone(context, 'Descargado: $name');
    } catch (error) {
      setState(() => _error = ApiError.from(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    children: [
      const Text(
        'CSV para el contador: UTF-8, separado por comas, montos con punto decimal y fechas en la hora local. Cada descarga queda en la auditoría.',
      ),
      const SizedBox(height: 12),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Rango'),
        subtitle: Text(
          '${formatDate(_range.start)} al ${formatDate(_range.end)} (incluido)',
        ),
        trailing: const Icon(Icons.date_range),
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2025),
            lastDate: DateTime.now(),
            initialDateRange: _range,
          );
          if (picked != null) setState(() => _range = picked);
        },
      ),
      Wrap(
        spacing: 12,
        children: [
          FilledButton.icon(
            key: const Key('export-ledger'),
            onPressed: _busy ? null : () => _download('ledger'),
            icon: const Icon(Icons.download),
            label: const Text('Movimientos (ledger)'),
          ),
          OutlinedButton.icon(
            key: const Key('export-payments'),
            onPressed: _busy ? null : () => _download('payments'),
            icon: const Icon(Icons.download),
            label: const Text('Pagos'),
          ),
        ],
      ),
      if (_error != null)
        Text(
          _error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
    ],
  );
}
