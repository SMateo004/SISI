// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_pending_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalPendingDtoCWProxy {
  LegalPendingDto legalPending(
    List<LegalPendingDtoLegalPendingEnum> legalPending,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalPendingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalPendingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalPendingDto call({List<LegalPendingDtoLegalPendingEnum> legalPending});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalPendingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalPendingDto.copyWith.fieldName(...)`
class _$LegalPendingDtoCWProxyImpl implements _$LegalPendingDtoCWProxy {
  const _$LegalPendingDtoCWProxyImpl(this._value);

  final LegalPendingDto _value;

  @override
  LegalPendingDto legalPending(
    List<LegalPendingDtoLegalPendingEnum> legalPending,
  ) => this(legalPending: legalPending);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalPendingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalPendingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalPendingDto call({Object? legalPending = const $CopyWithPlaceholder()}) {
    return LegalPendingDto(
      legalPending: legalPending == const $CopyWithPlaceholder()
          ? _value.legalPending
          // ignore: cast_nullable_to_non_nullable
          : legalPending as List<LegalPendingDtoLegalPendingEnum>,
    );
  }
}

extension $LegalPendingDtoCopyWith on LegalPendingDto {
  /// Returns a callable class that can be used as follows: `instanceOfLegalPendingDto.copyWith(...)` or like so:`instanceOfLegalPendingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalPendingDtoCWProxy get copyWith => _$LegalPendingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalPendingDto _$LegalPendingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalPendingDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['legalPending']);
      final val = LegalPendingDto(
        legalPending: $checkedConvert(
          'legalPending',
          (v) => (v as List<dynamic>)
              .map(
                (e) => $enumDecode(_$LegalPendingDtoLegalPendingEnumEnumMap, e),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LegalPendingDtoToJson(LegalPendingDto instance) =>
    <String, dynamic>{
      'legalPending': instance.legalPending
          .map((e) => _$LegalPendingDtoLegalPendingEnumEnumMap[e]!)
          .toList(),
    };

const _$LegalPendingDtoLegalPendingEnumEnumMap = {
  LegalPendingDtoLegalPendingEnum.terms: 'terms',
  LegalPendingDtoLegalPendingEnum.privacy: 'privacy',
};
