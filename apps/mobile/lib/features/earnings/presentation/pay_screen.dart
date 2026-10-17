import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/image_source_sheet.dart';
import '../../../core/files/picked_image.dart';
import '../../../core/http/api_exception.dart';
import '../../../shared/dates.dart';
import '../../../shared/money.dart';
import '../application/earnings_providers.dart';
import '../data/earnings_repository.dart';
import '../domain/earnings_models.dart';

/// "Pagar comisión" (R7.4): QR de la empresa, monto exacto, referencia para la glosa e
/// instrucciones. El comprobante es opcional y queda pendiente de verificación.
class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key});

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  bool _uploading = false;

  Future<void> _copy(String text, String done) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
    }
  }

  Future<void> _sendReceipt(PayInfo info) async {
    final origin = await showImageSourceSheet(context);
    if (origin == null) return;
    final image = await ref.read(imagePickerProvider).pick(origin);
    if (image == null || !mounted) return;
    setState(() => _uploading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(earningsRepositoryProvider)
          .submitReceipt(
            image,
            declaredAmountBs: isPositiveAmount(info.catchUpAmountBs)
                ? info.catchUpAmountBs
                : null,
          );
      ref.invalidate(submissionsProvider);
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Enviamos tu comprobante. Te avisamos cuando lo verifiquemos.',
          ),
        ),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(payInfoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pagar comisión')),
      body: switch (info) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(payInfoProvider);
            await ref.read(payInfoProvider.future);
          },
          child: _body(value),
        ),
        AsyncError(:final error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              ApiException.from(error).message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _body(PayInfo info) {
    final theme = Theme.of(context);
    final catchUp = isPositiveAmount(info.catchUpAmountBs);
    final unlock = isPositiveAmount(info.unlockAmountBs);
    final reference = info.paymentReference;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!catchUp && !unlock && !isPositiveAmount(info.totalBalanceBs))
          const Card(
            child: ListTile(
              leading: Icon(Icons.verified_outlined),
              title: Text('Estás al día'),
              subtitle: Text('No tienes comisiones pendientes.'),
            ),
          ),
        if (catchUp)
          _AmountCard(
            key: const Key('amount-catch-up'),
            title: 'Para ponerte al día',
            amountBs: info.catchUpAmountBs,
            subtitle: info.dueAt == null
                ? 'Comisiones de semanas ya cerradas.'
                : 'Comisiones de semanas cerradas. Fecha límite: ${formatDueLabel(info.dueAt!)}.',
            onCopy: () => _copy(
              info.catchUpAmountBs.replaceAll('.', ','),
              'Monto copiado.',
            ),
          ),
        if (unlock)
          _AmountCard(
            key: const Key('amount-unlock'),
            title: 'Para volver a recibir solicitudes',
            amountBs: info.unlockAmountBs,
            subtitle:
                'Con este pago tu saldo queda en el tope y vuelves a recibir solicitudes.',
            onCopy: () => _copy(
              info.unlockAmountBs.replaceAll('.', ','),
              'Monto copiado.',
            ),
          ),
        if (!catchUp && !unlock && isPositiveAmount(info.totalBalanceBs))
          _AmountCard(
            key: const Key('amount-total'),
            title: 'Comisión de esta semana',
            amountBs: info.totalBalanceBs,
            subtitle:
                'Todavía no vence: puedes pagarla antes del corte del domingo.',
            onCopy: () => _copy(
              info.totalBalanceBs.replaceAll('.', ','),
              'Monto copiado.',
            ),
          ),
        const SizedBox(height: 8),
        if (reference != null)
          Card(
            child: ListTile(
              key: const Key('pay-reference'),
              leading: const Icon(Icons.tag),
              title: Text(reference, style: theme.textTheme.titleMedium),
              subtitle: const Text(
                'Escribe la referencia en la glosa de la transferencia.',
              ),
              trailing: IconButton(
                key: const Key('copy-reference'),
                tooltip: 'Copiar referencia',
                icon: const Icon(Icons.copy),
                onPressed: () => _copy(reference, 'Referencia copiada.'),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Card(
          clipBehavior: Clip.antiAlias,
          child: info.qrUrl == null
              ? const ListTile(
                  leading: Icon(Icons.qr_code_2),
                  title: Text('El QR de pago todavía no está disponible.'),
                  subtitle: Text('Escríbenos para pagar por otro medio.'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    info.qrUrl!,
                    key: const Key('pay-qr'),
                    height: 240,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Text(
                      'No se pudo cargar el QR. Desliza para recargar.',
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cómo pagar', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final (i, step) in info.instructions.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${i + 1}. $step'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const Key('send-receipt'),
          onPressed: _uploading ? null : () => _sendReceipt(info),
          icon: const Icon(Icons.upload_file),
          label: Text(
            _uploading ? 'Enviando…' : 'Subir comprobante (opcional)',
          ),
        ),
        const SizedBox(height: 8),
        const _Submissions(),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    super.key,
    required this.title,
    required this.amountBs,
    required this.subtitle,
    required this.onCopy,
  });

  final String title;
  final String amountBs;
  final String subtitle;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(
                    formatBs(amountBs),
                    style: theme.textTheme.headlineSmall,
                  ),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Copiar monto',
              icon: const Icon(Icons.copy),
              onPressed: onCopy,
            ),
          ],
        ),
      ),
    );
  }
}

class _Submissions extends ConsumerWidget {
  const _Submissions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(submissionsProvider).value ?? const <PaymentSubmission>[];
    if (items.isEmpty) return const SizedBox.shrink();
    return Card(
      key: const Key('submissions'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('Tus comprobantes'),
          ),
          for (final s in items)
            ListTile(
              dense: true,
              leading: Icon(switch (s.status) {
                SubmissionStatus.pendiente => Icons.hourglass_top,
                SubmissionStatus.registrado => Icons.check_circle_outline,
                SubmissionStatus.rechazado => Icons.error_outline,
              }),
              title: Text(s.status.label),
              subtitle: Text(
                [
                  formatDateTime(s.createdAt),
                  if (s.declaredAmountBs != null) formatBs(s.declaredAmountBs!),
                  if (s.reviewNote != null) s.reviewNote!,
                ].join(' · '),
              ),
            ),
        ],
      ),
    );
  }
}
