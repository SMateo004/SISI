// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_login_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminLoginDtoCWProxy {
  AdminLoginDto username(String username);

  AdminLoginDto code(String code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminLoginDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminLoginDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminLoginDto call({String username, String code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminLoginDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminLoginDto.copyWith.fieldName(...)`
class _$AdminLoginDtoCWProxyImpl implements _$AdminLoginDtoCWProxy {
  const _$AdminLoginDtoCWProxyImpl(this._value);

  final AdminLoginDto _value;

  @override
  AdminLoginDto username(String username) => this(username: username);

  @override
  AdminLoginDto code(String code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminLoginDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminLoginDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminLoginDto call({
    Object? username = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
  }) {
    return AdminLoginDto(
      username: username == const $CopyWithPlaceholder()
          ? _value.username
          // ignore: cast_nullable_to_non_nullable
          : username as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
    );
  }
}

extension $AdminLoginDtoCopyWith on AdminLoginDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminLoginDto.copyWith(...)` or like so:`instanceOfAdminLoginDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminLoginDtoCWProxy get copyWith => _$AdminLoginDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminLoginDto _$AdminLoginDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminLoginDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['username', 'code']);
      final val = AdminLoginDto(
        username: $checkedConvert('username', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminLoginDtoToJson(AdminLoginDto instance) =>
    <String, dynamic>{'username': instance.username, 'code': instance.code};
