import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/confirm_action_dialog.dart';

const _statusLabels = {
  'abierto': 'abierto',
  'cerrado_pendiente': 'por pagar',
  'pagado': 'pagado',
  'vencido': 'vencido',
};

/// Clave de idempotencia (ADR-0037): se genera al abrir el diálogo y se reutiliza si el
/// admin reintenta, así un doble envío no registra dos pagos.
String newIdempotencyKey(String prefix) {
  final random = Random.secure();
  final bytes = List.generate(
    8,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  );
  return '$prefix-${DateTime.now().millisecondsSinceEpoch}-${bytes.join()}';
}

/// Efecto en el saldo antes de guardar (vista previa del backend, sin efectos).
class BalancePreview extends StatelessWidget {
  const BalancePreview(this.p, {super.key});

  final BalancePreviewDto p;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const Key('balance-preview'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo: ${formatBalance(p.balanceBeforeBs)} → ${formatBalance(p.balanceAfterBs)}',
            style: theme.textTheme.titleSmall,
          ),
          for (final a in p.allocations)
            Text(
              '${a.paymentReference ?? 'Periodo actual'}: ${formatBs(a.amountBs)} · queda ${formatBalance(a.periodBalanceAfterBs)} (${_statusLabels[a.statusAfter.value] ?? a.statusAfter.value})',
            ),
          if (p.blockedNow)
            Text(
              p.unblocks
                  ? 'Se desbloquea: no queda ningún periodo vencido.'
                  : 'Sigue bloqueado: queda deuda vencida.',
              key: const Key('preview-unblock'),
            ),
        ],
      ),
    );
  }
}

/// Registrar un pago (R7.4): formulario, confirmación con vista previa e Idempotency-Key.
Future<PaymentResultDto?> registerPaymentFlow(
  BuildContext context,
  WidgetRef ref, {
  required String workerId,
  AdminPaymentSubmissionDto? submission,
}) async {
  final form = await showDialog<_PaymentForm>(
    context: context,
    builder: (_) =>
        _PaymentFormDialog(initialAmount: submission?.declaredAmountBs),
  );
  if (form == null || !context.mounted) return null;
  final api = ref.read(adminApiProvider);
  final key = newIdempotencyKey('pago');
  final amount = centsToApi(form.cents);
  return confirmAction<PaymentResultDto>(
    context,
    title: 'Registrar pago de ${formatBs(amount)}',
    message: submission == null
        ? 'Se aplica a los periodos más antiguos primero; lo que sobra queda a favor.'
        : 'Desde el comprobante del trabajador. Se aplica a los periodos más antiguos primero.',
    confirmLabel: 'Registrar pago',
    noteLabel: 'Referencia o detalle',
    noteHint: 'Ej.: SISI-2643-K7M2QX, transferencia del 21/10',
    loadPreview: () async {
      final res = await api.adminBillingControllerPreviewPayment(
        paymentPreviewDto: PaymentPreviewDto(
          workerId: workerId,
          amountBs: amount,
        ),
      );
      return BalancePreview(res.data!);
    },
    onConfirm: (input) async {
      final res = await api.adminBillingControllerRegisterPayment(
        idempotencyKey: key,
        registerPaymentDto: RegisterPaymentDto(
          workerId: workerId,
          amountBs: amount,
          method: form.method,
          paidAt: form.paidAt.toUtc(),
          reference: input.note,
          submissionId: submission?.id,
        ),
      );
      return res.data!;
    },
  );
}

/// Ajuste (R7.9): nunca se edita un movimiento; se agrega uno con signo y motivo.
Future<AdjustmentResultDto?> registerAdjustmentFlow(
  BuildContext context,
  WidgetRef ref, {
  required String workerId,
  String? correctsEntryId,
  String? suggestedAmount,
}) async {
  final cents = await showDialog<int>(
    context: context,
    builder: (_) => _AmountDialog(
      title: correctsEntryId == null
          ? 'Ajuste'
          : 'Corregir el movimiento $correctsEntryId',
      signed: true,
      initial: suggestedAmount,
    ),
  );
  if (cents == null || !context.mounted) return null;
  final api = ref.read(adminApiProvider);
  final key = newIdempotencyKey('ajuste');
  final amount = centsToApi(cents);
  return confirmAction<AdjustmentResultDto>(
    context,
    title: 'Ajuste de ${formatBs(amount)}',
    message: cents > 0
        ? 'Aumenta la deuda del trabajador.'
        : 'Reduce la deuda del trabajador.',
    confirmLabel: 'Registrar ajuste',
    loadPreview: () async {
      final res = await api.adminBillingControllerPreviewAdjustment(
        adjustmentPreviewDto: AdjustmentPreviewDto(
          workerId: workerId,
          amountBs: amount,
          correctsEntryId: correctsEntryId,
        ),
      );
      return BalancePreview(res.data!);
    },
    onConfirm: (input) async {
      final res = await api.adminBillingControllerRegisterAdjustment(
        idempotencyKey: key,
        registerAdjustmentDto: RegisterAdjustmentDto(
          workerId: workerId,
          amountBs: amount,
          reason: input.note,
          correctsEntryId: correctsEntryId,
        ),
      );
      return res.data!;
    },
  );
}

class _PaymentForm {
  const _PaymentForm(this.cents, this.method, this.paidAt);

  final int cents;
  final RegisterPaymentDtoMethodEnum method;
  final DateTime paidAt;
}

class _PaymentFormDialog extends StatefulWidget {
  const _PaymentFormDialog({this.initialAmount});

  final String? initialAmount;

  @override
  State<_PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<_PaymentFormDialog> {
  late final _amount = TextEditingController(
    text: widget.initialAmount?.replaceAll('.', ','),
  );
  var _method = RegisterPaymentDtoMethodEnum.qrTransferencia;
  var _paidAt = DateTime.now();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int? get _cents {
    final c = parseBsCents(_amount.text);
    return c == null || c <= 0 ? null : c;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Registrar pago'),
    content: SizedBox(
      width: 380,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('payment-amount'),
            controller: _amount,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Monto pagado',
              prefixText: 'Bs ',
            ),
            onChanged: (_) => setState(() {}),
          ),
          DropdownButtonFormField<RegisterPaymentDtoMethodEnum>(
            initialValue: _method,
            decoration: const InputDecoration(labelText: 'Medio'),
            items: const [
              DropdownMenuItem(
                value: RegisterPaymentDtoMethodEnum.qrTransferencia,
                child: Text('QR o transferencia'),
              ),
              DropdownMenuItem(
                value: RegisterPaymentDtoMethodEnum.efectivo,
                child: Text('Efectivo'),
              ),
              DropdownMenuItem(
                value: RegisterPaymentDtoMethodEnum.otro,
                child: Text('Otro'),
              ),
            ],
            onChanged: (v) => setState(() => _method = v ?? _method),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Fecha del pago'),
            subtitle: Text(
              '${_paidAt.day.toString().padLeft(2, '0')}/${_paidAt.month.toString().padLeft(2, '0')}/${_paidAt.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _paidAt,
                firstDate: DateTime.now().subtract(const Duration(days: 120)),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _paidAt = picked.add(const Duration(hours: 12)));
              }
            },
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('payment-next'),
        onPressed: _cents == null
            ? null
            : () => Navigator.pop(
                context,
                _PaymentForm(
                  _cents!,
                  _method,
                  _paidAt.isAfter(DateTime.now()) ? DateTime.now() : _paidAt,
                ),
              ),
        child: const Text('Siguiente'),
      ),
    ],
  );
}

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({
    required this.title,
    required this.signed,
    this.initial,
  });

  final String title;
  final bool signed;
  final String? initial;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  late final _amount = TextEditingController(
    text: widget.initial?.replaceAll('.', ','),
  );

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int? get _cents {
    final text = _amount.text.trim();
    final negative = widget.signed && text.startsWith('-');
    final c = parseBsCents(negative ? text.substring(1) : text);
    if (c == null || c == 0) return null;
    return negative ? -c : c;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 380,
      child: TextField(
        key: const Key('adjustment-amount'),
        controller: _amount,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Monto con signo',
          prefixText: 'Bs ',
          helperText:
              'Positivo aumenta la deuda; negativo la reduce (ej.: -19,50).',
        ),
        onChanged: (_) => setState(() {}),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('adjustment-next'),
        onPressed: _cents == null ? null : () => Navigator.pop(context, _cents),
        child: const Text('Siguiente'),
      ),
    ],
  );
}
