// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_session_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminSessionDtoCWProxy {
  AdminSessionDto accessToken(String accessToken);

  AdminSessionDto tokenType(AdminSessionDtoTokenTypeEnum tokenType);

  AdminSessionDto expiresIn(num expiresIn);

  AdminSessionDto sessionExpiresAt(DateTime sessionExpiresAt);

  AdminSessionDto user(UserDto user);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminSessionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminSessionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminSessionDto call({
    String accessToken,
    AdminSessionDtoTokenTypeEnum tokenType,
    num expiresIn,
    DateTime sessionExpiresAt,
    UserDto user,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminSessionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminSessionDto.copyWith.fieldName(...)`
class _$AdminSessionDtoCWProxyImpl implements _$AdminSessionDtoCWProxy {
  const _$AdminSessionDtoCWProxyImpl(this._value);

  final AdminSessionDto _value;

  @override
  AdminSessionDto accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  AdminSessionDto tokenType(AdminSessionDtoTokenTypeEnum tokenType) =>
      this(tokenType: tokenType);

  @override
  AdminSessionDto expiresIn(num expiresIn) => this(expiresIn: expiresIn);

  @override
  AdminSessionDto sessionExpiresAt(DateTime sessionExpiresAt) =>
      this(sessionExpiresAt: sessionExpiresAt);

  @override
  AdminSessionDto user(UserDto user) => this(user: user);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminSessionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminSessionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminSessionDto call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? tokenType = const $CopyWithPlaceholder(),
    Object? expiresIn = const $CopyWithPlaceholder(),
    Object? sessionExpiresAt = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
  }) {
    return AdminSessionDto(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      tokenType: tokenType == const $CopyWithPlaceholder()
          ? _value.tokenType
          // ignore: cast_nullable_to_non_nullable
          : tokenType as AdminSessionDtoTokenTypeEnum,
      expiresIn: expiresIn == const $CopyWithPlaceholder()
          ? _value.expiresIn
          // ignore: cast_nullable_to_non_nullable
          : expiresIn as num,
      sessionExpiresAt: sessionExpiresAt == const $CopyWithPlaceholder()
          ? _value.sessionExpiresAt
          // ignore: cast_nullable_to_non_nullable
          : sessionExpiresAt as DateTime,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserDto,
    );
  }
}

extension $AdminSessionDtoCopyWith on AdminSessionDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminSessionDto.copyWith(...)` or like so:`instanceOfAdminSessionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminSessionDtoCWProxy get copyWith => _$AdminSessionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSessionDto _$AdminSessionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminSessionDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'accessToken',
          'tokenType',
          'expiresIn',
          'sessionExpiresAt',
          'user',
        ],
      );
      final val = AdminSessionDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        tokenType: $checkedConvert(
          'tokenType',
          (v) => $enumDecode(_$AdminSessionDtoTokenTypeEnumEnumMap, v),
        ),
        expiresIn: $checkedConvert('expiresIn', (v) => v as num),
        sessionExpiresAt: $checkedConvert(
          'sessionExpiresAt',
          (v) => DateTime.parse(v as String),
        ),
        user: $checkedConvert(
          'user',
          (v) => UserDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminSessionDtoToJson(AdminSessionDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'tokenType': _$AdminSessionDtoTokenTypeEnumEnumMap[instance.tokenType]!,
      'expiresIn': instance.expiresIn,
      'sessionExpiresAt': instance.sessionExpiresAt.toIso8601String(),
      'user': instance.user.toJson(),
    };

const _$AdminSessionDtoTokenTypeEnumEnumMap = {
  AdminSessionDtoTokenTypeEnum.bearer: 'Bearer',
};
