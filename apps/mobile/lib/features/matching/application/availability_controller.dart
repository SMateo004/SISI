import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../data/availability_repository.dart';
import '../data/location_service.dart';
import '../domain/availability.dart';

/// No hay acceso a la ubicación (permiso o GPS apagado).
class LocationAccessException implements Exception {
  const LocationAccessException(this.access);

  final LocationAccess access;

  String get message => locationAccessMessage(access);
}

/// "Disponible" y envío de ubicación (ADR-0024). MVP: solo en primer plano. Al ir a
/// segundo plano deja de enviar; a los 10 min la API lo marca no disponible.
class AvailabilityController extends AsyncNotifier<Availability> {
  Timer? _timer;
  AppLifecycleListener? _lifecycle;
  bool _foreground = true;
  bool _sending = false;

  AvailabilityRepository get _repo => ref.read(availabilityRepositoryProvider);
  LocationService get _location => ref.read(locationServiceProvider);

  @override
  Future<Availability> build() async {
    _lifecycle = AppLifecycleListener(
      onShow: () {
        _foreground = true;
        _sync(sendNow: true);
      },
      onHide: () {
        _foreground = false;
        _stop();
      },
    );
    ref.onDispose(() {
      _stop();
      _lifecycle?.dispose();
    });
    final availability = await _repo.get();
    scheduleMicrotask(_sync);
    return availability;
  }

  /// Activa o desactiva "Disponible". Lanza [LocationAccessException] o [ApiException]
  /// (p. ej. WORKER_MODE_REQUIRED) con el mensaje en español.
  Future<void> setAvailable(bool on) async {
    if (!on) {
      _stop();
      state = AsyncData(await _repo.set(available: false));
      return;
    }
    final access = await _location.requestAccess();
    if (access != LocationAccess.granted) throw LocationAccessException(access);
    final at = await _location.current();
    state = AsyncData(await _repo.set(available: true, at: at));
    _sync();
  }

  void _sync({bool sendNow = false}) {
    final current = state.value;
    if (current == null || !current.available || !_foreground) {
      _stop();
      return;
    }
    _timer ??= Timer.periodic(
      Duration(seconds: current.sendEverySec),
      (_) => _send(),
    );
    if (sendNow) _send();
  }

  Future<void> _send() async {
    if (_sending) return;
    _sending = true;
    try {
      await _repo.sendLocation(await _location.current());
    } on ApiException catch (e) {
      // La API ya no lo considera disponible (ubicación vencida, bloqueo, cambio de modo).
      if (e.code == 'NOT_AVAILABLE') {
        _stop();
        final current = state.value;
        if (current != null) {
          state = AsyncData(current.copyWith(available: false));
        }
      }
    } catch (_) {
      // Sin GPS o sin red un momento: se reintenta en el próximo envío.
    } finally {
      _sending = false;
    }
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }
}

final availabilityProvider =
    AsyncNotifierProvider<AvailabilityController, Availability>(
      AvailabilityController.new,
    );
