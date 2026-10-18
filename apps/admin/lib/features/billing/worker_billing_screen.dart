import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/server_table.dart';
import 'billing_dialogs.dart';

const _typeLabels = {
  'comision': 'Comisión',
  'pago': 'Pago',
  'ajuste': 'Ajuste',
};

/// Ficha de cobros de un trabajador: ledger completo con saldo acumulado, pagos y ajustes.
class WorkerBillingScreen extends ConsumerStatefulWidget {
  const WorkerBillingScreen({super.key, required this.workerId});

  final String workerId;

  @override
  ConsumerState<WorkerBillingScreen> createState() =>
      _WorkerBillingScreenState();
}

class _WorkerBillingScreenState extends ConsumerState<WorkerBillingScreen> {
  int _reload = 0;
  String? _balance;

  Future<void> _payment() async {
    final result = await registerPaymentFlow(
      context,
      ref,
      workerId: widget.workerId,
    );
    if (result != null && mounted) {
      showDone(
        context,
        'Pago registrado. Saldo: ${formatBalance(result.balanceBs)}.',
      );
      setState(() => _reload++);
    }
  }

  Future<void> _adjust({LedgerRowDto? corrects}) async {
    final result = await registerAdjustmentFlow(
      context,
      ref,
      workerId: widget.workerId,
      correctsEntryId: corrects?.id,
      suggestedAmount: corrects == null || corrects.type.value != 'comision'
          ? null
          : '-${corrects.amountBs}',
    );
    if (result != null && mounted) {
      showDone(
        context,
        'Ajuste registrado. Saldo: ${formatBalance(result.balanceBs)}.',
      );
      setState(() => _reload++);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeader(
        'Cobros del trabajador',
        subtitle: _balance == null
            ? null
            : 'Saldo: ${formatBalance(_balance!)}',
        actions: [
          TextButton(
            onPressed: () => context.go('/usuarios/${widget.workerId}'),
            child: const Text('Ver ficha'),
          ),
          OutlinedButton(
            key: const Key('worker-adjust'),
            onPressed: _adjust,
            child: const Text('Ajuste'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            key: const Key('worker-pay'),
            onPressed: _payment,
            child: const Text('Registrar pago'),
          ),
        ],
      ),
      Expanded(
        child: ServerTable<LedgerRowDto>(
          key: const Key('ledger-table'),
          reloadKey: _reload,
          empty: 'Sin movimientos.',
          load: (cursor) async {
            final res = await ref
                .read(adminApiProvider)
                .adminBillingControllerLedger(
                  id: widget.workerId,
                  cursor: cursor,
                );
            final page = res.data!;
            if (_balance != page.balanceBs && mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _balance = page.balanceBs);
              });
            }
            return PageResult(page.items, page.nextCursor);
          },
          columns: [
            ServerColumn('#', (r) => Text(r.id)),
            ServerColumn('Fecha', (r) => Text(formatDateTime(r.createdAt))),
            ServerColumn(
              'Tipo',
              (r) => Text(_typeLabels[r.type.value] ?? r.type.value),
            ),
            ServerColumn('Periodo', (r) => Text(r.paymentReference)),
            ServerColumn(
              'Monto',
              (r) => Text(formatBs(r.amountBs)),
              numeric: true,
            ),
            ServerColumn(
              'Saldo acumulado',
              (r) => Text(formatBalance(r.runningBs)),
              numeric: true,
            ),
            ServerColumn(
              'Motivo',
              (r) => Text(
                r.reason ??
                    (r.correctsEntryId == null
                        ? ''
                        : 'Corrige #${r.correctsEntryId}'),
              ),
            ),
            ServerColumn(
              '',
              (r) => TextButton(
                key: Key('correct-${r.id}'),
                onPressed: () => _adjust(corrects: r),
                child: const Text('Corregir'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
