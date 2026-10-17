// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_upload_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReceiptUploadDtoCWProxy {
  ReceiptUploadDto workerId(String workerId);

  ReceiptUploadDto contentType(String contentType);

  ReceiptUploadDto sizeBytes(num sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReceiptUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReceiptUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReceiptUploadDto call({String workerId, String contentType, num sizeBytes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReceiptUploadDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReceiptUploadDto.copyWith.fieldName(...)`
class _$ReceiptUploadDtoCWProxyImpl implements _$ReceiptUploadDtoCWProxy {
  const _$ReceiptUploadDtoCWProxyImpl(this._value);

  final ReceiptUploadDto _value;

  @override
  ReceiptUploadDto workerId(String workerId) => this(workerId: workerId);

  @override
  ReceiptUploadDto contentType(String contentType) =>
      this(contentType: contentType);

  @override
  ReceiptUploadDto sizeBytes(num sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReceiptUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReceiptUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReceiptUploadDto call({
    Object? workerId = const $CopyWithPlaceholder(),
    Object? contentType = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return ReceiptUploadDto(
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
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

extension $ReceiptUploadDtoCopyWith on ReceiptUploadDto {
  /// Returns a callable class that can be used as follows: `instanceOfReceiptUploadDto.copyWith(...)` or like so:`instanceOfReceiptUploadDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReceiptUploadDtoCWProxy get copyWith => _$ReceiptUploadDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptUploadDto _$ReceiptUploadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReceiptUploadDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['workerId', 'contentType', 'sizeBytes'],
      );
      final val = ReceiptUploadDto(
        workerId: $checkedConvert('workerId', (v) => v as String),
        contentType: $checkedConvert('contentType', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$ReceiptUploadDtoToJson(ReceiptUploadDto instance) =>
    <String, dynamic>{
      'workerId': instance.workerId,
      'contentType': instance.contentType,
      'sizeBytes': instance.sizeBytes,
    };
