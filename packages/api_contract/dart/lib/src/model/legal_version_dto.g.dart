// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_version_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalVersionDtoCWProxy {
  LegalVersionDto type(LegalVersionDtoTypeEnum type);

  LegalVersionDto version(num version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalVersionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalVersionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalVersionDto call({LegalVersionDtoTypeEnum type, num version});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalVersionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalVersionDto.copyWith.fieldName(...)`
class _$LegalVersionDtoCWProxyImpl implements _$LegalVersionDtoCWProxy {
  const _$LegalVersionDtoCWProxyImpl(this._value);

  final LegalVersionDto _value;

  @override
  LegalVersionDto type(LegalVersionDtoTypeEnum type) => this(type: type);

  @override
  LegalVersionDto version(num version) => this(version: version);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalVersionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalVersionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalVersionDto call({
    Object? type = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return LegalVersionDto(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as LegalVersionDtoTypeEnum,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as num,
    );
  }
}

extension $LegalVersionDtoCopyWith on LegalVersionDto {
  /// Returns a callable class that can be used as follows: `instanceOfLegalVersionDto.copyWith(...)` or like so:`instanceOfLegalVersionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalVersionDtoCWProxy get copyWith => _$LegalVersionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalVersionDto _$LegalVersionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalVersionDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type', 'version']);
      final val = LegalVersionDto(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$LegalVersionDtoTypeEnumEnumMap, v),
        ),
        version: $checkedConvert('version', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$LegalVersionDtoToJson(LegalVersionDto instance) =>
    <String, dynamic>{
      'type': _$LegalVersionDtoTypeEnumEnumMap[instance.type]!,
      'version': instance.version,
    };

const _$LegalVersionDtoTypeEnumEnumMap = {
  LegalVersionDtoTypeEnum.terms: 'terms',
  LegalVersionDtoTypeEnum.privacy: 'privacy',
};
