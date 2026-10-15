// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AvailabilityDtoCWProxy {
  AvailabilityDto available(bool available);

  AvailabilityDto availableSince(DateTime? availableSince);

  AvailabilityDto locatedAt(DateTime? locatedAt);

  AvailabilityDto sendEverySec(num sendEverySec);

  AvailabilityDto staleAfterSec(num staleAfterSec);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvailabilityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvailabilityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AvailabilityDto call({
    bool available,
    DateTime? availableSince,
    DateTime? locatedAt,
    num sendEverySec,
    num staleAfterSec,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAvailabilityDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAvailabilityDto.copyWith.fieldName(...)`
class _$AvailabilityDtoCWProxyImpl implements _$AvailabilityDtoCWProxy {
  const _$AvailabilityDtoCWProxyImpl(this._value);

  final AvailabilityDto _value;

  @override
  AvailabilityDto available(bool available) => this(available: available);

  @override
  AvailabilityDto availableSince(DateTime? availableSince) =>
      this(availableSince: availableSince);

  @override
  AvailabilityDto locatedAt(DateTime? locatedAt) => this(locatedAt: locatedAt);

  @override
  AvailabilityDto sendEverySec(num sendEverySec) =>
      this(sendEverySec: sendEverySec);

  @override
  AvailabilityDto staleAfterSec(num staleAfterSec) =>
      this(staleAfterSec: staleAfterSec);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvailabilityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvailabilityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AvailabilityDto call({
    Object? available = const $CopyWithPlaceholder(),
    Object? availableSince = const $CopyWithPlaceholder(),
    Object? locatedAt = const $CopyWithPlaceholder(),
    Object? sendEverySec = const $CopyWithPlaceholder(),
    Object? staleAfterSec = const $CopyWithPlaceholder(),
  }) {
    return AvailabilityDto(
      available: available == const $CopyWithPlaceholder()
          ? _value.available
          // ignore: cast_nullable_to_non_nullable
          : available as bool,
      availableSince: availableSince == const $CopyWithPlaceholder()
          ? _value.availableSince
          // ignore: cast_nullable_to_non_nullable
          : availableSince as DateTime?,
      locatedAt: locatedAt == const $CopyWithPlaceholder()
          ? _value.locatedAt
          // ignore: cast_nullable_to_non_nullable
          : locatedAt as DateTime?,
      sendEverySec: sendEverySec == const $CopyWithPlaceholder()
          ? _value.sendEverySec
          // ignore: cast_nullable_to_non_nullable
          : sendEverySec as num,
      staleAfterSec: staleAfterSec == const $CopyWithPlaceholder()
          ? _value.staleAfterSec
          // ignore: cast_nullable_to_non_nullable
          : staleAfterSec as num,
    );
  }
}

extension $AvailabilityDtoCopyWith on AvailabilityDto {
  /// Returns a callable class that can be used as follows: `instanceOfAvailabilityDto.copyWith(...)` or like so:`instanceOfAvailabilityDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AvailabilityDtoCWProxy get copyWith => _$AvailabilityDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailabilityDto _$AvailabilityDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AvailabilityDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'available',
          'availableSince',
          'locatedAt',
          'sendEverySec',
          'staleAfterSec',
        ],
      );
      final val = AvailabilityDto(
        available: $checkedConvert('available', (v) => v as bool),
        availableSince: $checkedConvert(
          'availableSince',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        locatedAt: $checkedConvert(
          'locatedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        sendEverySec: $checkedConvert('sendEverySec', (v) => v as num),
        staleAfterSec: $checkedConvert('staleAfterSec', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$AvailabilityDtoToJson(AvailabilityDto instance) =>
    <String, dynamic>{
      'available': instance.available,
      'availableSince': instance.availableSince?.toIso8601String(),
      'locatedAt': instance.locatedAt?.toIso8601String(),
      'sendEverySec': instance.sendEverySec,
      'staleAfterSec': instance.staleAfterSec,
    };
