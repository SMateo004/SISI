// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WorkerProfileDtoCWProxy {
  WorkerProfileDto status(WorkerProfileDtoStatusEnum status);

  WorkerProfileDto rejectionReason(String? rejectionReason);

  WorkerProfileDto birthDate(String? birthDate);

  WorkerProfileDto transport(WorkerProfileDtoTransportEnum? transport);

  WorkerProfileDto maxRadiusKm(num? maxRadiusKm);

  WorkerProfileDto categoryIds(List<String> categoryIds);

  WorkerProfileDto documents(List<WorkerDocumentStatusDto> documents);

  WorkerProfileDto submittedAt(String? submittedAt);

  WorkerProfileDto editable(bool editable);

  WorkerProfileDto missingDocuments(List<String> missingDocuments);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerProfileDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerProfileDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerProfileDto call({
    WorkerProfileDtoStatusEnum status,
    String? rejectionReason,
    String? birthDate,
    WorkerProfileDtoTransportEnum? transport,
    num? maxRadiusKm,
    List<String> categoryIds,
    List<WorkerDocumentStatusDto> documents,
    String? submittedAt,
    bool editable,
    List<String> missingDocuments,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWorkerProfileDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWorkerProfileDto.copyWith.fieldName(...)`
class _$WorkerProfileDtoCWProxyImpl implements _$WorkerProfileDtoCWProxy {
  const _$WorkerProfileDtoCWProxyImpl(this._value);

  final WorkerProfileDto _value;

  @override
  WorkerProfileDto status(WorkerProfileDtoStatusEnum status) =>
      this(status: status);

  @override
  WorkerProfileDto rejectionReason(String? rejectionReason) =>
      this(rejectionReason: rejectionReason);

  @override
  WorkerProfileDto birthDate(String? birthDate) => this(birthDate: birthDate);

  @override
  WorkerProfileDto transport(WorkerProfileDtoTransportEnum? transport) =>
      this(transport: transport);

  @override
  WorkerProfileDto maxRadiusKm(num? maxRadiusKm) =>
      this(maxRadiusKm: maxRadiusKm);

  @override
  WorkerProfileDto categoryIds(List<String> categoryIds) =>
      this(categoryIds: categoryIds);

  @override
  WorkerProfileDto documents(List<WorkerDocumentStatusDto> documents) =>
      this(documents: documents);

  @override
  WorkerProfileDto submittedAt(String? submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  WorkerProfileDto editable(bool editable) => this(editable: editable);

  @override
  WorkerProfileDto missingDocuments(List<String> missingDocuments) =>
      this(missingDocuments: missingDocuments);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerProfileDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerProfileDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerProfileDto call({
    Object? status = const $CopyWithPlaceholder(),
    Object? rejectionReason = const $CopyWithPlaceholder(),
    Object? birthDate = const $CopyWithPlaceholder(),
    Object? transport = const $CopyWithPlaceholder(),
    Object? maxRadiusKm = const $CopyWithPlaceholder(),
    Object? categoryIds = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? editable = const $CopyWithPlaceholder(),
    Object? missingDocuments = const $CopyWithPlaceholder(),
  }) {
    return WorkerProfileDto(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as WorkerProfileDtoStatusEnum,
      rejectionReason: rejectionReason == const $CopyWithPlaceholder()
          ? _value.rejectionReason
          // ignore: cast_nullable_to_non_nullable
          : rejectionReason as String?,
      birthDate: birthDate == const $CopyWithPlaceholder()
          ? _value.birthDate
          // ignore: cast_nullable_to_non_nullable
          : birthDate as String?,
      transport: transport == const $CopyWithPlaceholder()
          ? _value.transport
          // ignore: cast_nullable_to_non_nullable
          : transport as WorkerProfileDtoTransportEnum?,
      maxRadiusKm: maxRadiusKm == const $CopyWithPlaceholder()
          ? _value.maxRadiusKm
          // ignore: cast_nullable_to_non_nullable
          : maxRadiusKm as num?,
      categoryIds: categoryIds == const $CopyWithPlaceholder()
          ? _value.categoryIds
          // ignore: cast_nullable_to_non_nullable
          : categoryIds as List<String>,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<WorkerDocumentStatusDto>,
      submittedAt: submittedAt == const $CopyWithPlaceholder()
          ? _value.submittedAt
          // ignore: cast_nullable_to_non_nullable
          : submittedAt as String?,
      editable: editable == const $CopyWithPlaceholder()
          ? _value.editable
          // ignore: cast_nullable_to_non_nullable
          : editable as bool,
      missingDocuments: missingDocuments == const $CopyWithPlaceholder()
          ? _value.missingDocuments
          // ignore: cast_nullable_to_non_nullable
          : missingDocuments as List<String>,
    );
  }
}

extension $WorkerProfileDtoCopyWith on WorkerProfileDto {
  /// Returns a callable class that can be used as follows: `instanceOfWorkerProfileDto.copyWith(...)` or like so:`instanceOfWorkerProfileDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WorkerProfileDtoCWProxy get copyWith => _$WorkerProfileDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerProfileDto _$WorkerProfileDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WorkerProfileDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'status',
          'categoryIds',
          'documents',
          'editable',
          'missingDocuments',
        ],
      );
      final val = WorkerProfileDto(
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$WorkerProfileDtoStatusEnumEnumMap, v),
        ),
        rejectionReason: $checkedConvert(
          'rejectionReason',
          (v) => v as String?,
        ),
        birthDate: $checkedConvert('birthDate', (v) => v as String?),
        transport: $checkedConvert(
          'transport',
          (v) => $enumDecodeNullable(_$WorkerProfileDtoTransportEnumEnumMap, v),
        ),
        maxRadiusKm: $checkedConvert('maxRadiusKm', (v) => v as num?),
        categoryIds: $checkedConvert(
          'categoryIds',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        documents: $checkedConvert(
          'documents',
          (v) => (v as List<dynamic>)
              .map(
                (e) =>
                    WorkerDocumentStatusDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        submittedAt: $checkedConvert('submittedAt', (v) => v as String?),
        editable: $checkedConvert('editable', (v) => v as bool),
        missingDocuments: $checkedConvert(
          'missingDocuments',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WorkerProfileDtoToJson(WorkerProfileDto instance) =>
    <String, dynamic>{
      'status': _$WorkerProfileDtoStatusEnumEnumMap[instance.status]!,
      'rejectionReason': ?instance.rejectionReason,
      'birthDate': ?instance.birthDate,
      'transport': ?_$WorkerProfileDtoTransportEnumEnumMap[instance.transport],
      'maxRadiusKm': ?instance.maxRadiusKm,
      'categoryIds': instance.categoryIds,
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'submittedAt': ?instance.submittedAt,
      'editable': instance.editable,
      'missingDocuments': instance.missingDocuments,
    };

const _$WorkerProfileDtoStatusEnumEnumMap = {
  WorkerProfileDtoStatusEnum.sinSolicitar: 'sin_solicitar',
  WorkerProfileDtoStatusEnum.pendienteRevision: 'pendiente_revision',
  WorkerProfileDtoStatusEnum.aprobado: 'aprobado',
  WorkerProfileDtoStatusEnum.rechazado: 'rechazado',
  WorkerProfileDtoStatusEnum.bloqueadoDeuda: 'bloqueado_deuda',
  WorkerProfileDtoStatusEnum.suspendidoModeracion: 'suspendido_moderacion',
};

const _$WorkerProfileDtoTransportEnumEnumMap = {
  WorkerProfileDtoTransportEnum.aPie: 'a_pie',
  WorkerProfileDtoTransportEnum.bicicleta: 'bicicleta',
  WorkerProfileDtoTransportEnum.moto: 'moto',
  WorkerProfileDtoTransportEnum.auto: 'auto',
  WorkerProfileDtoTransportEnum.transportePublico: 'transporte_publico',
};
