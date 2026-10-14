// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LoginResponseDtoCWProxy {
  LoginResponseDto accessToken(String accessToken);

  LoginResponseDto refreshToken(String refreshToken);

  LoginResponseDto tokenType(LoginResponseDtoTokenTypeEnum tokenType);

  LoginResponseDto expiresIn(num expiresIn);

  LoginResponseDto refreshExpiresIn(num refreshExpiresIn);

  LoginResponseDto user(UserDto user);

  LoginResponseDto isNewUser(bool isNewUser);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoginResponseDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoginResponseDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LoginResponseDto call({
    String accessToken,
    String refreshToken,
    LoginResponseDtoTokenTypeEnum tokenType,
    num expiresIn,
    num refreshExpiresIn,
    UserDto user,
    bool isNewUser,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLoginResponseDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLoginResponseDto.copyWith.fieldName(...)`
class _$LoginResponseDtoCWProxyImpl implements _$LoginResponseDtoCWProxy {
  const _$LoginResponseDtoCWProxyImpl(this._value);

  final LoginResponseDto _value;

  @override
  LoginResponseDto accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  LoginResponseDto refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  LoginResponseDto tokenType(LoginResponseDtoTokenTypeEnum tokenType) =>
      this(tokenType: tokenType);

  @override
  LoginResponseDto expiresIn(num expiresIn) => this(expiresIn: expiresIn);

  @override
  LoginResponseDto refreshExpiresIn(num refreshExpiresIn) =>
      this(refreshExpiresIn: refreshExpiresIn);

  @override
  LoginResponseDto user(UserDto user) => this(user: user);

  @override
  LoginResponseDto isNewUser(bool isNewUser) => this(isNewUser: isNewUser);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoginResponseDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoginResponseDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LoginResponseDto call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? tokenType = const $CopyWithPlaceholder(),
    Object? expiresIn = const $CopyWithPlaceholder(),
    Object? refreshExpiresIn = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? isNewUser = const $CopyWithPlaceholder(),
  }) {
    return LoginResponseDto(
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
          : tokenType as LoginResponseDtoTokenTypeEnum,
      expiresIn: expiresIn == const $CopyWithPlaceholder()
          ? _value.expiresIn
          // ignore: cast_nullable_to_non_nullable
          : expiresIn as num,
      refreshExpiresIn: refreshExpiresIn == const $CopyWithPlaceholder()
          ? _value.refreshExpiresIn
          // ignore: cast_nullable_to_non_nullable
          : refreshExpiresIn as num,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserDto,
      isNewUser: isNewUser == const $CopyWithPlaceholder()
          ? _value.isNewUser
          // ignore: cast_nullable_to_non_nullable
          : isNewUser as bool,
    );
  }
}

extension $LoginResponseDtoCopyWith on LoginResponseDto {
  /// Returns a callable class that can be used as follows: `instanceOfLoginResponseDto.copyWith(...)` or like so:`instanceOfLoginResponseDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LoginResponseDtoCWProxy get copyWith => _$LoginResponseDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginResponseDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'accessToken',
          'refreshToken',
          'tokenType',
          'expiresIn',
          'refreshExpiresIn',
          'user',
          'isNewUser',
        ],
      );
      final val = LoginResponseDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        tokenType: $checkedConvert(
          'tokenType',
          (v) => $enumDecode(_$LoginResponseDtoTokenTypeEnumEnumMap, v),
        ),
        expiresIn: $checkedConvert('expiresIn', (v) => v as num),
        refreshExpiresIn: $checkedConvert('refreshExpiresIn', (v) => v as num),
        user: $checkedConvert(
          'user',
          (v) => UserDto.fromJson(v as Map<String, dynamic>),
        ),
        isNewUser: $checkedConvert('isNewUser', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseDtoToJson(LoginResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': _$LoginResponseDtoTokenTypeEnumEnumMap[instance.tokenType]!,
      'expiresIn': instance.expiresIn,
      'refreshExpiresIn': instance.refreshExpiresIn,
      'user': instance.user.toJson(),
      'isNewUser': instance.isNewUser,
    };

const _$LoginResponseDtoTokenTypeEnumEnumMap = {
  LoginResponseDtoTokenTypeEnum.bearer: 'Bearer',
};
