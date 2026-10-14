// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_check_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HealthCheckDtoCWProxy {
  HealthCheckDto status(HealthCheckDtoStatusEnum status);

  HealthCheckDto version(String? version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthCheckDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthCheckDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthCheckDto call({HealthCheckDtoStatusEnum status, String? version});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHealthCheckDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHealthCheckDto.copyWith.fieldName(...)`
class _$HealthCheckDtoCWProxyImpl implements _$HealthCheckDtoCWProxy {
  const _$HealthCheckDtoCWProxyImpl(this._value);

  final HealthCheckDto _value;

  @override
  HealthCheckDto status(HealthCheckDtoStatusEnum status) =>
      this(status: status);

  @override
  HealthCheckDto version(String? version) => this(version: version);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthCheckDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthCheckDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthCheckDto call({
    Object? status = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return HealthCheckDto(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as HealthCheckDtoStatusEnum,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String?,
    );
  }
}

extension $HealthCheckDtoCopyWith on HealthCheckDto {
  /// Returns a callable class that can be used as follows: `instanceOfHealthCheckDto.copyWith(...)` or like so:`instanceOfHealthCheckDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HealthCheckDtoCWProxy get copyWith => _$HealthCheckDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthCheckDto _$HealthCheckDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HealthCheckDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status']);
      final val = HealthCheckDto(
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$HealthCheckDtoStatusEnumEnumMap, v),
        ),
        version: $checkedConvert('version', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$HealthCheckDtoToJson(HealthCheckDto instance) =>
    <String, dynamic>{
      'status': _$HealthCheckDtoStatusEnumEnumMap[instance.status]!,
      'version': ?instance.version,
    };

const _$HealthCheckDtoStatusEnumEnumMap = {
  HealthCheckDtoStatusEnum.up: 'up',
  HealthCheckDtoStatusEnum.down: 'down',
};
