// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_codes_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpCodesDtoCWProxy {
  OtpCodesDto enabled(bool enabled);

  OtpCodesDto items(List<OtpCodeDto> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpCodesDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpCodesDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpCodesDto call({bool enabled, List<OtpCodeDto> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpCodesDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpCodesDto.copyWith.fieldName(...)`
class _$OtpCodesDtoCWProxyImpl implements _$OtpCodesDtoCWProxy {
  const _$OtpCodesDtoCWProxyImpl(this._value);

  final OtpCodesDto _value;

  @override
  OtpCodesDto enabled(bool enabled) => this(enabled: enabled);

  @override
  OtpCodesDto items(List<OtpCodeDto> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpCodesDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpCodesDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpCodesDto call({
    Object? enabled = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return OtpCodesDto(
      enabled: enabled == const $CopyWithPlaceholder()
          ? _value.enabled
          // ignore: cast_nullable_to_non_nullable
          : enabled as bool,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<OtpCodeDto>,
    );
  }
}

extension $OtpCodesDtoCopyWith on OtpCodesDto {
  /// Returns a callable class that can be used as follows: `instanceOfOtpCodesDto.copyWith(...)` or like so:`instanceOfOtpCodesDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpCodesDtoCWProxy get copyWith => _$OtpCodesDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpCodesDto _$OtpCodesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpCodesDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['enabled', 'items']);
      final val = OtpCodesDto(
        enabled: $checkedConvert('enabled', (v) => v as bool),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => OtpCodeDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OtpCodesDtoToJson(OtpCodesDto instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
