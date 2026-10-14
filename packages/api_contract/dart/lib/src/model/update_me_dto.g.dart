// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateMeDtoCWProxy {
  UpdateMeDto name(String? name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateMeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateMeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateMeDto call({String? name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateMeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateMeDto.copyWith.fieldName(...)`
class _$UpdateMeDtoCWProxyImpl implements _$UpdateMeDtoCWProxy {
  const _$UpdateMeDtoCWProxyImpl(this._value);

  final UpdateMeDto _value;

  @override
  UpdateMeDto name(String? name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateMeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateMeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateMeDto call({Object? name = const $CopyWithPlaceholder()}) {
    return UpdateMeDto(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $UpdateMeDtoCopyWith on UpdateMeDto {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateMeDto.copyWith(...)` or like so:`instanceOfUpdateMeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateMeDtoCWProxy get copyWith => _$UpdateMeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMeDto _$UpdateMeDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'UpdateMeDto',
  json,
  ($checkedConvert) {
    final val = UpdateMeDto(name: $checkedConvert('name', (v) => v as String?));
    return val;
  },
);

Map<String, dynamic> _$UpdateMeDtoToJson(UpdateMeDto instance) =>
    <String, dynamic>{'name': ?instance.name};
