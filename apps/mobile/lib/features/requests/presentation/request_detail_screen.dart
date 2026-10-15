import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_providers.dart';
import '../../../core/router/routes.dart';
import '../../../shared/categories/category.dart';
import '../../../shared/money.dart';
import '../../offers/application/employer_live.dart';
import '../../offers/presentation/employer_request_panels.dart';
import '../data/requests_repository.dart';
import '../domain/service_request.dart';
import 'my_requests_screen.dart';
import 'request_status_chip.dart';

/// Avisos que cambian el estado de la solicitud para el empleador.
const _employerEvents = {
  RealtimeEvents.offerNew,
  RealtimeEvents.requestAssigned,
  RealtimeEvents.requestExpired,
};

/// Detalle de la solicitud. Se vuelve a pedir con cada aviso de esta solicitud y al
/// reconectar el socket (ADR-0023).
final requestDetailProvider = FutureProvider.autoDispose
    .family<ServiceRequest, String>((ref, id) {
      ref.watch(realtimeResyncProvider);
      ref.listen(realtimeEventsProvider, (_, next) {
        final event = next.value;
        if (event != null &&
            event.requestId == id &&
            _employerEvents.contains(event.name)) {
          ref.invalidateSelf();
        }
      });
      return ref.watch(requestsRepositoryProvider).get(id);
    }, retry: (retryCount, error) => null);

/// Detalle de una solicitud propia: estado, mensaje y opción de cancelar (R3.4).
class RequestDetailScreen extends ConsumerStatefulWidget {
  const RequestDetailScreen({super.key, required this.requestId, this.notice});

  final String requestId;

  /// Mensaje recién publicada (p. ej. "Recibimos tu solicitud…").
  final String? notice;

  @override
  ConsumerState<RequestDetailScreen> createState() =>
      _RequestDetailScreenState();
}

class _RequestDetailScreenState extends ConsumerState<RequestDetailScreen> {
  bool _cancelling = false;
  Timer? _refresh;

  @override
  void initState() {
    super.initState();
    // El anillo actual no tiene evento propio: se refresca mientras busca (ADR-0023).
    final every = ref.read(searchRefreshIntervalProvider);
    if (every != null) {
      _refresh = Timer.periodic(every, (_) {
        final current = ref.read(requestDetailProvider(widget.requestId)).value;
        if (current?.isSearching ?? false) {
          ref.invalidate(requestDetailProvider(widget.requestId));
        }
      });
    }
  }

  @override
  void dispose() {
    _refresh?.cancel();
    super.dispose();
  }

  void _assigned(String jobId) {
    ref.invalidate(requestDetailProvider(widget.requestId));
    ref.invalidate(myRequestsProvider);
    context.push(Routes.jobContact(jobId));
  }

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cancelar la solicitud?'),
        content: const Text('Los trabajadores dejarán de verla.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _cancelling = true);
    try {
      await ref.read(requestsRepositoryProvider).cancel(widget.requestId);
      ref.invalidate(requestDetailProvider(widget.requestId));
      ref.invalidate(myRequestsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiException.from(e).message)));
      }
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(requestDetailProvider(widget.requestId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu solicitud'),
        // Tras publicar se llega con go(): sin pantalla anterior.
        leading: context.canPop()
            ? null
            : IconButton(
                tooltip: 'Mis solicitudes',
                icon: const Icon(Icons.list_alt),
                onPressed: () => context.go(Routes.myRequests),
              ),
      ),
      body: switch (detail) {
        AsyncData(value: final request) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // El aviso de recién publicada solo mientras sigue vigente (no si ya expiró).
            if (widget.notice != null &&
                (request.isSearching ||
                    request.status == RequestStatus.retenida))
              Card(
                key: const Key('publish-notice'),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(widget.notice!),
                ),
              ),
            ListTile(
              leading: Icon(categoryIcon(request.category.slug), size: 32),
              title: Text(request.category.name),
              trailing: RequestStatusChip(status: request.status),
            ),
            if (request.statusMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  request.statusMessage!,
                  key: const Key('status-message'),
                ),
              ),
            const Divider(height: 32),
            Text(request.description),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.place_outlined),
              title: Text(request.address),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.payments_outlined),
              title: Text(formatBs(request.proposedPriceBs)),
              subtitle: const Text('Incluye el traslado del trabajador.'),
            ),
            if (request.photos.isNotEmpty)
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final photo in request.photos)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photo.url,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(
                              width: 96,
                              child: Icon(Icons.image),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            if (request.isSearching) ...[
              SearchingPanel(request: request, onAssigned: _assigned),
              const SizedBox(height: 16),
            ],
            if (request.status == RequestStatus.asignada &&
                request.jobId != null) ...[
              AssignedPanel(jobId: request.jobId!),
              const SizedBox(height: 16),
            ],
            if (request.status == RequestStatus.expirada) ...[
              ExpiredPanel(request: request),
              const SizedBox(height: 16),
            ],
            if (request.status.cancelable)
              OutlinedButton.icon(
                key: const Key('cancel-request'),
                onPressed: _cancelling ? null : _cancel,
                icon: const Icon(Icons.close),
                label: const Text('Cancelar solicitud'),
              ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Text(ApiException.from(error).message),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
