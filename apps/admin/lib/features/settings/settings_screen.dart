import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';
import '../pilot/pilot_panel.dart';

const _tabs = [
  ('parametros', 'Parámetros'),
  ('flags', 'Feature flags'),
  ('piloto', 'Piloto'),
];

const _groups = {
  'matching': 'Matching',
  'ofertas': 'Ofertas',
  'trabajos': 'Trabajos',
  'cobros': 'Cobros',
  'app': 'App y piloto',
};

final settingsProvider = FutureProvider.autoDispose<List<SettingDto>>((
  ref,
) async {
  final res = await ref.watch(adminApiProvider).adminSettingsControllerList();
  return res.data!;
});

final flagsProvider = FutureProvider.autoDispose<List<FeatureFlagDto>>((
  ref,
) async {
  final res = await ref.watch(adminApiProvider).featureFlagsControllerList();
  return res.data!;
});

/// Configuración (R10.2, ADR-0043): parámetros de negocio y feature flags.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeader('Configuración'),
      SectionTabs(
        tabs: _tabs,
        current: tab,
        onSelect: (t) => context.go('/configuracion/$t'),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: switch (tab) {
          'flags' => const _Flags(),
          'piloto' => const PilotPanel(),
          _ => const _Parameters(),
        },
      ),
    ],
  );
}

/// Valor para leer, en la unidad del parámetro.
String describeSetting(SettingDto s, String value) {
  final n = num.tryParse(value);
  return switch (s.unit.value) {
    'ms' when n != null => formatMs(n),
    'Bs' => formatBs(value),
    'hora' => '$value:00',
    'días' => '$value días',
    'texto' when value.isEmpty => '(vacío)',
    _ => value,
  };
}

/// Texto que escribe el admin → valor de la API (los ms se escriben en minutos).
String? toApiValue(SettingDto s, String input) {
  // Texto (WhatsApp, versión, fecha): tal cual; vacío borra el valor si el parámetro lo admite.
  if (s.unit.value == 'texto') return input.trim();
  final text = input.trim().replaceAll(',', '.');
  if (text.isEmpty) return null;
  if (s.unit.value == 'ms') {
    final minutes = num.tryParse(text);
    return minutes == null ? null : (minutes * 60000).round().toString();
  }
  return text;
}

class _Parameters extends ConsumerWidget {
  const _Parameters();

  Future<void> _edit(BuildContext context, WidgetRef ref, SettingDto s) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => _SettingDialog(s),
    );
    if (value == null || !context.mounted) return;
    final saved = await confirmAction<SettingDto>(
      context,
      title: 'Cambiar "${s.label}"',
      message:
          '${describeSetting(s, s.value)} → ${describeSetting(s, value)}. Se aplica en segundos, sin redeploy.',
      confirmLabel: 'Guardar',
      onConfirm: (input) async {
        final res = await ref
            .read(adminApiProvider)
            .adminSettingsControllerSet(
              key: s.key,
              setSettingDto: SetSettingDto(value: value, reason: input.note),
            );
        return res.data!;
      },
    );
    if (saved != null) ref.invalidate(settingsProvider);
  }

  Future<void> _reset(BuildContext context, WidgetRef ref, SettingDto s) async {
    final saved = await confirmAction<SettingDto>(
      context,
      title: 'Volver al valor por defecto',
      message: '"${s.label}" vuelve a ${describeSetting(s, s.defaultValue)}.',
      confirmLabel: 'Restablecer',
      onConfirm: (input) async {
        final res = await ref
            .read(adminApiProvider)
            .adminSettingsControllerReset(
              key: s.key,
              resetSettingDto: ResetSettingDto(reason: input.note),
            );
        return res.data!;
      },
    );
    if (saved != null) ref.invalidate(settingsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(settingsProvider),
    onRetry: () => ref.invalidate(settingsProvider),
    data: (list) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        for (final group in _groups.keys) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              _groups[group]!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final s in list.where((s) => s.group.value == group))
            ListTile(
              key: Key('setting-${s.key}'),
              title: Text(s.label),
              subtitle: Text(
                '${s.help}${s.overridden ? '\nCambiado desde el panel el ${formatIso(s.updatedAt?.toIso8601String())}' : ''}',
              ),
              isThreeLine: s.overridden,
              trailing: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    describeSetting(s, s.value),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IconButton(
                    tooltip: 'Cambiar',
                    icon: const Icon(Icons.edit),
                    onPressed: () => _edit(context, ref, s),
                  ),
                  if (s.overridden)
                    IconButton(
                      tooltip: 'Volver al valor por defecto',
                      icon: const Icon(Icons.restart_alt),
                      onPressed: () => _reset(context, ref, s),
                    ),
                ],
              ),
            ),
        ],
      ],
    ),
  );
}

class _Flags extends ConsumerWidget {
  const _Flags();

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    FeatureFlagDto f,
  ) async {
    final ok = await confirmAction<bool>(
      context,
      title: f.enabled ? 'Apagar "${f.key}"' : 'Encender "${f.key}"',
      message: f.cityId == null
          ? 'Valor global (todas las ciudades sin valor propio).'
          : 'Solo en esta ciudad.',
      confirmLabel: f.enabled ? 'Apagar' : 'Encender',
      destructive: f.enabled,
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .featureFlagsControllerSet(
              key: f.key,
              setFeatureFlagDto: SetFeatureFlagDto(
                enabled: !f.enabled,
                cityId: f.cityId,
                reason: input.note,
              ),
            );
        return true;
      },
    );
    if (ok == true) ref.invalidate(flagsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(flagsProvider),
    onRetry: () => ref.invalidate(flagsProvider),
    data: (list) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        for (final f in list)
          SwitchListTile(
            key: Key('flag-${f.key}-${f.cityId ?? 'global'}'),
            title: Text(f.key),
            subtitle: Text(
              '${f.cityId == null ? 'Global' : 'Ciudad ${f.cityId}'}${f.description == null ? '' : ' · ${f.description}'}',
            ),
            value: f.enabled,
            onChanged: (_) => _toggle(context, ref, f),
          ),
      ],
    ),
  );
}

class _SettingDialog extends StatefulWidget {
  const _SettingDialog(this.s);

  final SettingDto s;

  @override
  State<_SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<_SettingDialog> {
  late final SettingDto s = widget.s;
  late final _controller = TextEditingController(
    text: s.unit.value == 'ms'
        ? ((num.tryParse(s.value) ?? 0) / 60000).toString().replaceFirst(
            RegExp(r'\.0$'),
            '',
          )
        : s.value,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(s.label),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.help),
          const SizedBox(height: 8),
          TextField(
            key: const Key('setting-value'),
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: s.unit.value == 'ms' ? 'Minutos' : 'Valor',
              helperText: s.min == null
                  ? 'Por defecto: ${describeSetting(s, s.defaultValue)}'
                  : 'Entre ${describeSetting(s, '${s.min}')} y ${describeSetting(s, '${s.max}')}. Por defecto: ${describeSetting(s, s.defaultValue)}',
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('setting-next'),
        onPressed: () =>
            Navigator.pop(context, toApiValue(s, _controller.text)),
        child: const Text('Siguiente'),
      ),
    ],
  );
}
