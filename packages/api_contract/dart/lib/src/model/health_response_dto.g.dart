// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_response_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HealthResponseDtoCWProxy {
  HealthResponseDto status(HealthResponseDtoStatusEnum status);

  HealthResponseDto checks(HealthChecksDto checks);

  HealthResponseDto timestamp(String timestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthResponseDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthResponseDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthResponseDto call({
    HealthResponseDtoStatusEnum status,
    HealthChecksDto checks,
    String timestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHealthResponseDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHealthResponseDto.copyWith.fieldName(...)`
class _$HealthResponseDtoCWProxyImpl implements _$HealthResponseDtoCWProxy {
  const _$HealthResponseDtoCWProxyImpl(this._value);

  final HealthResponseDto _value;

  @override
  HealthResponseDto status(HealthResponseDtoStatusEnum status) =>
      this(status: status);

  @override
  HealthResponseDto checks(HealthChecksDto checks) => this(checks: checks);

  @override
  HealthResponseDto timestamp(String timestamp) => this(timestamp: timestamp);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthResponseDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthResponseDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthResponseDto call({
    Object? status = const $CopyWithPlaceholder(),
    Object? checks = const $CopyWithPlaceholder(),
    Object? timestamp = const $CopyWithPlaceholder(),
  }) {
    return HealthResponseDto(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as HealthResponseDtoStatusEnum,
      checks: checks == const $CopyWithPlaceholder()
          ? _value.checks
          // ignore: cast_nullable_to_non_nullable
          : checks as HealthChecksDto,
      timestamp: timestamp == const $CopyWithPlaceholder()
          ? _value.timestamp
          // ignore: cast_nullable_to_non_nullable
          : timestamp as String,
    );
  }
}

extension $HealthResponseDtoCopyWith on HealthResponseDto {
  /// Returns a callable class that can be used as follows: `instanceOfHealthResponseDto.copyWith(...)` or like so:`instanceOfHealthResponseDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HealthResponseDtoCWProxy get copyWith =>
      _$HealthResponseDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthResponseDto _$HealthResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HealthResponseDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status', 'checks', 'timestamp']);
      final val = HealthResponseDto(
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$HealthResponseDtoStatusEnumEnumMap, v),
        ),
        checks: $checkedConvert(
          'checks',
          (v) => HealthChecksDto.fromJson(v as Map<String, dynamic>),
        ),
        timestamp: $checkedConvert('timestamp', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HealthResponseDtoToJson(HealthResponseDto instance) =>
    <String, dynamic>{
      'status': _$HealthResponseDtoStatusEnumEnumMap[instance.status]!,
      'checks': instance.checks.toJson(),
      'timestamp': instance.timestamp,
    };

const _$HealthResponseDtoStatusEnumEnumMap = {
  HealthResponseDtoStatusEnum.ok: 'ok',
  HealthResponseDtoStatusEnum.error: 'error',
};
