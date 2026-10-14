// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RefreshTokenDtoCWProxy {
  RefreshTokenDto refreshToken(String refreshToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefreshTokenDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefreshTokenDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RefreshTokenDto call({String refreshToken});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRefreshTokenDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRefreshTokenDto.copyWith.fieldName(...)`
class _$RefreshTokenDtoCWProxyImpl implements _$RefreshTokenDtoCWProxy {
  const _$RefreshTokenDtoCWProxyImpl(this._value);

  final RefreshTokenDto _value;

  @override
  RefreshTokenDto refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefreshTokenDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefreshTokenDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RefreshTokenDto call({Object? refreshToken = const $CopyWithPlaceholder()}) {
    return RefreshTokenDto(
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String,
    );
  }
}

extension $RefreshTokenDtoCopyWith on RefreshTokenDto {
  /// Returns a callable class that can be used as follows: `instanceOfRefreshTokenDto.copyWith(...)` or like so:`instanceOfRefreshTokenDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RefreshTokenDtoCWProxy get copyWith => _$RefreshTokenDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenDto _$RefreshTokenDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RefreshTokenDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['refreshToken']);
      final val = RefreshTokenDto(
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RefreshTokenDtoToJson(RefreshTokenDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};
