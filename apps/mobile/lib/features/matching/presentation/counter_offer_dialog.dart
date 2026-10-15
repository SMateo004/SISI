import 'package:flutter/material.dart';

import '../../../shared/money.dart';

/// Pide el monto de la contraoferta (R5.2). Devuelve el monto en formato de la API
/// ("180.00") o null si se cancela. Valida > 0 y el tope de la contraoferta.
Future<String?> showCounterOfferDialog(
  BuildContext context, {
  required String proposedPriceBs,
  required String maxCounterBs,
}) => showDialog<String>(
  context: context,
  builder: (_) => _CounterOfferDialog(
    proposedPriceBs: proposedPriceBs,
    maxCounterBs: maxCounterBs,
  ),
);

class _CounterOfferDialog extends StatefulWidget {
  const _CounterOfferDialog({
    required this.proposedPriceBs,
    required this.maxCounterBs,
  });

  final String proposedPriceBs;
  final String maxCounterBs;

  @override
  State<_CounterOfferDialog> createState() => _CounterOfferDialogState();
}

class _CounterOfferDialogState extends State<_CounterOfferDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final cents = parseBsCents(_controller.text);
    final max = parseBsCents(widget.maxCounterBs) ?? 0;
    setState(() {
      if (cents == null || cents <= 0) {
        _error = 'Escribe un monto mayor a 0 (por ejemplo 180 o 180,50).';
      } else if (cents > max) {
        _error = 'El máximo es ${formatBs(widget.maxCounterBs)}.';
      } else {
        _error = null;
      }
    });
    if (_error == null && cents != null) {
      Navigator.of(context).pop(centsToApi(cents));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Contraofertar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('El cliente propone ${formatBs(widget.proposedPriceBs)}.'),
          const SizedBox(height: 12),
          TextField(
            key: const Key('counter-amount'),
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Tu precio',
              prefixText: 'Bs ',
              helperText: 'Incluye tu traslado.',
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('counter-submit'),
          onPressed: _submit,
          child: const Text('Enviar contraoferta'),
        ),
      ],
    );
  }
}
