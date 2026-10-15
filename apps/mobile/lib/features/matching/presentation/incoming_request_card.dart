import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../../shared/categories/category.dart';
import '../../../shared/money.dart';
import '../../offers/data/offers_repository.dart';
import '../../offers/domain/offer_models.dart';
import '../application/incoming_requests.dart';
import 'counter_offer_dialog.dart';
import 'countdown_text.dart';

/// Tarjeta de una solicitud entrante (R5.1, R5.2): distancia, descripción, fotos,
/// precio, cuenta regresiva y las acciones "Aceptar precio" y "Contraofertar".
class IncomingRequestCard extends ConsumerStatefulWidget {
  const IncomingRequestCard({
    super.key,
    required this.request,
    this.expanded = false,
  });

  final IncomingRequest request;

  /// En el detalle muestra la descripción completa y las fotos grandes.
  final bool expanded;

  @override
  ConsumerState<IncomingRequestCard> createState() =>
      _IncomingRequestCardState();
}

class _IncomingRequestCardState extends ConsumerState<IncomingRequestCard> {
  bool _busy = false;

  IncomingRequest get r => widget.request;

  Future<void> _offer(OfferType type, {String? amountBs}) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(offersRepositoryProvider)
          .offer(r.requestId, type: type, amountBs: amountBs);
      ref.invalidate(incomingRequestsProvider);
      ref.invalidate(incomingRequestProvider(r.requestId));
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            type == OfferType.accept
                ? 'Aceptaste el precio. Te avisamos si el cliente te elige.'
                : 'Enviaste tu contraoferta. Te avisamos si el cliente te elige.',
          ),
        ),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      ref.invalidate(incomingRequestsProvider);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _counter() async {
    final amount = await showCounterOfferDialog(
      context,
      proposedPriceBs: r.proposedPriceBs,
      maxCounterBs: r.maxCounterBs,
    );
    if (amount != null) await _offer(OfferType.counter, amountBs: amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: Key('incoming-${r.requestId}'),
      child: InkWell(
        onTap: widget.expanded
            ? null
            : () => context.push(Routes.incomingRequest(r.requestId)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    categoryIcon(r.categorySlug),
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r.categoryName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatDistance(r.distanceM),
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                r.description,
                maxLines: widget.expanded ? null : 3,
                overflow: widget.expanded ? null : TextOverflow.ellipsis,
              ),
              if (r.photoUrls.isNotEmpty) ...[
                const SizedBox(height: 8),
                _Photos(urls: r.photoUrls, large: widget.expanded),
              ],
              const SizedBox(height: 12),
              Text(
                formatBs(r.proposedPriceBs),
                key: const Key('incoming-price'),
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                'Referencia: ${formatBs(r.referenceMinBs)} a ${formatBs(r.referenceMaxBs)} · incluye tu traslado',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              ..._status(theme),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _status(ThemeData theme) {
    final offer = r.myOffer;
    switch (r.outcome) {
      case IncomingOutcome.elegido:
        return [
          _Banner(
            key: const Key('outcome-chosen'),
            icon: Icons.celebration,
            text: '¡Te eligieron! Ya puedes ver el contacto del cliente.',
            color: theme.colorScheme.primaryContainer,
          ),
          if (r.jobId != null) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              key: const Key('see-contact'),
              onPressed: () => context.push(Routes.jobContact(r.jobId!)),
              icon: const Icon(Icons.contact_phone),
              label: const Text('Ver contacto'),
            ),
          ],
        ];
      case IncomingOutcome.elegidaOtra:
        return [
          _Banner(
            key: const Key('outcome-other'),
            icon: Icons.info_outline,
            text: 'El cliente eligió a otro trabajador.',
            color: theme.colorScheme.surfaceContainerHighest,
          ),
        ];
      case IncomingOutcome.cancelada:
        return [
          _Banner(
            icon: Icons.cancel_outlined,
            text: 'El cliente canceló la solicitud.',
            color: theme.colorScheme.surfaceContainerHighest,
          ),
        ];
      case IncomingOutcome.expirada:
        return [
          _Banner(
            icon: Icons.timer_off_outlined,
            text: 'La solicitud expiró.',
            color: theme.colorScheme.surfaceContainerHighest,
          ),
        ];
      case IncomingOutcome.abierta:
        return [
          CountdownText(until: r.respondBy),
          if (offer != null) ...[
            const SizedBox(height: 8),
            _Banner(
              key: const Key('my-offer'),
              icon: Icons.local_offer_outlined,
              text:
                  'Tu oferta: ${formatBs(offer.amountBs)} (${offer.type.label.toLowerCase()}) · llegarías en ${offer.etaMin} min. Puedes cambiarla mientras el cliente no elija.',
              color: theme.colorScheme.secondaryContainer,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  key: const Key('accept-price'),
                  onPressed: _busy ? null : () => _offer(OfferType.accept),
                  child: const Text('Aceptar precio'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  key: const Key('counter-offer'),
                  onPressed: _busy ? null : _counter,
                  child: const Text('Contraofertar'),
                ),
              ),
            ],
          ),
        ];
    }
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _Photos extends StatelessWidget {
  const _Photos({required this.urls, required this.large});

  final List<String> urls;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 160.0 : 64.0;
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            urls[i],
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: size,
              height: size,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_not_supported_outlined),
            ),
          ),
        ),
      ),
    );
  }
}
