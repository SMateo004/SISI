// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_offer_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateOfferDtoCWProxy {
  CreateOfferDto type(CreateOfferDtoTypeEnum type);

  CreateOfferDto amountBs(String? amountBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateOfferDto call({CreateOfferDtoTypeEnum type, String? amountBs});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateOfferDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateOfferDto.copyWith.fieldName(...)`
class _$CreateOfferDtoCWProxyImpl implements _$CreateOfferDtoCWProxy {
  const _$CreateOfferDtoCWProxyImpl(this._value);

  final CreateOfferDto _value;

  @override
  CreateOfferDto type(CreateOfferDtoTypeEnum type) => this(type: type);

  @override
  CreateOfferDto amountBs(String? amountBs) => this(amountBs: amountBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateOfferDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateOfferDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateOfferDto call({
    Object? type = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
  }) {
    return CreateOfferDto(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as CreateOfferDtoTypeEnum,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String?,
    );
  }
}

extension $CreateOfferDtoCopyWith on CreateOfferDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateOfferDto.copyWith(...)` or like so:`instanceOfCreateOfferDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateOfferDtoCWProxy get copyWith => _$CreateOfferDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOfferDto _$CreateOfferDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateOfferDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type']);
      final val = CreateOfferDto(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$CreateOfferDtoTypeEnumEnumMap, v),
        ),
        amountBs: $checkedConvert('amountBs', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreateOfferDtoToJson(CreateOfferDto instance) =>
    <String, dynamic>{
      'type': _$CreateOfferDtoTypeEnumEnumMap[instance.type]!,
      'amountBs': ?instance.amountBs,
    };

const _$CreateOfferDtoTypeEnumEnumMap = {
  CreateOfferDtoTypeEnum.accept: 'accept',
  CreateOfferDtoTypeEnum.counter: 'counter',
};
