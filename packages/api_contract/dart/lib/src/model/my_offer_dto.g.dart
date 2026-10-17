// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_offer_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyOfferDtoCWProxy {
  MyOfferDto id(String id);

  MyOfferDto type(MyOfferDtoTypeEnum type);

  MyOfferDto amountBs(String amountBs);

  MyOfferDto etaMin(num etaMin);

  MyOfferDto status(MyOfferDtoStatusEnum status);

  MyOfferDto revision(num revision);

  MyOfferDto updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MyOfferDto call({
    String id,
    MyOfferDtoTypeEnum type,
    String amountBs,
    num etaMin,
    MyOfferDtoStatusEnum status,
    num revision,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyOfferDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyOfferDto.copyWith.fieldName(...)`
class _$MyOfferDtoCWProxyImpl implements _$MyOfferDtoCWProxy {
  const _$MyOfferDtoCWProxyImpl(this._value);

  final MyOfferDto _value;

  @override
  MyOfferDto id(String id) => this(id: id);

  @override
  MyOfferDto type(MyOfferDtoTypeEnum type) => this(type: type);

  @override
  MyOfferDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  MyOfferDto etaMin(num etaMin) => this(etaMin: etaMin);

  @override
  MyOfferDto status(MyOfferDtoStatusEnum status) => this(status: status);

  @override
  MyOfferDto revision(num revision) => this(revision: revision);

  @override
  MyOfferDto updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MyOfferDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? etaMin = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? revision = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return MyOfferDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as MyOfferDtoTypeEnum,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      etaMin: etaMin == const $CopyWithPlaceholder()
          ? _value.etaMin
          // ignore: cast_nullable_to_non_nullable
          : etaMin as num,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as MyOfferDtoStatusEnum,
      revision: revision == const $CopyWithPlaceholder()
          ? _value.revision
          // ignore: cast_nullable_to_non_nullable
          : revision as num,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $MyOfferDtoCopyWith on MyOfferDto {
  /// Returns a callable class that can be used as follows: `instanceOfMyOfferDto.copyWith(...)` or like so:`instanceOfMyOfferDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MyOfferDtoCWProxy get copyWith => _$MyOfferDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOfferDto _$MyOfferDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MyOfferDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'type',
          'amountBs',
          'etaMin',
          'status',
          'revision',
          'updatedAt',
        ],
      );
      final val = MyOfferDto(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$MyOfferDtoTypeEnumEnumMap, v),
        ),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        etaMin: $checkedConvert('etaMin', (v) => v as num),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$MyOfferDtoStatusEnumEnumMap, v),
        ),
        revision: $checkedConvert('revision', (v) => v as num),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MyOfferDtoToJson(MyOfferDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$MyOfferDtoTypeEnumEnumMap[instance.type]!,
      'amountBs': instance.amountBs,
      'etaMin': instance.etaMin,
      'status': _$MyOfferDtoStatusEnumEnumMap[instance.status]!,
      'revision': instance.revision,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MyOfferDtoTypeEnumEnumMap = {
  MyOfferDtoTypeEnum.accept: 'accept',
  MyOfferDtoTypeEnum.counter: 'counter',
};

const _$MyOfferDtoStatusEnumEnumMap = {
  MyOfferDtoStatusEnum.activa: 'activa',
  MyOfferDtoStatusEnum.aceptada: 'aceptada',
  MyOfferDtoStatusEnum.cerrada: 'cerrada',
  MyOfferDtoStatusEnum.retirada: 'retirada',
};
