// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TokensDtoCWProxy {
  TokensDto accessToken(String accessToken);

  TokensDto refreshToken(String refreshToken);

  TokensDto tokenType(TokensDtoTokenTypeEnum tokenType);

  TokensDto expiresIn(num expiresIn);

  TokensDto refreshExpiresIn(num refreshExpiresIn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TokensDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TokensDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TokensDto call({
    String accessToken,
    String refreshToken,
    TokensDtoTokenTypeEnum tokenType,
    num expiresIn,
    num refreshExpiresIn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTokensDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTokensDto.copyWith.fieldName(...)`
class _$TokensDtoCWProxyImpl implements _$TokensDtoCWProxy {
  const _$TokensDtoCWProxyImpl(this._value);

  final TokensDto _value;

  @override
  TokensDto accessToken(String accessToken) => this(accessToken: accessToken);

  @override
  TokensDto refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  TokensDto tokenType(TokensDtoTokenTypeEnum tokenType) =>
      this(tokenType: tokenType);

  @override
  TokensDto expiresIn(num expiresIn) => this(expiresIn: expiresIn);

  @override
  TokensDto refreshExpiresIn(num refreshExpiresIn) =>
      this(refreshExpiresIn: refreshExpiresIn);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TokensDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TokensDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TokensDto call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? tokenType = const $CopyWithPlaceholder(),
    Object? expiresIn = const $CopyWithPlaceholder(),
    Object? refreshExpiresIn = const $CopyWithPlaceholder(),
  }) {
    return TokensDto(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String,
      tokenType: tokenType == const $CopyWithPlaceholder()
          ? _value.tokenType
          // ignore: cast_nullable_to_non_nullable
          : tokenType as TokensDtoTokenTypeEnum,
      expiresIn: expiresIn == const $CopyWithPlaceholder()
          ? _value.expiresIn
          // ignore: cast_nullable_to_non_nullable
          : expiresIn as num,
      refreshExpiresIn: refreshExpiresIn == const $CopyWithPlaceholder()
          ? _value.refreshExpiresIn
          // ignore: cast_nullable_to_non_nullable
          : refreshExpiresIn as num,
    );
  }
}

extension $TokensDtoCopyWith on TokensDto {
  /// Returns a callable class that can be used as follows: `instanceOfTokensDto.copyWith(...)` or like so:`instanceOfTokensDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TokensDtoCWProxy get copyWith => _$TokensDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensDto _$TokensDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokensDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'accessToken',
          'refreshToken',
          'tokenType',
          'expiresIn',
          'refreshExpiresIn',
        ],
      );
      final val = TokensDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        tokenType: $checkedConvert(
          'tokenType',
          (v) => $enumDecode(_$TokensDtoTokenTypeEnumEnumMap, v),
        ),
        expiresIn: $checkedConvert('expiresIn', (v) => v as num),
        refreshExpiresIn: $checkedConvert('refreshExpiresIn', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$TokensDtoToJson(TokensDto instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenType': _$TokensDtoTokenTypeEnumEnumMap[instance.tokenType]!,
  'expiresIn': instance.expiresIn,
  'refreshExpiresIn': instance.refreshExpiresIn,
};

const _$TokensDtoTokenTypeEnumEnumMap = {
  TokensDtoTokenTypeEnum.bearer: 'Bearer',
};
