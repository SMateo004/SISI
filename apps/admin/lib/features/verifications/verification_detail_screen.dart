import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/http/api_client.dart';
import '../../core/realtime/counters.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';

/// Motivos de rechazo (lista cerrada, Fase 6) y cómo los lee el admin.
const rejectionReasons = <(String, String)>[
  ('documento_ilegible', 'Documento ilegible'),
  ('documento_no_coincide', 'El documento no coincide con la cuenta'),
  ('selfie_no_coincide', 'La selfie no coincide con el carnet'),
  ('menor_de_edad', 'Menor de edad'),
  ('documento_vencido', 'Documento vencido'),
  ('requisitos_de_categoria', 'Falta un requisito de categoría'),
  ('datos_incompletos', 'Datos incompletos'),
  ('otro', 'Otro'),
];

const _documentLabels = {
  'ci_front': 'Carnet (anverso)',
  'ci_back': 'Carnet (reverso)',
  'selfie': 'Selfie',
  'cert': 'Certificado',
};

final verificationProvider = FutureProvider.autoDispose
    .family<VerificationDetailDto, String>((ref, userId) async {
      final res = await ref
          .watch(adminApiProvider)
          .verificationsControllerDetail(userId: userId);
      return res.data!;
    });

/// Revisión de una solicitud de trabajador: datos, edad, categorías con requisitos extra y
/// documentos por URL de 5 minutos (R9.5): se ven en la página, sin botón de descarga.
class VerificationDetailScreen extends ConsumerWidget {
  const VerificationDetailScreen({super.key, required this.userId});

  final String userId;

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    final ok = await confirmAction<bool>(
      context,
      title: 'Aprobar trabajador',
      message: 'El perfil pasa a aprobado y se le avisa con push.',
      confirmLabel: 'Aprobar',
      noteLabel: 'Nota',
      noteHint: 'Ej.: documentos claros y completos',
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .verificationsControllerApprove(
              userId: userId,
              approveVerificationDto: ApproveVerificationDto(note: input.note),
            );
        return true;
      },
    );
    if (ok == true && context.mounted) {
      _done(context, ref, 'Trabajador aprobado.');
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final ok = await confirmAction<bool>(
      context,
      title: 'Rechazar solicitud',
      message:
          'El trabajador ve el motivo y la nota, y puede corregir y volver a enviar.',
      confirmLabel: 'Rechazar',
      destructive: true,
      reasons: rejectionReasons,
      noteLabel: 'Nota para el trabajador',
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .verificationsControllerReject(
              userId: userId,
              rejectVerificationDto: RejectVerificationDto(
                reason: RejectVerificationDtoReasonEnum.values.firstWhere(
                  (e) => e.value == input.reasonCode,
                ),
                note: input.note,
              ),
            );
        return true;
      },
    );
    if (ok == true && context.mounted) {
      _done(context, ref, 'Solicitud rechazada.');
    }
  }

  void _done(BuildContext context, WidgetRef ref, String message) {
    showDone(context, message);
    ref.invalidate(verificationProvider(userId));
    ref.read(countersProvider.notifier).refresh();
    context.go('/verificaciones');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(verificationProvider(userId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          'Solicitud de trabajador',
          subtitle: value.value?.name ?? value.value?.phone,
          actions: [
            if (value.value?.status == 'pendiente_revision') ...[
              OutlinedButton(
                key: const Key('verification-reject'),
                onPressed: () => _reject(context, ref),
                child: const Text('Rechazar'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const Key('verification-approve'),
                onPressed: () => _approve(context, ref),
                child: const Text('Aprobar'),
              ),
            ],
          ],
        ),
        Expanded(
          child: AsyncBody(
            value: value,
            onRetry: () => ref.invalidate(verificationProvider(userId)),
            data: (d) => ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                InfoRow('Estado', d.status.replaceAll('_', ' ')),
                InfoRow('Celular', d.phone),
                InfoRow('Ciudad', d.cityName),
                InfoRow('Enviada', formatDateTime(d.submittedAt)),
                InfoRow(
                  'Fecha de nacimiento',
                  d.birthDate == null
                      ? '—'
                      : '${formatCalendarDate(d.birthDate!)} (${d.age ?? '—'} años)',
                ),
                InfoRow('Transporte', d.transport?.replaceAll('_', ' ') ?? '—'),
                InfoRow(
                  'Radio',
                  d.maxRadiusKm == null ? '—' : '${d.maxRadiusKm} km',
                ),
                const SizedBox(height: 12),
                Text(
                  'Categorías',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final c in d.categoryDetails)
                  InfoRow(
                    c.name,
                    c.extraRequirements.isEmpty
                        ? 'Sin requisitos extra'
                        : 'Requisitos extra: ${c.extraRequirements.join(', ').replaceAll('_', ' ')}',
                  ),
                const SizedBox(height: 16),
                Text(
                  'Documentos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Enlaces de 5 minutos. Si vencen, actualiza la página.',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final doc in d.documents)
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _documentLabels[doc.type.value] ?? doc.type.value,
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                doc.url,
                                key: Key('doc-${doc.type.value}'),
                                height: 220,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const SizedBox(
                                  height: 220,
                                  child: Center(
                                    child: Text(
                                      'No se pudo cargar (¿venció el enlace?)',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
