import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../../shared/categories/category.dart';
import '../../../shared/money.dart';
import '../data/requests_repository.dart';
import '../domain/service_request.dart';
import 'request_status_chip.dart';

/// Primera página de "Mis solicitudes" (más recientes primero).
final myRequestsProvider = FutureProvider.autoDispose<RequestPage>(
  (ref) => ref.watch(requestsRepositoryProvider).listMine(),
  retry: (retryCount, error) => null,
);

String formatShortDate(DateTime date) {
  final local = date.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
}

class MyRequestsScreen extends ConsumerStatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  ConsumerState<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends ConsumerState<MyRequestsScreen> {
  final _more = <ServiceRequest>[];
  String? _cursor;
  bool _loadingMore = false;

  Future<void> _loadMore(String cursor) async {
    setState(() => _loadingMore = true);
    try {
      final page = await ref
          .read(requestsRepositoryProvider)
          .listMine(cursor: cursor);
      setState(() {
        _more.addAll(page.items);
        _cursor = page.nextCursor;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiException.from(e).message)));
      }
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _more.clear();
      _cursor = null;
    });
    ref.invalidate(myRequestsProvider);
    await ref.read(myRequestsProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final first = ref.watch(myRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newRequest),
        icon: const Icon(Icons.add),
        label: const Text('Pedir un servicio'),
      ),
      body: switch (first) {
        AsyncData(value: final page) => RefreshIndicator(
          onRefresh: _refresh,
          child: Builder(
            builder: (context) {
              final items = [...page.items, ..._more];
              final cursor = _more.isEmpty ? page.nextCursor : _cursor;
              if (items.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 120),
                    Icon(Icons.inbox_outlined, size: 56),
                    SizedBox(height: 12),
                    Text(
                      'Todavía no pediste ningún servicio.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }
              return ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  for (final request in items)
                    ListTile(
                      key: Key('request-${request.id}'),
                      leading: Icon(categoryIcon(request.category.slug)),
                      title: Text(request.category.name),
                      subtitle: Text(
                        '${formatBs(request.proposedPriceBs)} · ${formatShortDate(request.createdAt)}\n${request.address}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      trailing: RequestStatusChip(status: request.status),
                      onTap: () async {
                        await context.push(Routes.requestDetail(request.id));
                        if (mounted) await _refresh();
                      },
                    ),
                  if (cursor != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton(
                        onPressed: _loadingMore
                            ? null
                            : () => _loadMore(cursor),
                        child: const Text('Ver más'),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        AsyncError(:final error) => Center(
          child: Text(ApiException.from(error).message),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
