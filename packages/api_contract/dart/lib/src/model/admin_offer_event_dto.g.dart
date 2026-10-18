// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_offer_event_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminOfferEventDtoCWProxy {
  AdminOfferEventDto kind(AdminOfferEventDtoKindEnum kind);

  AdminOfferEventDto revision(num revision);

  AdminOfferEventDto type(AdminOfferEventDtoTypeEnum type);

  AdminOfferEventDto amountBs(String amountBs);

  AdminOfferEventDto etaMin(num etaMin);

  AdminOfferEventDto at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminOfferEventDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminOfferEventDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminOfferEventDto call({
    AdminOfferEventDtoKindEnum kind,
    num revision,
    AdminOfferEventDtoTypeEnum type,
    String amountBs,
    num etaMin,
    DateTime at,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminOfferEventDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminOfferEventDto.copyWith.fieldName(...)`
class _$AdminOfferEventDtoCWProxyImpl implements _$AdminOfferEventDtoCWProxy {
  const _$AdminOfferEventDtoCWProxyImpl(this._value);

  final AdminOfferEventDto _value;

  @override
  AdminOfferEventDto kind(AdminOfferEventDtoKindEnum kind) => this(kind: kind);

  @override
  AdminOfferEventDto revision(num revision) => this(revision: revision);

  @override
  AdminOfferEventDto type(AdminOfferEventDtoTypeEnum type) => this(type: type);

  @override
  AdminOfferEventDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  AdminOfferEventDto etaMin(num etaMin) => this(etaMin: etaMin);

  @override
  AdminOfferEventDto at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminOfferEventDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminOfferEventDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminOfferEventDto call({
    Object? kind = const $CopyWithPlaceholder(),
    Object? revision = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? etaMin = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return AdminOfferEventDto(
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as AdminOfferEventDtoKindEnum,
      revision: revision == const $CopyWithPlaceholder()
          ? _value.revision
          // ignore: cast_nullable_to_non_nullable
          : revision as num,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as AdminOfferEventDtoTypeEnum,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      etaMin: etaMin == const $CopyWithPlaceholder()
          ? _value.etaMin
          // ignore: cast_nullable_to_non_nullable
          : etaMin as num,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $AdminOfferEventDtoCopyWith on AdminOfferEventDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminOfferEventDto.copyWith(...)` or like so:`instanceOfAdminOfferEventDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminOfferEventDtoCWProxy get copyWith =>
      _$AdminOfferEventDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminOfferEventDto _$AdminOfferEventDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminOfferEventDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'kind',
          'revision',
          'type',
          'amountBs',
          'etaMin',
          'at',
        ],
      );
      final val = AdminOfferEventDto(
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$AdminOfferEventDtoKindEnumEnumMap, v),
        ),
        revision: $checkedConvert('revision', (v) => v as num),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$AdminOfferEventDtoTypeEnumEnumMap, v),
        ),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        etaMin: $checkedConvert('etaMin', (v) => v as num),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$AdminOfferEventDtoToJson(AdminOfferEventDto instance) =>
    <String, dynamic>{
      'kind': _$AdminOfferEventDtoKindEnumEnumMap[instance.kind]!,
      'revision': instance.revision,
      'type': _$AdminOfferEventDtoTypeEnumEnumMap[instance.type]!,
      'amountBs': instance.amountBs,
      'etaMin': instance.etaMin,
      'at': instance.at.toIso8601String(),
    };

const _$AdminOfferEventDtoKindEnumEnumMap = {
  AdminOfferEventDtoKindEnum.creada: 'creada',
  AdminOfferEventDtoKindEnum.reemplazada: 'reemplazada',
  AdminOfferEventDtoKindEnum.retirada: 'retirada',
  AdminOfferEventDtoKindEnum.aceptada: 'aceptada',
  AdminOfferEventDtoKindEnum.cerrada: 'cerrada',
};

const _$AdminOfferEventDtoTypeEnumEnumMap = {
  AdminOfferEventDtoTypeEnum.accept: 'accept',
  AdminOfferEventDtoTypeEnum.counter: 'counter',
};
