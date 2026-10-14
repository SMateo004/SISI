import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/token_storage.dart';
import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';

class OtpRequested {
  const OtpRequested({required this.expiresInSec, required this.resendInSec});

  final int expiresInSec;
  final int resendInSec;
}

class LoginResult {
  const LoginResult({required this.tokens, required this.isNewUser});

  final AuthTokens tokens;
  final bool isNewUser;
}

/// Login por teléfono y código (ADR-0009).
class AuthRepository {
  AuthRepository(this._api);

  final Dio _api;

  Future<OtpRequested> requestOtp(String phone) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        '/auth/otp/request',
        data: {'phone': phone},
      );
      final data = res.data ?? const {};
      return OtpRequested(
        expiresInSec: (data['expiresInSec'] as num?)?.toInt() ?? 300,
        resendInSec: (data['resendInSec'] as num?)?.toInt() ?? 60,
      );
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<LoginResult> verifyOtp(String phone, String code) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: {'phone': phone, 'code': code},
      );
      final data = res.data ?? const {};
      return LoginResult(
        tokens: AuthTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        ),
        isNewUser: data['isNewUser'] == true,
      );
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Revoca la sesión en el servidor. Si falla (sin red), igual se cierra en el teléfono.
  Future<void> logout(String refreshToken) async {
    try {
      await _api.post<void>(
        '/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } catch (_) {}
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider)),
);
