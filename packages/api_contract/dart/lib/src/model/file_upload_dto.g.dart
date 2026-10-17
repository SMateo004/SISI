// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FileUploadDtoCWProxy {
  FileUploadDto contentType(String contentType);

  FileUploadDto sizeBytes(num sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  FileUploadDto call({String contentType, num sizeBytes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFileUploadDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFileUploadDto.copyWith.fieldName(...)`
class _$FileUploadDtoCWProxyImpl implements _$FileUploadDtoCWProxy {
  const _$FileUploadDtoCWProxyImpl(this._value);

  final FileUploadDto _value;

  @override
  FileUploadDto contentType(String contentType) =>
      this(contentType: contentType);

  @override
  FileUploadDto sizeBytes(num sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  FileUploadDto call({
    Object? contentType = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return FileUploadDto(
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as String,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as num,
    );
  }
}

extension $FileUploadDtoCopyWith on FileUploadDto {
  /// Returns a callable class that can be used as follows: `instanceOfFileUploadDto.copyWith(...)` or like so:`instanceOfFileUploadDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FileUploadDtoCWProxy get copyWith => _$FileUploadDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadDto _$FileUploadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FileUploadDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['contentType', 'sizeBytes']);
      final val = FileUploadDto(
        contentType: $checkedConvert('contentType', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$FileUploadDtoToJson(FileUploadDto instance) =>
    <String, dynamic>{
      'contentType': instance.contentType,
      'sizeBytes': instance.sizeBytes,
    };
