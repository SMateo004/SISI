import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../../shared/money.dart';
import '../../requests/domain/service_request.dart';
import '../application/employer_live.dart';
import '../data/offers_repository.dart';
import '../domain/offer_models.dart';

/// "Buscando trabajador": anillo actual y ofertas en vivo con "Elegir" (R4, R5.3).
class SearchingPanel extends ConsumerWidget {
  const SearchingPanel({
    super.key,
    required this.request,
    required this.onAssigned,
  });

  final ServiceRequest request;

  /// Tras elegir: recarga la solicitud y abre el contacto.
  final void Function(String jobId) onAssigned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offers = ref.watch(requestOffersProvider(request.id));
    final ring = request.ring;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          key: const Key('searching-panel'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buscando cerca de ti',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (ring ?? 0) / request.totalRings,
                ),
                const SizedBox(height: 8),
                Text(
                  ring == null
                      ? 'Empezando la búsqueda…'
                      : 'Avisamos a trabajadores cercanos · anillo $ring de ${request.totalRings}',
                  key: const Key('ring-indicator'),
                ),
                if (request.expiresAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Elige una oferta antes de las ${_hhmm(request.expiresAt!)} o la solicitud expirará.',
                    key: const Key('choose-before'),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Ofertas', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        switch (offers) {
          AsyncData(:final value) when value.isEmpty => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Todavía no hay ofertas. Te avisamos apenas llegue una.',
              key: Key('offers-empty'),
            ),
          ),
          AsyncData(:final value) => Column(
            children: [
              for (final o in value)
                _OfferTile(
                  offer: o,
                  requestId: request.id,
                  onAssigned: onAssigned,
                ),
            ],
          ),
          AsyncError(:final error) => Text(ApiException.from(error).message),
          _ => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }

  static String _hhmm(DateTime t) {
    final local = t.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _OfferTile extends ConsumerStatefulWidget {
  const _OfferTile({
    required this.offer,
    required this.requestId,
    required this.onAssigned,
  });

  final EmployerOffer offer;
  final String requestId;
  final void Function(String jobId) onAssigned;

  @override
  ConsumerState<_OfferTile> createState() => _OfferTileState();
}

class _OfferTileState extends ConsumerState<_OfferTile> {
  bool _busy = false;

  Future<void> _choose() async {
    final o = widget.offer;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Elegir a ${o.workerShortName}?'),
        content: Text(
          'Por ${formatBs(o.amountBs)} (incluye el traslado), llegaría en unos ${o.etaMin} min. '
          'Las demás ofertas se cerrarán y verán sus datos de contacto.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            key: const Key('confirm-choose'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sí, elegir'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final jobId = await ref
          .read(offersRepositoryProvider)
          .accept(widget.requestId, o.id);
      widget.onAssigned(jobId);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      ref.invalidate(requestOffersProvider(widget.requestId));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;
    final theme = Theme.of(context);
    final rating = o.ratingCount == 0
        ? 'Nuevo'
        : '★ ${o.ratingAvg.replaceAll('.', ',').substring(0, 3)} (${o.ratingCount})';
    return Card(
      key: Key('offer-${o.id}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(o.workerShortName, style: theme.textTheme.titleMedium),
                  Text('$rating · llega en ~${o.etaMin} min'),
                  Text(
                    o.type == OfferType.accept
                        ? 'Acepta tu precio'
                        : 'Contraoferta',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatBs(o.amountBs), style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                FilledButton(
                  key: Key('choose-${o.id}'),
                  onPressed: _busy ? null : _choose,
                  child: const Text('Elegir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Solicitud asignada: acceso al contacto (R5.4).
class AssignedPanel extends StatelessWidget {
  const AssignedPanel({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    key: const Key('see-contact'),
    onPressed: () => context.push(Routes.jobContact(jobId)),
    icon: const Icon(Icons.contact_phone),
    label: const Text('Ver contacto del trabajador'),
  );
}

/// Solicitud expirada (R4.5): volver a publicar con los mismos datos.
class ExpiredPanel extends StatelessWidget {
  const ExpiredPanel({super.key, required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: const Key('expired-panel'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.timer_off_outlined,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Esta vez nadie tomó tu solicitud a tiempo.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Puedes publicarla de nuevo; quizá con un precio un poco más alto.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('republish'),
              onPressed: () => context.push(
                Routes.newRequest,
                extra: RepublishSeed.from(request),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Volver a publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
