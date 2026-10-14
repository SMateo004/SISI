// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_checks_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HealthChecksDtoCWProxy {
  HealthChecksDto database(HealthCheckDto database);

  HealthChecksDto postgis(HealthCheckDto postgis);

  HealthChecksDto redis(HealthCheckDto redis);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthChecksDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthChecksDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthChecksDto call({
    HealthCheckDto database,
    HealthCheckDto postgis,
    HealthCheckDto redis,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHealthChecksDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHealthChecksDto.copyWith.fieldName(...)`
class _$HealthChecksDtoCWProxyImpl implements _$HealthChecksDtoCWProxy {
  const _$HealthChecksDtoCWProxyImpl(this._value);

  final HealthChecksDto _value;

  @override
  HealthChecksDto database(HealthCheckDto database) => this(database: database);

  @override
  HealthChecksDto postgis(HealthCheckDto postgis) => this(postgis: postgis);

  @override
  HealthChecksDto redis(HealthCheckDto redis) => this(redis: redis);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthChecksDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthChecksDto(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthChecksDto call({
    Object? database = const $CopyWithPlaceholder(),
    Object? postgis = const $CopyWithPlaceholder(),
    Object? redis = const $CopyWithPlaceholder(),
  }) {
    return HealthChecksDto(
      database: database == const $CopyWithPlaceholder()
          ? _value.database
          // ignore: cast_nullable_to_non_nullable
          : database as HealthCheckDto,
      postgis: postgis == const $CopyWithPlaceholder()
          ? _value.postgis
          // ignore: cast_nullable_to_non_nullable
          : postgis as HealthCheckDto,
      redis: redis == const $CopyWithPlaceholder()
          ? _value.redis
          // ignore: cast_nullable_to_non_nullable
          : redis as HealthCheckDto,
    );
  }
}

extension $HealthChecksDtoCopyWith on HealthChecksDto {
  /// Returns a callable class that can be used as follows: `instanceOfHealthChecksDto.copyWith(...)` or like so:`instanceOfHealthChecksDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HealthChecksDtoCWProxy get copyWith => _$HealthChecksDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthChecksDto _$HealthChecksDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HealthChecksDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['database', 'postgis', 'redis']);
      final val = HealthChecksDto(
        database: $checkedConvert(
          'database',
          (v) => HealthCheckDto.fromJson(v as Map<String, dynamic>),
        ),
        postgis: $checkedConvert(
          'postgis',
          (v) => HealthCheckDto.fromJson(v as Map<String, dynamic>),
        ),
        redis: $checkedConvert(
          'redis',
          (v) => HealthCheckDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HealthChecksDtoToJson(HealthChecksDto instance) =>
    <String, dynamic>{
      'database': instance.database.toJson(),
      'postgis': instance.postgis.toJson(),
      'redis': instance.redis.toJson(),
    };
