import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_gate/app_gate.dart';
import '../../core/config/env.dart';
import '../../core/links/url_opener.dart';
import '../../core/router/routes.dart';

/// Texto de la versión instalada (ADR-0054).
String appVersionLabel() {
  if (Env.appVersion.isEmpty) return 'Versión de desarrollo';
  final build = Env.appBuild.isEmpty ? '' : ' (${Env.appBuild})';
  return 'Versión ${Env.appVersion}$build';
}

/// Acerca de: versión, ambiente, textos legales, ayuda y eliminar la cuenta.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final support = ref.watch(appGateProvider).support;
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        children: [
          ListTile(
            key: const Key('about-version'),
            leading: const Icon(Icons.info_outline),
            title: Text(appVersionLabel()),
            subtitle: Env.isProduction ? null : Text('Ambiente: ${Env.appEnv}'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Términos de uso'),
            onTap: () => context.push(Routes.legalDocument('terms')),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Política de privacidad'),
            onTap: () => context.push(Routes.legalDocument('privacy')),
          ),
          if (support != null)
            ListTile(
              key: const Key('about-support'),
              leading: const Icon(Icons.support_agent),
              title: const Text('Ayuda por WhatsApp'),
              subtitle: Text(support.whatsapp),
              onTap: () => ref.read(urlOpenerProvider)(support.url),
            ),
          const Divider(),
          ListTile(
            key: const Key('about-delete'),
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            title: const Text('Eliminar mi cuenta'),
            onTap: () => context.push(Routes.deleteAccount),
          ),
        ],
      ),
    );
  }
}
