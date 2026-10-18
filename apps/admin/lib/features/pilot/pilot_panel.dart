import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/files/download.dart';
import '../../core/format/dates.dart';
import '../../core/http/api_client.dart';
import '../../core/http/api_error.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';

final pilotOverviewProvider = FutureProvider.autoDispose<PilotOverviewDto>((
  ref,
) async {
  final res = await ref.watch(adminApiProvider).adminPilotControllerOverview();
  return res.data!;
});

final pilotInterestProvider =
    FutureProvider.autoDispose<List<PilotInterestRowDto>>((ref) async {
      final res = await ref
          .watch(adminApiProvider)
          .adminPilotControllerInterest();
      return res.data!;
    });

const _roles = {
  'worker': 'Trabajar',
  'employer': 'Contratar',
  'ambos': 'Las dos',
};

/// Piloto cerrado (ADR-0052): lista de números habilitados e interés de los demás.
/// Encender o apagar el piloto es el flag `pilot.closed` de la ciudad.
class PilotPanel extends ConsumerStatefulWidget {
  const PilotPanel({super.key});

  @override
  ConsumerState<PilotPanel> createState() => _PilotPanelState();
}

class _PilotPanelState extends ConsumerState<PilotPanel> {
  final _phones = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _phones.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final phones = _phones.text
        .split(RegExp(r'[\n,;]+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (phones.isEmpty) return;
    final result = await confirmAction<AddPilotPhonesResultDto>(
      context,
      title: 'Habilitar ${phones.length} números',
      message: 'Podrán crear su cuenta aunque el piloto esté cerrado.',
      confirmLabel: 'Habilitar',
      onConfirm: (input) async {
        final res = await ref
            .read(adminApiProvider)
            .adminPilotControllerAdd(
              addPilotPhonesDto: AddPilotPhonesDto(
                phones: phones,
                note: _note.text.trim().isEmpty ? null : _note.text.trim(),
                reason: input.note,
              ),
            );
        return res.data!;
      },
    );
    if (result == null || !mounted) return;
    _phones.clear();
    ref.invalidate(pilotOverviewProvider);
    showDone(
      context,
      'Agregados: ${result.added.length}. Ya estaban: ${result.alreadyListed.length}.'
      '${result.invalid.isEmpty ? '' : ' Inválidos: ${result.invalid.join(', ')}'}',
    );
  }

  Future<void> _remove(PilotPhoneDto phone) async {
    final ok = await confirmAction<bool>(
      context,
      title: 'Quitar ${phone.phone}',
      message:
          'Si ya creó su cuenta, la conserva. Un número nuevo no podrá entrar.',
      confirmLabel: 'Quitar',
      destructive: true,
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .adminPilotControllerRemove(
              id: phone.id,
              removePilotPhoneDto: RemovePilotPhoneDto(reason: input.note),
            );
        return true;
      },
    );
    if (ok == true) ref.invalidate(pilotOverviewProvider);
  }

  Future<void> _downloadCsv() async {
    try {
      final res = await ref
          .read(dioProvider)
          .get<List<int>>(
            '/admin/pilot/interest.csv',
            options: Options(responseType: ResponseType.bytes),
          );
      saveFile(
        Uint8List.fromList(res.data ?? const []),
        'interes-piloto.csv',
        'text/csv',
      );
    } catch (error) {
      if (mounted) showDone(context, ApiError.from(error).message);
    }
  }

  @override
  Widget build(BuildContext context) => AsyncBody(
    value: ref.watch(pilotOverviewProvider),
    onRetry: () => ref.invalidate(pilotOverviewProvider),
    data: (o) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        Card(
          key: const Key('pilot-status'),
          child: ListTile(
            leading: Icon(o.closed ? Icons.lock_outline : Icons.lock_open),
            title: Text(
              o.closed
                  ? 'Piloto cerrado en ${o.cityName}: solo números de la lista'
                  : 'Piloto abierto en ${o.cityName}: cualquiera puede crear su cuenta',
            ),
            subtitle: const Text(
              'Se enciende o apaga con el flag pilot.closed de la ciudad. Carga la lista antes de cerrarlo.',
            ),
            trailing: TextButton(
              onPressed: () => context.go('/configuracion/flags'),
              child: const Text('Ir a flags'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Habilitar números',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('pilot-phones'),
          controller: _phones,
          minLines: 3,
          maxLines: 8,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Uno por línea (con o sin +591)',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _note,
          decoration: const InputDecoration(
            labelText: 'Nota (opcional, p. ej. el grupo o la zona)',
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            key: const Key('pilot-add'),
            onPressed: _add,
            child: const Text('Habilitar'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'En la lista (${o.allowlist.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        for (final p in o.allowlist)
          ListTile(
            key: Key('pilot-phone-${p.phone}'),
            dense: true,
            title: Text(p.phone),
            subtitle: Text(
              '${formatDateTime(p.createdAt)}${p.note == null ? '' : ' · ${p.note}'}',
            ),
            trailing: IconButton(
              tooltip: 'Quitar',
              icon: const Icon(Icons.person_remove_outlined),
              onPressed: () => _remove(p),
            ),
          ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Interés: "Pronto en tu zona" (${o.interestCount})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: _downloadCsv,
              icon: const Icon(Icons.download),
              label: const Text('CSV'),
            ),
          ],
        ),
        AsyncBody(
          value: ref.watch(pilotInterestProvider),
          data: (rows) => Column(
            children: [
              for (final r in rows)
                ListTile(
                  dense: true,
                  title: Text('${r.phone} · ${_roles[r.role.name] ?? r.role.name}'),
                  subtitle: Text(
                    [
                      formatDateTime(r.createdAt),
                      ?r.categoryName,
                      ?r.zone,
                    ].join(' · '),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
