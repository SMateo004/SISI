// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadRequestDtoCWProxy {
  UploadRequestDto contentType(UploadRequestDtoContentTypeEnum contentType);

  UploadRequestDto sizeBytes(num sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadRequestDto call({
    UploadRequestDtoContentTypeEnum contentType,
    num sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadRequestDto.copyWith.fieldName(...)`
class _$UploadRequestDtoCWProxyImpl implements _$UploadRequestDtoCWProxy {
  const _$UploadRequestDtoCWProxyImpl(this._value);

  final UploadRequestDto _value;

  @override
  UploadRequestDto contentType(UploadRequestDtoContentTypeEnum contentType) =>
      this(contentType: contentType);

  @override
  UploadRequestDto sizeBytes(num sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadRequestDto call({
    Object? contentType = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return UploadRequestDto(
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as UploadRequestDtoContentTypeEnum,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as num,
    );
  }
}

extension $UploadRequestDtoCopyWith on UploadRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfUploadRequestDto.copyWith(...)` or like so:`instanceOfUploadRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadRequestDtoCWProxy get copyWith => _$UploadRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadRequestDto _$UploadRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UploadRequestDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['contentType', 'sizeBytes']);
      final val = UploadRequestDto(
        contentType: $checkedConvert(
          'contentType',
          (v) => $enumDecode(_$UploadRequestDtoContentTypeEnumEnumMap, v),
        ),
        sizeBytes: $checkedConvert('sizeBytes', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$UploadRequestDtoToJson(UploadRequestDto instance) =>
    <String, dynamic>{
      'contentType':
          _$UploadRequestDtoContentTypeEnumEnumMap[instance.contentType]!,
      'sizeBytes': instance.sizeBytes,
    };

const _$UploadRequestDtoContentTypeEnumEnumMap = {
  UploadRequestDtoContentTypeEnum.imageSlashJpeg: 'image/jpeg',
  UploadRequestDtoContentTypeEnum.imageSlashPng: 'image/png',
  UploadRequestDtoContentTypeEnum.imageSlashHeic: 'image/heic',
};
