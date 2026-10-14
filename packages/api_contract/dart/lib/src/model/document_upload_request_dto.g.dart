// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_upload_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentUploadRequestDtoCWProxy {
  DocumentUploadRequestDto type(DocumentUploadRequestDtoTypeEnum type);

  DocumentUploadRequestDto contentType(
    DocumentUploadRequestDtoContentTypeEnum contentType,
  );

  DocumentUploadRequestDto sizeBytes(num sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentUploadRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentUploadRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentUploadRequestDto call({
    DocumentUploadRequestDtoTypeEnum type,
    DocumentUploadRequestDtoContentTypeEnum contentType,
    num sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentUploadRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentUploadRequestDto.copyWith.fieldName(...)`
class _$DocumentUploadRequestDtoCWProxyImpl
    implements _$DocumentUploadRequestDtoCWProxy {
  const _$DocumentUploadRequestDtoCWProxyImpl(this._value);

  final DocumentUploadRequestDto _value;

  @override
  DocumentUploadRequestDto type(DocumentUploadRequestDtoTypeEnum type) =>
      this(type: type);

  @override
  DocumentUploadRequestDto contentType(
    DocumentUploadRequestDtoContentTypeEnum contentType,
  ) => this(contentType: contentType);

  @override
  DocumentUploadRequestDto sizeBytes(num sizeBytes) =>
      this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentUploadRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentUploadRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentUploadRequestDto call({
    Object? type = const $CopyWithPlaceholder(),
    Object? contentType = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return DocumentUploadRequestDto(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DocumentUploadRequestDtoTypeEnum,
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as DocumentUploadRequestDtoContentTypeEnum,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as num,
    );
  }
}

extension $DocumentUploadRequestDtoCopyWith on DocumentUploadRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentUploadRequestDto.copyWith(...)` or like so:`instanceOfDocumentUploadRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentUploadRequestDtoCWProxy get copyWith =>
      _$DocumentUploadRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentUploadRequestDto _$DocumentUploadRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DocumentUploadRequestDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['type', 'contentType', 'sizeBytes']);
  final val = DocumentUploadRequestDto(
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$DocumentUploadRequestDtoTypeEnumEnumMap, v),
    ),
    contentType: $checkedConvert(
      'contentType',
      (v) => $enumDecode(_$DocumentUploadRequestDtoContentTypeEnumEnumMap, v),
    ),
    sizeBytes: $checkedConvert('sizeBytes', (v) => v as num),
  );
  return val;
});

Map<String, dynamic> _$DocumentUploadRequestDtoToJson(
  DocumentUploadRequestDto instance,
) => <String, dynamic>{
  'type': _$DocumentUploadRequestDtoTypeEnumEnumMap[instance.type]!,
  'contentType':
      _$DocumentUploadRequestDtoContentTypeEnumEnumMap[instance.contentType]!,
  'sizeBytes': instance.sizeBytes,
};

const _$DocumentUploadRequestDtoTypeEnumEnumMap = {
  DocumentUploadRequestDtoTypeEnum.ciFront: 'ci_front',
  DocumentUploadRequestDtoTypeEnum.ciBack: 'ci_back',
  DocumentUploadRequestDtoTypeEnum.selfie: 'selfie',
};

const _$DocumentUploadRequestDtoContentTypeEnumEnumMap = {
  DocumentUploadRequestDtoContentTypeEnum.imageSlashJpeg: 'image/jpeg',
  DocumentUploadRequestDtoContentTypeEnum.imageSlashPng: 'image/png',
  DocumentUploadRequestDtoContentTypeEnum.imageSlashHeic: 'image/heic',
};
