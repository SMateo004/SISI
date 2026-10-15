// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_offer_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EmployerOfferDtoCWProxy {
  EmployerOfferDto id(String id);

  EmployerOfferDto type(EmployerOfferDtoTypeEnum type);

  EmployerOfferDto amountBs(String amountBs);

  EmployerOfferDto etaMin(num etaMin);

  EmployerOfferDto distanceM(num distanceM);

  EmployerOfferDto revision(num revision);

  EmployerOfferDto worker(OfferWorkerDto worker);

  EmployerOfferDto updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmployerOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmployerOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  EmployerOfferDto call({
    String id,
    EmployerOfferDtoTypeEnum type,
    String amountBs,
    num etaMin,
    num distanceM,
    num revision,
    OfferWorkerDto worker,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEmployerOfferDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEmployerOfferDto.copyWith.fieldName(...)`
class _$EmployerOfferDtoCWProxyImpl implements _$EmployerOfferDtoCWProxy {
  const _$EmployerOfferDtoCWProxyImpl(this._value);

  final EmployerOfferDto _value;

  @override
  EmployerOfferDto id(String id) => this(id: id);

  @override
  EmployerOfferDto type(EmployerOfferDtoTypeEnum type) => this(type: type);

  @override
  EmployerOfferDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  EmployerOfferDto etaMin(num etaMin) => this(etaMin: etaMin);

  @override
  EmployerOfferDto distanceM(num distanceM) => this(distanceM: distanceM);

  @override
  EmployerOfferDto revision(num revision) => this(revision: revision);

  @override
  EmployerOfferDto worker(OfferWorkerDto worker) => this(worker: worker);

  @override
  EmployerOfferDto updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmployerOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmployerOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  EmployerOfferDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? etaMin = const $CopyWithPlaceholder(),
    Object? distanceM = const $CopyWithPlaceholder(),
    Object? revision = const $CopyWithPlaceholder(),
    Object? worker = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return EmployerOfferDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as EmployerOfferDtoTypeEnum,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      etaMin: etaMin == const $CopyWithPlaceholder()
          ? _value.etaMin
          // ignore: cast_nullable_to_non_nullable
          : etaMin as num,
      distanceM: distanceM == const $CopyWithPlaceholder()
          ? _value.distanceM
          // ignore: cast_nullable_to_non_nullable
          : distanceM as num,
      revision: revision == const $CopyWithPlaceholder()
          ? _value.revision
          // ignore: cast_nullable_to_non_nullable
          : revision as num,
      worker: worker == const $CopyWithPlaceholder()
          ? _value.worker
          // ignore: cast_nullable_to_non_nullable
          : worker as OfferWorkerDto,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $EmployerOfferDtoCopyWith on EmployerOfferDto {
  /// Returns a callable class that can be used as follows: `instanceOfEmployerOfferDto.copyWith(...)` or like so:`instanceOfEmployerOfferDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EmployerOfferDtoCWProxy get copyWith => _$EmployerOfferDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployerOfferDto _$EmployerOfferDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EmployerOfferDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'type',
          'amountBs',
          'etaMin',
          'distanceM',
          'revision',
          'worker',
          'updatedAt',
        ],
      );
      final val = EmployerOfferDto(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$EmployerOfferDtoTypeEnumEnumMap, v),
        ),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        etaMin: $checkedConvert('etaMin', (v) => v as num),
        distanceM: $checkedConvert('distanceM', (v) => v as num),
        revision: $checkedConvert('revision', (v) => v as num),
        worker: $checkedConvert(
          'worker',
          (v) => OfferWorkerDto.fromJson(v as Map<String, dynamic>),
        ),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EmployerOfferDtoToJson(EmployerOfferDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EmployerOfferDtoTypeEnumEnumMap[instance.type]!,
      'amountBs': instance.amountBs,
      'etaMin': instance.etaMin,
      'distanceM': instance.distanceM,
      'revision': instance.revision,
      'worker': instance.worker.toJson(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$EmployerOfferDtoTypeEnumEnumMap = {
  EmployerOfferDtoTypeEnum.accept: 'accept',
  EmployerOfferDtoTypeEnum.counter: 'counter',
};
