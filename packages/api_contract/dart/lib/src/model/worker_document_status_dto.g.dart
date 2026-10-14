// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_document_status_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WorkerDocumentStatusDtoCWProxy {
  WorkerDocumentStatusDto type(WorkerDocumentStatusDtoTypeEnum type);

  WorkerDocumentStatusDto reviewStatus(
    WorkerDocumentStatusDtoReviewStatusEnum reviewStatus,
  );

  WorkerDocumentStatusDto uploadedAt(String uploadedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerDocumentStatusDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerDocumentStatusDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerDocumentStatusDto call({
    WorkerDocumentStatusDtoTypeEnum type,
    WorkerDocumentStatusDtoReviewStatusEnum reviewStatus,
    String uploadedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWorkerDocumentStatusDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWorkerDocumentStatusDto.copyWith.fieldName(...)`
class _$WorkerDocumentStatusDtoCWProxyImpl
    implements _$WorkerDocumentStatusDtoCWProxy {
  const _$WorkerDocumentStatusDtoCWProxyImpl(this._value);

  final WorkerDocumentStatusDto _value;

  @override
  WorkerDocumentStatusDto type(WorkerDocumentStatusDtoTypeEnum type) =>
      this(type: type);

  @override
  WorkerDocumentStatusDto reviewStatus(
    WorkerDocumentStatusDtoReviewStatusEnum reviewStatus,
  ) => this(reviewStatus: reviewStatus);

  @override
  WorkerDocumentStatusDto uploadedAt(String uploadedAt) =>
      this(uploadedAt: uploadedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerDocumentStatusDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerDocumentStatusDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerDocumentStatusDto call({
    Object? type = const $CopyWithPlaceholder(),
    Object? reviewStatus = const $CopyWithPlaceholder(),
    Object? uploadedAt = const $CopyWithPlaceholder(),
  }) {
    return WorkerDocumentStatusDto(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as WorkerDocumentStatusDtoTypeEnum,
      reviewStatus: reviewStatus == const $CopyWithPlaceholder()
          ? _value.reviewStatus
          // ignore: cast_nullable_to_non_nullable
          : reviewStatus as WorkerDocumentStatusDtoReviewStatusEnum,
      uploadedAt: uploadedAt == const $CopyWithPlaceholder()
          ? _value.uploadedAt
          // ignore: cast_nullable_to_non_nullable
          : uploadedAt as String,
    );
  }
}

extension $WorkerDocumentStatusDtoCopyWith on WorkerDocumentStatusDto {
  /// Returns a callable class that can be used as follows: `instanceOfWorkerDocumentStatusDto.copyWith(...)` or like so:`instanceOfWorkerDocumentStatusDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WorkerDocumentStatusDtoCWProxy get copyWith =>
      _$WorkerDocumentStatusDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerDocumentStatusDto _$WorkerDocumentStatusDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('WorkerDocumentStatusDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['type', 'reviewStatus', 'uploadedAt']);
  final val = WorkerDocumentStatusDto(
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$WorkerDocumentStatusDtoTypeEnumEnumMap, v),
    ),
    reviewStatus: $checkedConvert(
      'reviewStatus',
      (v) => $enumDecode(_$WorkerDocumentStatusDtoReviewStatusEnumEnumMap, v),
    ),
    uploadedAt: $checkedConvert('uploadedAt', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$WorkerDocumentStatusDtoToJson(
  WorkerDocumentStatusDto instance,
) => <String, dynamic>{
  'type': _$WorkerDocumentStatusDtoTypeEnumEnumMap[instance.type]!,
  'reviewStatus':
      _$WorkerDocumentStatusDtoReviewStatusEnumEnumMap[instance.reviewStatus]!,
  'uploadedAt': instance.uploadedAt,
};

const _$WorkerDocumentStatusDtoTypeEnumEnumMap = {
  WorkerDocumentStatusDtoTypeEnum.ciFront: 'ci_front',
  WorkerDocumentStatusDtoTypeEnum.ciBack: 'ci_back',
  WorkerDocumentStatusDtoTypeEnum.selfie: 'selfie',
  WorkerDocumentStatusDtoTypeEnum.cert: 'cert',
};

const _$WorkerDocumentStatusDtoReviewStatusEnumEnumMap = {
  WorkerDocumentStatusDtoReviewStatusEnum.pendiente: 'pendiente',
  WorkerDocumentStatusDtoReviewStatusEnum.aprobado: 'aprobado',
  WorkerDocumentStatusDtoReviewStatusEnum.rechazado: 'rechazado',
};
