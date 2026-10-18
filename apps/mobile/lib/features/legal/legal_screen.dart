import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_gate/app_gate.dart';
import '../../core/app_gate/client_app_repository.dart';
import '../../core/auth/session_controller.dart';
import '../../core/http/api_exception.dart';
import '../../core/router/routes.dart';

final legalDocumentsProvider = FutureProvider.autoDispose<List<LegalDocument>>(
  (ref) => ref.watch(clientAppRepositoryProvider).legalDocuments(),
);

/// Aviso bien visible mientras el texto no tiene revisión legal (ADR-0051).
class DraftBanner extends StatelessWidget {
  const DraftBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      key: const Key('legal-draft-banner'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'BORRADOR: este texto todavía no tiene revisión legal.',
        style: TextStyle(
          color: scheme.onErrorContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Los textos v0 valen solo para el piloto cerrado con usuarios invitados (ADR-0051).
class PilotTextsBanner extends StatelessWidget {
  const PilotTextsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      key: const Key('legal-pilot-banner'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Versión v0 del piloto cerrado: vale solo para los usuarios invitados. '
        'Antes de abrir la app al público te pediremos aceptar la versión definitiva.',
        style: TextStyle(color: scheme.onSecondaryContainer),
      ),
    );
  }
}

/// Aceptar los términos de uso y la política de privacidad vigentes, y declarar la mayoría
/// de edad (registro y cada versión nueva, ADR-0051). Sin aceptar no se puede seguir.
class LegalScreen extends ConsumerStatefulWidget {
  const LegalScreen({super.key});

  @override
  ConsumerState<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends ConsumerState<LegalScreen> {
  bool _accepted = false;
  bool _adult = false;
  bool _sending = false;
  String? _error;

  Future<void> _submit(List<LegalDocument> docs) async {
    int version(String type) => docs.firstWhere((d) => d.type == type).version;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref
          .read(clientAppRepositoryProvider)
          .acceptLegal(
            termsVersion: version('terms'),
            privacyVersion: version('privacy'),
          );
      ref.read(appGateProvider.notifier).legalAccepted();
      if (mounted) context.go(Routes.home);
    } catch (e) {
      final error = ApiException.from(e);
      // Salió otra versión mientras se leía: se vuelven a cargar los textos.
      if (error.code == 'LEGAL_VERSION_CHANGED') {
        ref.invalidate(legalDocumentsProvider);
      }
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docs = ref.watch(legalDocumentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antes de empezar'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => ref.read(sessionProvider.notifier).signOut(),
            child: const Text('Salir'),
          ),
        ],
      ),
      body: docs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ApiException.from(e).message),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.invalidate(legalDocumentsProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (list) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Para usar la app, revisa y acepta estos textos.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final d in list)
              Card(
                child: ListTile(
                  key: Key('legal-doc-${d.type}'),
                  leading: Icon(
                    d.type == 'privacy'
                        ? Icons.privacy_tip_outlined
                        : Icons.description_outlined,
                  ),
                  title: Text(d.title),
                  subtitle: Text(
                    'Versión ${d.version}'
                    '${d.pilotOnly ? ' · Piloto cerrado' : ''}'
                    '${d.draft ? ' · BORRADOR' : ''}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.legalDocument(d.type)),
                ),
              ),
            if (list.any((d) => d.pilotOnly)) ...[
              const SizedBox(height: 8),
              const PilotTextsBanner(),
            ],
            if (list.any((d) => d.draft)) ...[
              const SizedBox(height: 8),
              const DraftBanner(),
            ],
            const SizedBox(height: 16),
            CheckboxListTile(
              key: const Key('legal-accept'),
              value: _accepted,
              onChanged: (v) => setState(() => _accepted = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Leí y acepto los Términos de uso y la Política de privacidad.',
              ),
            ),
            CheckboxListTile(
              key: const Key('legal-adult'),
              value: _adult,
              onChanged: (v) => setState(() => _adult = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Declaro ser mayor de 18 años.'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('legal-continue'),
              onPressed: _accepted && _adult && !_sending
                  ? () => _submit(list)
                  : null,
              child: Text(_sending ? 'Guardando…' : 'Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lectura de un texto legal vigente (desde el registro o desde "Acerca de").
class LegalDocumentScreen extends ConsumerWidget {
  const LegalDocumentScreen({super.key, required this.type});

  /// `terms` o `privacy`.
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(legalDocumentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 'privacy' ? 'Política de privacidad' : 'Términos de uso',
        ),
      ),
      body: docs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(ApiException.from(e).message)),
        data: (list) {
          final doc = list.where((d) => d.type == type).firstOrNull;
          if (doc == null) return const Center(child: Text('No disponible.'));
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (doc.draft) ...[
                const DraftBanner(),
                const SizedBox(height: 16),
              ],
              if (doc.pilotOnly) ...[
                const PilotTextsBanner(),
                const SizedBox(height: 16),
              ],
              Text(
                'Versión ${doc.version}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 12),
              ..._paragraphs(context, doc.content),
            ],
          );
        },
      ),
    );
  }

  /// Markdown simple a texto: títulos (#), viñetas (-) y párrafos. Sin dependencias.
  List<Widget> _paragraphs(BuildContext context, String md) {
    final theme = Theme.of(context).textTheme;
    return [
      for (final raw in md.split('\n'))
        if (raw.trim().isNotEmpty && !raw.trim().startsWith('|---'))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectableText(
              raw
                  .replaceAll(RegExp(r'^#+\s*'), '')
                  .replaceAll('**', '')
                  .replaceAll(RegExp(r'^\s*-\s+'), '• ')
                  .replaceAll(RegExp(r'\s*\|\s*'), '  ')
                  .trim(),
              style: raw.startsWith('#') ? theme.titleMedium : theme.bodyMedium,
            ),
          ),
    ];
  }
}
