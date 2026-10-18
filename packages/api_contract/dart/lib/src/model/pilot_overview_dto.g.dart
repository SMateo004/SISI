// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_overview_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotOverviewDtoCWProxy {
  PilotOverviewDto cityId(String cityId);

  PilotOverviewDto cityName(String cityName);

  PilotOverviewDto closed(bool closed);

  PilotOverviewDto allowlist(List<PilotPhoneDto> allowlist);

  PilotOverviewDto interestCount(num interestCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotOverviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotOverviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotOverviewDto call({
    String cityId,
    String cityName,
    bool closed,
    List<PilotPhoneDto> allowlist,
    num interestCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotOverviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotOverviewDto.copyWith.fieldName(...)`
class _$PilotOverviewDtoCWProxyImpl implements _$PilotOverviewDtoCWProxy {
  const _$PilotOverviewDtoCWProxyImpl(this._value);

  final PilotOverviewDto _value;

  @override
  PilotOverviewDto cityId(String cityId) => this(cityId: cityId);

  @override
  PilotOverviewDto cityName(String cityName) => this(cityName: cityName);

  @override
  PilotOverviewDto closed(bool closed) => this(closed: closed);

  @override
  PilotOverviewDto allowlist(List<PilotPhoneDto> allowlist) =>
      this(allowlist: allowlist);

  @override
  PilotOverviewDto interestCount(num interestCount) =>
      this(interestCount: interestCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotOverviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotOverviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotOverviewDto call({
    Object? cityId = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? closed = const $CopyWithPlaceholder(),
    Object? allowlist = const $CopyWithPlaceholder(),
    Object? interestCount = const $CopyWithPlaceholder(),
  }) {
    return PilotOverviewDto(
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      closed: closed == const $CopyWithPlaceholder()
          ? _value.closed
          // ignore: cast_nullable_to_non_nullable
          : closed as bool,
      allowlist: allowlist == const $CopyWithPlaceholder()
          ? _value.allowlist
          // ignore: cast_nullable_to_non_nullable
          : allowlist as List<PilotPhoneDto>,
      interestCount: interestCount == const $CopyWithPlaceholder()
          ? _value.interestCount
          // ignore: cast_nullable_to_non_nullable
          : interestCount as num,
    );
  }
}

extension $PilotOverviewDtoCopyWith on PilotOverviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotOverviewDto.copyWith(...)` or like so:`instanceOfPilotOverviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotOverviewDtoCWProxy get copyWith => _$PilotOverviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotOverviewDto _$PilotOverviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PilotOverviewDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'cityId',
          'cityName',
          'closed',
          'allowlist',
          'interestCount',
        ],
      );
      final val = PilotOverviewDto(
        cityId: $checkedConvert('cityId', (v) => v as String),
        cityName: $checkedConvert('cityName', (v) => v as String),
        closed: $checkedConvert('closed', (v) => v as bool),
        allowlist: $checkedConvert(
          'allowlist',
          (v) => (v as List<dynamic>)
              .map((e) => PilotPhoneDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        interestCount: $checkedConvert('interestCount', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$PilotOverviewDtoToJson(PilotOverviewDto instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'closed': instance.closed,
      'allowlist': instance.allowlist.map((e) => e.toJson()).toList(),
      'interestCount': instance.interestCount,
    };
