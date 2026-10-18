// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VersionDtoCWProxy {
  VersionDto version(String version);

  VersionDto sha(String? sha);

  VersionDto env(String env);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VersionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VersionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VersionDto call({String version, String? sha, String env});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVersionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVersionDto.copyWith.fieldName(...)`
class _$VersionDtoCWProxyImpl implements _$VersionDtoCWProxy {
  const _$VersionDtoCWProxyImpl(this._value);

  final VersionDto _value;

  @override
  VersionDto version(String version) => this(version: version);

  @override
  VersionDto sha(String? sha) => this(sha: sha);

  @override
  VersionDto env(String env) => this(env: env);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VersionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VersionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VersionDto call({
    Object? version = const $CopyWithPlaceholder(),
    Object? sha = const $CopyWithPlaceholder(),
    Object? env = const $CopyWithPlaceholder(),
  }) {
    return VersionDto(
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String,
      sha: sha == const $CopyWithPlaceholder()
          ? _value.sha
          // ignore: cast_nullable_to_non_nullable
          : sha as String?,
      env: env == const $CopyWithPlaceholder()
          ? _value.env
          // ignore: cast_nullable_to_non_nullable
          : env as String,
    );
  }
}

extension $VersionDtoCopyWith on VersionDto {
  /// Returns a callable class that can be used as follows: `instanceOfVersionDto.copyWith(...)` or like so:`instanceOfVersionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VersionDtoCWProxy get copyWith => _$VersionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionDto _$VersionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VersionDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['version', 'sha', 'env']);
      final val = VersionDto(
        version: $checkedConvert('version', (v) => v as String),
        sha: $checkedConvert('sha', (v) => v as String?),
        env: $checkedConvert('env', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$VersionDtoToJson(VersionDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'sha': instance.sha,
      'env': instance.env,
    };
