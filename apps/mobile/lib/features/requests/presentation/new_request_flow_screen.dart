import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/files/image_source_sheet.dart';
import '../../../core/files/picked_image.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/maps/geo_point.dart';
import '../../../core/maps/map_view.dart';
import '../../../core/router/routes.dart';
import '../../../shared/money.dart';
import '../application/request_draft.dart';
import '../data/requests_repository.dart';
import '../domain/service_request.dart';
import 'price_step.dart';

/// "Pedir un servicio": categoría → descripción y fotos → ubicación → precio → resumen.
class NewRequestFlowScreen extends ConsumerStatefulWidget {
  const NewRequestFlowScreen({super.key, this.seed});

  /// Volver a publicar una solicitud expirada: se precargan sus datos.
  final RepublishSeed? seed;

  @override
  ConsumerState<NewRequestFlowScreen> createState() =>
      _NewRequestFlowScreenState();
}

class _NewRequestFlowScreenState extends ConsumerState<NewRequestFlowScreen> {
  bool _publishing = false;

  /// Si la creación del borrador funcionó pero algo falló después, se reintenta sin
  /// crear otro borrador.
  String? _draftId;
  int _uploadedPhotos = 0;

  @override
  void initState() {
    super.initState();
    final seed = widget.seed;
    if (seed == null) return;
    Future.microtask(() async {
      ref.read(requestDraftProvider.notifier).prefill(seed);
      final categories = await ref.read(requestCategoriesProvider.future);
      final match = categories.where((c) => c.id == seed.categoryId);
      if (mounted && match.isNotEmpty) {
        ref.read(requestDraftProvider.notifier).selectCategory(match.first);
      }
    });
  }

  Future<void> _publish(RequestDraft draft) async {
    final repo = ref.read(requestsRepositoryProvider);
    setState(() => _publishing = true);
    try {
      _draftId ??= (await repo.createDraft(
        NewRequestInput(
          categoryId: draft.category!.id,
          description: draft.description.trim(),
          location: draft.location,
          address: draft.address.trim(),
          proposedPriceBs: centsToApi(draft.priceCents!),
        ),
      )).id;
      for (; _uploadedPhotos < draft.photos.length; _uploadedPhotos++) {
        await repo.uploadPhoto(_draftId!, draft.photos[_uploadedPhotos]);
      }
      final result = await repo.publish(_draftId!);
      if (!mounted) return;
      context.go(
        Routes.requestDetail(result.request.id),
        extra: result.message,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiException.from(e).message)));
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(requestDraftProvider);
    final controller = ref.read(requestDraftProvider.notifier);
    final isLast = draft.step == RequestStep.summary;

    return Scaffold(
      appBar: AppBar(title: const Text('Pedir un servicio')),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (draft.step.index + 1) / RequestStep.values.length,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    draft.step.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  'Paso ${draft.step.index + 1} de ${RequestStep.values.length}',
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (draft.step) {
              // El mapa necesita todo el alto disponible (sin scroll).
              RequestStep.location => _LocationStep(draft: draft),
              _ => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: switch (draft.step) {
                  RequestStep.category => const _CategoryStep(),
                  RequestStep.details => _DetailsStep(draft: draft),
                  RequestStep.price => PriceStep(
                    category: draft.category!,
                    initialValue: draft.price,
                    onChanged: controller.setPrice,
                  ),
                  _ => _SummaryStep(draft: draft),
                },
              ),
            },
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (draft.step != RequestStep.category)
                    TextButton(
                      onPressed: _publishing ? null : controller.back,
                      child: const Text('Atrás'),
                    ),
                  const Spacer(),
                  FilledButton(
                    key: const Key('request-next'),
                    onPressed: !draft.canContinue() || _publishing
                        ? null
                        : isLast
                        ? () => _publish(draft)
                        : controller.next,
                    child: _publishing
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isLast ? 'Publicar' : 'Siguiente'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStep extends ConsumerWidget {
  const _CategoryStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(requestDraftProvider).category;
    return switch (ref.watch(requestCategoriesProvider)) {
      AsyncData(value: final categories) when categories.isEmpty => const Text(
        'Todavía no hay servicios disponibles en tu ciudad.',
        key: Key('categories-empty'),
      ),
      AsyncData(value: final categories) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          for (final category in categories)
            Card(
              key: Key('category-${category.slug}'),
              color: selected?.id == category.id
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => ref
                    .read(requestDraftProvider.notifier)
                    .selectCategory(category),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category.icon, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      AsyncError(:final error) => Text(ApiException.from(error).message),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _DetailsStep extends ConsumerStatefulWidget {
  const _DetailsStep({required this.draft});

  final RequestDraft draft;

  @override
  ConsumerState<_DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends ConsumerState<_DetailsStep> {
  late final _description = TextEditingController(
    text: widget.draft.description,
  );

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final origin = await showImageSourceSheet(context);
    if (origin == null) return;
    final image = await ref.read(imagePickerProvider).pick(origin);
    if (image != null) ref.read(requestDraftProvider.notifier).addPhoto(image);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(requestDraftProvider);
    final length = draft.description.trim().length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('description-field'),
          controller: _description,
          minLines: 4,
          maxLines: 8,
          maxLength: descriptionMax,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Cuéntale al trabajador qué necesitas',
            hintText: 'Ej.: Tengo una fuga debajo del lavaplatos de la cocina.',
            helperText: length < descriptionMin
                ? 'Mínimo $descriptionMin caracteres (te faltan ${descriptionMin - length}).'
                : null,
            border: const OutlineInputBorder(),
          ),
          onChanged: ref.read(requestDraftProvider.notifier).setDescription,
        ),
        const SizedBox(height: 16),
        Text(
          'Fotos (opcional, hasta $maxPhotos)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (i, photo) in draft.photos.indexed)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      photo.bytes,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.black12,
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton.filledTonal(
                      iconSize: 16,
                      tooltip: 'Quitar foto',
                      onPressed: () => ref
                          .read(requestDraftProvider.notifier)
                          .removePhoto(i),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            if (draft.photos.length < maxPhotos)
              OutlinedButton.icon(
                key: const Key('add-photo'),
                onPressed: _addPhoto,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Agregar foto'),
              ),
          ],
        ),
      ],
    );
  }
}

class _LocationStep extends ConsumerStatefulWidget {
  const _LocationStep({required this.draft});

  final RequestDraft draft;

  @override
  ConsumerState<_LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<_LocationStep> {
  late final _address = TextEditingController(text: widget.draft.address);
  bool _loadingAddress = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.draft.address.isEmpty) _suggest(widget.draft.location);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _address.dispose();
    super.dispose();
  }

  void _onCenterChanged(GeoPoint point) {
    ref.read(requestDraftProvider.notifier).setLocation(point);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _suggest(point));
  }

  Future<void> _suggest(GeoPoint point) async {
    if (ref.read(requestDraftProvider).addressEdited) return;
    setState(() => _loadingAddress = true);
    try {
      final address = await ref
          .read(requestsRepositoryProvider)
          .reverseGeocode(point);
      if (!mounted) return;
      ref.read(requestDraftProvider.notifier).suggestAddress(address);
      if (address != null && !ref.read(requestDraftProvider).addressEdited) {
        _address.text = address;
      }
    } catch (_) {
      // Sin sugerencia: la persona escribe la dirección.
    } finally {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MapView(
            initialCenter: widget.draft.location,
            onCenterChanged: _onCenterChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            key: const Key('address-field'),
            controller: _address,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: 'Dirección',
              helperText:
                  'Mueve el mapa para fijar el punto. Puedes corregir la dirección.',
              border: const OutlineInputBorder(),
              suffixIcon: _loadingAddress
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
            onChanged: ref.read(requestDraftProvider.notifier).editAddress,
          ),
        ),
      ],
    );
  }
}

class _SummaryStep extends StatelessWidget {
  const _SummaryStep({required this.draft});

  final RequestDraft draft;

  @override
  Widget build(BuildContext context) {
    final category = draft.category!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: Icon(category.icon),
          title: Text(category.name),
          subtitle: Text(draft.description.trim()),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: Text(
            draft.photos.isEmpty
                ? 'Sin fotos'
                : '${draft.photos.length} ${draft.photos.length == 1 ? 'foto' : 'fotos'}',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(draft.address.trim()),
        ),
        ListTile(
          leading: const Icon(Icons.payments_outlined),
          title: Text(
            formatBs(centsToApi(draft.priceCents ?? 0)),
            key: const Key('summary-price'),
          ),
          subtitle: const Text('Incluye el traslado del trabajador.'),
        ),
        if (draft.priceBelowReference)
          Text(
            'Tu precio está por debajo del mínimo de referencia '
            '(${formatBs(category.priceMinBs)}). Puedes publicar igual.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}
