import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../http/api_client.dart';
import '../http/api_exception.dart';

/// Plataforma para la API: versión mínima por plataforma (ADR-0054).
String appPlatform() {
  if (kIsWeb) return 'web';
  return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
}

class SupportInfo {
  const SupportInfo({required this.whatsapp, required this.url});

  final String whatsapp;
  final Uri url;
}

/// Lo que la app necesita saber al abrirse (GET /app/config).
class AppConfig {
  const AppConfig({
    required this.minVersion,
    required this.upgradeRequired,
    this.storeUrl,
    this.support,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final support = json['support'];
    return AppConfig(
      minVersion: json['minVersion'] as String? ?? '0.0.0',
      upgradeRequired: json['upgradeRequired'] == true,
      storeUrl: json['storeUrl'] as String?,
      support: support is Map
          ? SupportInfo(
              whatsapp: support['whatsapp'] as String,
              url: Uri.parse(support['url'] as String),
            )
          : null,
    );
  }

  final String minVersion;
  final bool upgradeRequired;
  final String? storeUrl;
  final SupportInfo? support;
}

/// Un texto legal vigente (ADR-0051).
class LegalDocument {
  const LegalDocument({
    required this.type,
    required this.version,
    required this.title,
    required this.content,
    required this.draft,
    this.pilotOnly = false,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) => LegalDocument(
    type: json['type'] as String,
    version: (json['version'] as num).toInt(),
    title: json['title'] as String,
    content: json['contentMd'] as String,
    draft: json['draft'] == true,
    pilotOnly: json['pilotOnly'] == true,
  );

  /// `terms` o `privacy`.
  final String type;
  final int version;
  final String title;
  final String content;

  /// Sigue pendiente de revisión legal: la app lo muestra con un aviso.
  final bool draft;

  /// Versión v0 que solo vale para el piloto cerrado con invitación.
  final bool pilotOnly;
}

/// Configuración de la app, textos legales y su aceptación.
class ClientAppRepository {
  ClientAppRepository(this._api);

  final Dio _api;

  Future<AppConfig> config() async {
    try {
      final res = await _api.get<Map<String, dynamic>>(
        '/app/config',
        queryParameters: {
          'platform': appPlatform(),
          if (Env.appVersion.isNotEmpty) 'version': Env.appVersion,
        },
      );
      return AppConfig.fromJson(res.data ?? const {});
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<List<LegalDocument>> legalDocuments() async {
    try {
      final res = await _api.get<List<dynamic>>('/legal/current');
      return [
        for (final d in res.data ?? const [])
          LegalDocument.fromJson((d as Map).cast<String, dynamic>()),
      ];
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Textos vigentes que la cuenta todavía no aceptó (GET /me).
  Future<List<String>> legalPending() async {
    try {
      final res = await _api.get<Map<String, dynamic>>('/me');
      return [
        for (final t in (res.data?['legalPending'] as List?) ?? const [])
          t as String,
      ];
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Acepta las versiones mostradas y declara la mayoría de edad (R1, ADR-0051).
  Future<void> acceptLegal({
    required int termsVersion,
    required int privacyVersion,
  }) async {
    try {
      await _api.post<void>(
        '/me/legal/accept',
        data: {
          'termsVersion': termsVersion,
          'privacyVersion': privacyVersion,
          'adult': true,
          'platform': appPlatform(),
          if (Env.appVersion.isNotEmpty)
            'appVersion': '${Env.appVersion}+${Env.appBuild}',
        },
      );
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final clientAppRepositoryProvider = Provider<ClientAppRepository>(
  (ref) => ClientAppRepository(ref.watch(dioProvider)),
);
