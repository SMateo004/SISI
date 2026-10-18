import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/session.dart';
import '../config/env.dart';
import '../realtime/counters.dart';

class _Section {
  const _Section(this.path, this.label, this.icon, [this.badge]);

  final String path;
  final String label;
  final IconData icon;
  final int Function(Counters c)? badge;
}

final _sections = <_Section>[
  const _Section('/', 'Dashboard', Icons.dashboard_outlined),
  _Section(
    '/verificaciones',
    'Verificaciones',
    Icons.badge_outlined,
    (c) => c.verifications,
  ),
  _Section(
    '/moderacion',
    'Moderación',
    Icons.shield_outlined,
    (c) => c.moderation,
  ),
  _Section('/cobros', 'Cobros', Icons.payments_outlined, (c) => c.submissions),
  const _Section('/usuarios', 'Usuarios', Icons.people_outline),
  const _Section('/catalogo', 'Catálogo', Icons.category_outlined),
  const _Section('/configuracion', 'Configuración', Icons.tune),
  const _Section('/auditoria', 'Auditoría', Icons.history),
];

int _selectedIndex(String location) {
  for (var i = _sections.length - 1; i > 0; i--) {
    if (location.startsWith(_sections[i].path)) return i;
  }
  return 0;
}

/// Marco del panel: menú lateral con contadores en vivo (ADR-0044), usuario y salir.
/// En escritorio el menú va extendido; en tablet, solo íconos.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(countersProvider);
    final session = ref.watch(sessionProvider);
    final user = session is SignedIn ? session.user : null;
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            key: const Key('nav-rail'),
            extended: wide,
            minExtendedWidth: 220,
            selectedIndex: _selectedIndex(location),
            onDestinationSelected: (i) => context.go(_sections[i].path),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    'SISI',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!Env.isProduction)
                    Text(
                      Env.appEnv,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (wide && user != null)
                        Text(
                          user.name ?? user.phone,
                          style: theme.textTheme.bodySmall,
                        ),
                      IconButton(
                        key: const Key('logout'),
                        tooltip: 'Salir',
                        icon: const Icon(Icons.logout),
                        onPressed: () =>
                            ref.read(sessionProvider.notifier).logout(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: [
              for (final s in _sections)
                NavigationRailDestination(
                  icon: _badged(s, counters, Icon(s.icon)),
                  label: Text(s.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _badged(_Section s, Counters counters, Widget icon) {
    final n = s.badge?.call(counters) ?? 0;
    if (n == 0) return icon;
    return Badge(key: Key('badge-${s.path}'), label: Text('$n'), child: icon);
  }
}
