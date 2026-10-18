import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';

const _tabs = [('categorias', 'Categorías'), ('ciudades', 'Ciudades')];

final categoriesProvider = FutureProvider.autoDispose<List<AdminCategoryDto>>((
  ref,
) async {
  final res = await ref.watch(adminApiProvider).adminCategoriesControllerList();
  return res.data!;
});

final citiesProvider = FutureProvider.autoDispose<List<AdminCityDto>>((
  ref,
) async {
  final res = await ref.watch(adminApiProvider).adminCitiesControllerList();
  return res.data!;
});

/// Catálogo (R2.2, R10.1): categorías con rango, comisión, requisitos y valores por ciudad.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key, required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeader(
        'Catálogo',
        actions: [
          if (tab != 'ciudades')
            FilledButton.icon(
              key: const Key('category-new'),
              onPressed: () => _edit(context, ref, null),
              icon: const Icon(Icons.add),
              label: const Text('Nueva categoría'),
            ),
        ],
      ),
      SectionTabs(
        tabs: _tabs,
        current: tab,
        onSelect: (t) => context.go('/catalogo/$t'),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: tab == 'ciudades' ? const _Cities() : const _Categories(),
      ),
    ],
  );
}

class _Categories extends ConsumerWidget {
  const _Categories();

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(categoriesProvider),
    onRetry: () => ref.invalidate(categoriesProvider),
    data: (list) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        for (final c in list)
          Card(
            child: ListTile(
              key: Key('category-${c.slug}'),
              title: Text('${c.name}${c.active ? '' : ' (inactiva)'}'),
              subtitle: Text(
                '${formatBs(c.priceMinBs)} a ${formatBs(c.priceMaxBs)} · comisión ${c.commissionPct.replaceAll('.', ',')} %'
                '${c.extraRequirements.isEmpty ? '' : ' · requisitos: ${c.extraRequirements.join(', ')}'}'
                '\n${c.cities.map((cc) => '${cc.citySlug}: ${cc.active ? 'activa' : 'inactiva'}, ${cc.effectiveCommissionPct.replaceAll('.', ',')} %').join(' · ')}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.edit),
              onTap: () => _edit(context, ref, c),
            ),
          ),
      ],
    ),
  );
}

class _Cities extends ConsumerWidget {
  const _Cities();

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(citiesProvider),
    data: (list) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        const Text(
          'Las ciudades se agregan por seed o migración (solo lectura en el MVP).',
        ),
        for (final c in list)
          ListTile(
            title: Text(c.name),
            subtitle: Text(
              '${c.slug} · ${c.timezone}${c.active ? '' : ' · inactiva'}',
            ),
          ),
      ],
    ),
  );
}

/// Formulario de categoría (nueva o existente) y, al guardar, confirmación con motivo.
Future<void> _edit(
  BuildContext context,
  WidgetRef ref,
  AdminCategoryDto? current,
) async {
  final cities = await ref.read(citiesProvider.future);
  if (!context.mounted) return;
  final form = await showDialog<_CategoryForm>(
    context: context,
    builder: (_) => _CategoryDialog(current: current, cities: cities),
  );
  if (form == null || !context.mounted) return;
  final api = ref.read(adminApiProvider);
  final commissionChanges =
      current != null && form.commissionPct != current.commissionPct;
  final saved = await confirmAction<AdminCategoryDto>(
    context,
    title: current == null ? 'Crear categoría' : 'Guardar cambios',
    message: commissionChanges
        ? 'La comisión nueva solo se aplica a los trabajos asignados desde ahora. Los ya asignados conservan su comisión.'
        : current == null
        ? 'Queda activa en las ciudades elegidas.'
        : 'Cambia "${current.name}".',
    confirmLabel: 'Guardar',
    onConfirm: (input) async {
      if (current == null) {
        final res = await api.adminCategoriesControllerCreate(
          createCategoryDto: CreateCategoryDto(
            slug: form.slug,
            name: form.name,
            description: form.description,
            priceMinBs: form.priceMinBs,
            priceMaxBs: form.priceMaxBs,
            commissionPct: form.commissionPct,
            extraRequirements: form.extraRequirements,
            cityIds: form.cityIds,
            reason: input.note,
          ),
        );
        return res.data!;
      }
      final res = await api.adminCategoriesControllerUpdate(
        id: current.id,
        updateCategoryDto: UpdateCategoryDto(
          name: form.name,
          description: form.description,
          priceMinBs: form.priceMinBs,
          priceMaxBs: form.priceMaxBs,
          commissionPct: form.commissionPct,
          active: form.active,
          extraRequirements: form.extraRequirements,
          reason: input.note,
        ),
      );
      return res.data!;
    },
  );
  if (saved != null && context.mounted) {
    showDone(context, saved.notice ?? 'Categoría guardada.');
    ref.invalidate(categoriesProvider);
  }
}

class _CategoryForm {
  const _CategoryForm({
    required this.slug,
    required this.name,
    required this.description,
    required this.priceMinBs,
    required this.priceMaxBs,
    required this.commissionPct,
    required this.active,
    required this.extraRequirements,
    required this.cityIds,
  });

  final String slug;
  final String name;
  final String? description;
  final String priceMinBs;
  final String priceMaxBs;
  final String commissionPct;
  final bool active;
  final List<String> extraRequirements;
  final List<String> cityIds;
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({required this.current, required this.cities});

  final AdminCategoryDto? current;
  final List<AdminCityDto> cities;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final c = widget.current;
  late final _slug = TextEditingController(text: c?.slug);
  late final _name = TextEditingController(text: c?.name);
  late final _description = TextEditingController(text: c?.description);
  late final _min = TextEditingController(
    text: c?.priceMinBs.replaceAll('.', ','),
  );
  late final _max = TextEditingController(
    text: c?.priceMaxBs.replaceAll('.', ','),
  );
  late final _pct = TextEditingController(
    text: (c?.commissionPct ?? '13.00').replaceAll('.', ','),
  );
  late final _reqs = TextEditingController(
    text: c?.extraRequirements.join(', '),
  );
  late bool _active = c?.active ?? true;
  late final _cityIds = <String>{
    if (c == null) ...widget.cities.map((x) => x.id),
  };

  @override
  void dispose() {
    for (final t in [_slug, _name, _description, _min, _max, _pct, _reqs]) {
      t.dispose();
    }
    super.dispose();
  }

  String? _money(TextEditingController t) {
    final cents = parseBsCents(t.text);
    return cents == null ? null : centsToApi(cents);
  }

  @override
  Widget build(BuildContext context) {
    final min = _money(_min);
    final max = _money(_max);
    final pct = _money(_pct);
    final valid =
        min != null &&
        max != null &&
        pct != null &&
        _name.text.trim().length >= 2 &&
        (c != null ||
            RegExp(r'^[a-z][a-z0-9-]{1,39}$').hasMatch(_slug.text.trim()));
    return AlertDialog(
      title: Text(c == null ? 'Nueva categoría' : c!.name),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (c == null)
                TextField(
                  key: const Key('category-slug'),
                  controller: _slug,
                  decoration: const InputDecoration(
                    labelText: 'Slug (minúsculas, no cambia después)',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              TextField(
                key: const Key('category-name'),
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('category-min'),
                      controller: _min,
                      decoration: const InputDecoration(
                        labelText: 'Mínimo',
                        prefixText: 'Bs ',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      key: const Key('category-max'),
                      controller: _max,
                      decoration: const InputDecoration(
                        labelText: 'Máximo',
                        prefixText: 'Bs ',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              TextField(
                key: const Key('category-pct'),
                controller: _pct,
                decoration: const InputDecoration(
                  labelText: 'Comisión',
                  suffixText: '%',
                  helperText:
                      'Solo afecta a los trabajos asignados desde que se guarda.',
                ),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: _reqs,
                decoration: const InputDecoration(
                  labelText: 'Requisitos extra (separados por coma)',
                  hintText: 'certificado_electricista',
                ),
              ),
              if (c != null)
                SwitchListTile(
                  title: const Text('Activa'),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
              if (c == null)
                for (final city in widget.cities)
                  CheckboxListTile(
                    title: Text('Activa en ${city.name}'),
                    value: _cityIds.contains(city.id),
                    onChanged: (v) => setState(
                      () => v == true
                          ? _cityIds.add(city.id)
                          : _cityIds.remove(city.id),
                    ),
                  ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('category-next'),
          onPressed: !valid
              ? null
              : () => Navigator.pop(
                  context,
                  _CategoryForm(
                    slug: _slug.text.trim(),
                    name: _name.text.trim(),
                    description: _description.text.trim().isEmpty
                        ? null
                        : _description.text.trim(),
                    priceMinBs: min,
                    priceMaxBs: max,
                    commissionPct: pct,
                    active: _active,
                    extraRequirements: _reqs.text
                        .split(',')
                        .map((s) => s.trim().toLowerCase().replaceAll(' ', '_'))
                        .where((s) => s.isNotEmpty)
                        .toList(),
                    cityIds: _cityIds.toList(),
                  ),
                ),
          child: const Text('Siguiente'),
        ),
      ],
    );
  }
}
