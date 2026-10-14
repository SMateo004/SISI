// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presigned_upload_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PresignedUploadDtoCWProxy {
  PresignedUploadDto key(String key);

  PresignedUploadDto uploadUrl(String uploadUrl);

  PresignedUploadDto method(PresignedUploadDtoMethodEnum method);

  PresignedUploadDto headers(Object headers);

  PresignedUploadDto expiresAt(String expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PresignedUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PresignedUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PresignedUploadDto call({
    String key,
    String uploadUrl,
    PresignedUploadDtoMethodEnum method,
    Object headers,
    String expiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPresignedUploadDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPresignedUploadDto.copyWith.fieldName(...)`
class _$PresignedUploadDtoCWProxyImpl implements _$PresignedUploadDtoCWProxy {
  const _$PresignedUploadDtoCWProxyImpl(this._value);

  final PresignedUploadDto _value;

  @override
  PresignedUploadDto key(String key) => this(key: key);

  @override
  PresignedUploadDto uploadUrl(String uploadUrl) => this(uploadUrl: uploadUrl);

  @override
  PresignedUploadDto method(PresignedUploadDtoMethodEnum method) =>
      this(method: method);

  @override
  PresignedUploadDto headers(Object headers) => this(headers: headers);

  @override
  PresignedUploadDto expiresAt(String expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PresignedUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PresignedUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PresignedUploadDto call({
    Object? key = const $CopyWithPlaceholder(),
    Object? uploadUrl = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? headers = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return PresignedUploadDto(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      uploadUrl: uploadUrl == const $CopyWithPlaceholder()
          ? _value.uploadUrl
          // ignore: cast_nullable_to_non_nullable
          : uploadUrl as String,
      method: method == const $CopyWithPlaceholder()
          ? _value.method
          // ignore: cast_nullable_to_non_nullable
          : method as PresignedUploadDtoMethodEnum,
      headers: headers == const $CopyWithPlaceholder()
          ? _value.headers
          // ignore: cast_nullable_to_non_nullable
          : headers as Object,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as String,
    );
  }
}

extension $PresignedUploadDtoCopyWith on PresignedUploadDto {
  /// Returns a callable class that can be used as follows: `instanceOfPresignedUploadDto.copyWith(...)` or like so:`instanceOfPresignedUploadDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PresignedUploadDtoCWProxy get copyWith =>
      _$PresignedUploadDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresignedUploadDto _$PresignedUploadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PresignedUploadDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'key',
          'uploadUrl',
          'method',
          'headers',
          'expiresAt',
        ],
      );
      final val = PresignedUploadDto(
        key: $checkedConvert('key', (v) => v as String),
        uploadUrl: $checkedConvert('uploadUrl', (v) => v as String),
        method: $checkedConvert(
          'method',
          (v) => $enumDecode(_$PresignedUploadDtoMethodEnumEnumMap, v),
        ),
        headers: $checkedConvert('headers', (v) => v as Object),
        expiresAt: $checkedConvert('expiresAt', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PresignedUploadDtoToJson(PresignedUploadDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'uploadUrl': instance.uploadUrl,
      'method': _$PresignedUploadDtoMethodEnumEnumMap[instance.method]!,
      'headers': instance.headers,
      'expiresAt': instance.expiresAt,
    };

const _$PresignedUploadDtoMethodEnumEnumMap = {
  PresignedUploadDtoMethodEnum.PUT: 'PUT',
};
