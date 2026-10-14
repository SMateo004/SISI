import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/categories/category.dart';
import '../../../shared/money.dart';

/// Precio propuesto con el rango de referencia (R3.2) y el aviso de traslado (R3.5).
class PriceStep extends StatefulWidget {
  const PriceStep({
    super.key,
    required this.category,
    required this.initialValue,
    required this.onChanged,
  });

  final Category category;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<PriceStep> createState() => _PriceStepState();
}

class _PriceStepState extends State<PriceStep> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cents = parseBsCents(_controller.text);
    final min = parseBsCents(widget.category.priceMinBs);
    final below = cents != null && min != null && cents < min;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: ListTile(
            leading: Icon(widget.category.icon),
            title: Text('Referencia para ${widget.category.name}'),
            subtitle: Text(
              '${formatBs(widget.category.priceMinBs)} a ${formatBs(widget.category.priceMaxBs)}',
              key: const Key('price-reference'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('price-field'),
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            LengthLimitingTextInputFormatter(11),
          ],
          decoration: const InputDecoration(
            labelText: '¿Cuánto ofreces pagar?',
            prefixText: 'Bs ',
            hintText: '150',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {});
            widget.onChanged(value);
          },
        ),
        if (below) ...[
          const SizedBox(height: 12),
          Container(
            key: const Key('price-warning'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Tu precio está por debajo del mínimo de referencia '
              '(${formatBs(widget.category.priceMinBs)}). Puedes publicar igual, '
              'pero podrías recibir menos ofertas.',
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.directions_bike, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'El precio que propones incluye el traslado del trabajador hasta el lugar.',
                key: Key('transport-notice'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Los trabajadores pueden aceptar tu precio o proponerte otro. Tú eliges.',
        ),
      ],
    );
  }
}
