// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geocode_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReverseGeocodeDtoCWProxy {
  ReverseGeocodeDto address(String? address);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReverseGeocodeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReverseGeocodeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReverseGeocodeDto call({String? address});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReverseGeocodeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReverseGeocodeDto.copyWith.fieldName(...)`
class _$ReverseGeocodeDtoCWProxyImpl implements _$ReverseGeocodeDtoCWProxy {
  const _$ReverseGeocodeDtoCWProxyImpl(this._value);

  final ReverseGeocodeDto _value;

  @override
  ReverseGeocodeDto address(String? address) => this(address: address);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReverseGeocodeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReverseGeocodeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReverseGeocodeDto call({Object? address = const $CopyWithPlaceholder()}) {
    return ReverseGeocodeDto(
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
    );
  }
}

extension $ReverseGeocodeDtoCopyWith on ReverseGeocodeDto {
  /// Returns a callable class that can be used as follows: `instanceOfReverseGeocodeDto.copyWith(...)` or like so:`instanceOfReverseGeocodeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReverseGeocodeDtoCWProxy get copyWith =>
      _$ReverseGeocodeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReverseGeocodeDto _$ReverseGeocodeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReverseGeocodeDto', json, ($checkedConvert) {
      final val = ReverseGeocodeDto(
        address: $checkedConvert('address', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ReverseGeocodeDtoToJson(ReverseGeocodeDto instance) =>
    <String, dynamic>{'address': ?instance.address};
