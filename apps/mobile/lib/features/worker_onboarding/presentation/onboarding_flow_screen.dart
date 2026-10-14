import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/files/image_source_sheet.dart';
import '../../../core/files/picked_image.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../application/onboarding_draft.dart';
import '../data/worker_repository.dart';
import '../domain/worker_models.dart';

/// Flujo de upgrade a trabajador, paso a paso (R1.3).
class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key, this.today});

  /// Para tests; por defecto la fecha del dispositivo.
  final DateTime? today;

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  bool _prefilled = false;
  bool _submitting = false;

  DateTime get _today => widget.today ?? DateTime.now();

  bool _canContinue(
    OnboardingDraft draft,
    WorkerProfile profile,
    List<Category>? categories,
  ) => switch (draft.step) {
    OnboardingStep.data =>
      draft.birthDate != null && ageOn(draft.birthDate!, _today) >= 18,
    OnboardingStep.documents => profile.missingDocuments.isEmpty,
    OnboardingStep.categories => draft.categoryIds.isNotEmpty,
    OnboardingStep.transport => draft.transport != null,
    OnboardingStep.summary => true,
  };

  Future<void> _submit(OnboardingDraft draft) async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(workerRepositoryProvider)
          .submit(
            birthDate: draft.birthDateIso!,
            categoryIds: draft.categoryIds.toList(),
            transport: draft.transport!,
            maxRadiusKm: draft.radiusKm,
          );
      ref.invalidate(workerProfileProvider);
      if (mounted) context.go(Routes.workerStatus);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiException.from(e).message)));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(workerProfileProvider);
    final draft = ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiero trabajar en SISI')),
      body: switch (profileAsync) {
        AsyncError(:final error) => _Message(
          text: ApiException.from(error).message,
        ),
        AsyncData(value: final profile) when !profile.editable => _Message(
          text: 'Tu solicitud ya fue enviada.',
          action: TextButton(
            onPressed: () => context.go(Routes.workerStatus),
            child: const Text('Ver el estado de tu solicitud'),
          ),
        ),
        AsyncData(value: final profile) => Builder(
          builder: (context) {
            if (!_prefilled) {
              _prefilled = true;
              Future.microtask(() => controller.prefill(profile));
            }
            final categories = ref.watch(categoriesProvider).value;
            final isLast = draft.step == OnboardingStep.summary;
            return Column(
              children: [
                LinearProgressIndicator(
                  value: (draft.step.index + 1) / OnboardingStep.values.length,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          draft.step.title,
                          key: const Key('step-title'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        'Paso ${draft.step.index + 1} de ${OnboardingStep.values.length}',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: switch (draft.step) {
                      OnboardingStep.data => _DataStep(
                        draft: draft,
                        today: _today,
                      ),
                      OnboardingStep.documents => _DocumentsStep(
                        profile: profile,
                      ),
                      OnboardingStep.categories => _CategoriesStep(
                        draft: draft,
                      ),
                      OnboardingStep.transport => _TransportStep(draft: draft),
                      OnboardingStep.summary => _SummaryStep(
                        draft: draft,
                        categories: categories,
                      ),
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (draft.step != OnboardingStep.data)
                          TextButton(
                            onPressed: controller.back,
                            child: const Text('Atrás'),
                          ),
                        const Spacer(),
                        FilledButton(
                          key: const Key('onboarding-next'),
                          onPressed:
                              !_canContinue(draft, profile, categories) ||
                                  _submitting
                              ? null
                              : isLast
                              ? () => _submit(draft)
                              : controller.next,
                          child: Text(
                            isLast ? 'Enviar solicitud' : 'Siguiente',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          ?action,
        ],
      ),
    ),
  );
}

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

class _DataStep extends ConsumerWidget {
  const _DataStep({required this.draft, required this.today});

  final OnboardingDraft draft;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birth = draft.birthDate;
    final underage = birth != null && ageOn(birth, today) < 18;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Para trabajar en SISI necesitamos verificar tu identidad. Debes tener 18 años o más.',
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          key: const Key('birth-date-button'),
          icon: const Icon(Icons.cake_outlined),
          label: Text(
            birth == null
                ? 'Elegir fecha de nacimiento'
                : 'Nací el ${formatDate(birth)}',
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate:
                  birth ?? DateTime(today.year - 25, today.month, today.day),
              firstDate: DateTime(1920),
              lastDate: today,
              helpText: 'Fecha de nacimiento',
              initialEntryMode: DatePickerEntryMode.input,
            );
            if (picked != null) {
              ref.read(onboardingProvider.notifier).setBirthDate(picked);
            }
          },
        ),
        if (underage) ...[
          const SizedBox(height: 12),
          Text(
            'Debes tener al menos 18 años para trabajar en SISI.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _DocumentsStep extends ConsumerStatefulWidget {
  const _DocumentsStep({required this.profile});

  final WorkerProfile profile;

  @override
  ConsumerState<_DocumentsStep> createState() => _DocumentsStepState();
}

class _DocumentsStepState extends ConsumerState<_DocumentsStep> {
  DocumentType? _uploading;

  Future<void> _upload(DocumentType type) async {
    final origin = await showImageSourceSheet(context);
    if (origin == null) return;
    final image = await ref
        .read(imagePickerProvider)
        .pick(origin, frontCamera: type == DocumentType.selfie);
    if (image == null) return;
    setState(() => _uploading = type);
    try {
      await ref.read(workerRepositoryProvider).uploadDocument(type, image);
      ref.invalidate(workerProfileProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiException.from(e).message)));
      }
    } finally {
      if (mounted) setState(() => _uploading = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Las fotos de tu carnet solo las ve el equipo de SISI para verificar tu identidad.',
        ),
        const SizedBox(height: 16),
        for (final type in DocumentType.values)
          Card(
            child: ListTile(
              key: Key('document-${type.apiValue}'),
              leading: Icon(
                widget.profile.hasDocument(type)
                    ? Icons.check_circle
                    : Icons.add_a_photo_outlined,
                color: widget.profile.hasDocument(type)
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text(type.label),
              subtitle: Text(
                widget.profile.hasDocument(type) ? 'Foto subida' : type.hint,
              ),
              trailing: _uploading == type
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.profile.hasDocument(type) ? 'Cambiar' : 'Subir',
                    ),
              onTap: _uploading == null ? () => _upload(type) : null,
            ),
          ),
      ],
    );
  }
}

class _CategoriesStep extends ConsumerWidget {
  const _CategoriesStep({required this.draft});

  final OnboardingDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(categoriesProvider)) {
      AsyncData(value: final categories) when categories.isEmpty => const Column(
        key: Key('categories-empty'),
        children: [
          SizedBox(height: 24),
          Icon(Icons.category_outlined, size: 48),
          SizedBox(height: 12),
          Text(
            'Todavía no hay categorías disponibles',
            style: TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'Las estamos preparando. Vuelve pronto para completar tu solicitud; '
            'lo que ya subiste queda guardado.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      AsyncData(value: final categories) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Elige los servicios que ofreces.'),
          const SizedBox(height: 8),
          for (final category in categories)
            CheckboxListTile(
              value: draft.categoryIds.contains(category.id),
              onChanged: (_) => ref
                  .read(onboardingProvider.notifier)
                  .toggleCategory(category.id),
              title: Text(category.name),
              subtitle: Text(
                'Referencia: Bs ${category.priceMinBs} a Bs ${category.priceMaxBs}',
              ),
            ),
        ],
      ),
      AsyncError(:final error) => Text(ApiException.from(error).message),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _TransportStep extends ConsumerWidget {
  const _TransportStep({required this.draft});

  final OnboardingDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(onboardingProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '¿Cómo te mueves hasta los trabajos? El precio que ofertes incluye el traslado.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final mode in TransportMode.values)
              ChoiceChip(
                label: Text(mode.label),
                selected: draft.transport == mode,
                onSelected: (_) => controller.setTransport(mode),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text('¿Hasta qué distancia aceptas trabajos? ${draft.radiusKm} km'),
        Slider(
          value: draft.radiusKm.toDouble(),
          min: minRadiusKm.toDouble(),
          max: maxRadiusKm.toDouble(),
          divisions: maxRadiusKm - minRadiusKm,
          label: '${draft.radiusKm} km',
          onChanged: (value) => controller.setRadius(value.round()),
        ),
      ],
    );
  }
}

class _SummaryStep extends StatelessWidget {
  const _SummaryStep({required this.draft, required this.categories});

  final OnboardingDraft draft;
  final List<Category>? categories;

  @override
  Widget build(BuildContext context) {
    final names = (categories ?? const <Category>[])
        .where((c) => draft.categoryIds.contains(c.id))
        .map((c) => c.name)
        .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Revisa tus datos antes de enviar.'),
        ListTile(
          title: const Text('Fecha de nacimiento'),
          subtitle: Text(
            draft.birthDate == null ? '-' : formatDate(draft.birthDate!),
          ),
        ),
        const ListTile(
          title: Text('Documentos'),
          subtitle: Text('Carnet (ambos lados) y selfie'),
        ),
        ListTile(
          title: const Text('Categorías'),
          subtitle: Text(names.isEmpty ? '-' : names),
        ),
        ListTile(
          title: const Text('Transporte'),
          subtitle: Text(draft.transport?.label ?? '-'),
        ),
        ListTile(
          title: const Text('Radio de trabajo'),
          subtitle: Text('${draft.radiusKm} km'),
        ),
        const SizedBox(height: 8),
        const Text(
          'Revisaremos tu solicitud y te avisaremos cuando esté aprobada.',
        ),
      ],
    );
  }
}
