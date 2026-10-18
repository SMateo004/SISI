import 'package:flutter/material.dart';

import '../http/api_error.dart';

/// Una página del servidor: filas y cursor para la siguiente (null = no hay más).
class PageResult<T> {
  const PageResult(this.items, this.nextCursor);

  final List<T> items;
  final String? nextCursor;
}

class ServerColumn<T> {
  const ServerColumn(this.label, this.cell, {this.numeric = false});

  final String label;
  final Widget Function(T row) cell;
  final bool numeric;
}

/// Tabla paginada desde el servidor (Fase 6): pide la primera página, agrega las
/// siguientes con "Cargar más" y vuelve a empezar cuando cambian los filtros
/// ([reloadKey]). Para recargar después de una acción, se cambia [reloadKey].
class ServerTable<T> extends StatefulWidget {
  const ServerTable({
    super.key,
    required this.load,
    required this.columns,
    required this.reloadKey,
    this.onTap,
    this.empty = 'No hay nada por aquí.',
  });

  final Future<PageResult<T>> Function(String? cursor) load;
  final List<ServerColumn<T>> columns;
  final Object? reloadKey;
  final void Function(T row)? onTap;
  final String empty;

  @override
  State<ServerTable<T>> createState() => _ServerTableState<T>();
}

class _ServerTableState<T> extends State<ServerTable<T>> {
  final _rows = <T>[];
  String? _cursor;
  bool _loading = false;
  bool _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(covariant ServerTable<T> old) {
    super.didUpdateWidget(old);
    if (old.reloadKey != widget.reloadKey) _reset();
  }

  void _reset() {
    _rows.clear();
    _cursor = null;
    _done = false;
    _error = null;
    _more();
  }

  Future<void> _more() async {
    if (_loading || _done) return;
    final key = widget.reloadKey;
    setState(() => _loading = true);
    try {
      final page = await widget.load(_cursor);
      if (!mounted || key != widget.reloadKey) return;
      setState(() {
        _rows.addAll(page.items);
        _cursor = page.nextCursor;
        _done = page.nextCursor == null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = ApiError.from(error).message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, key: const Key('table-error')),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _reset, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (_rows.isEmpty && _loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_rows.isEmpty) {
      return Center(child: Text(widget.empty, key: const Key('table-empty')));
    }
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    for (final c in widget.columns)
                      DataColumn(label: Text(c.label), numeric: c.numeric),
                  ],
                  rows: [
                    for (final row in _rows)
                      DataRow(
                        onSelectChanged: widget.onTap == null
                            ? null
                            : (_) => widget.onTap!(row),
                        cells: [
                          for (final c in widget.columns) DataCell(c.cell(row)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (!_done)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: _loading
                      ? const CircularProgressIndicator()
                      : OutlinedButton(
                          key: const Key('table-more'),
                          onPressed: _more,
                          child: const Text('Cargar más'),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
