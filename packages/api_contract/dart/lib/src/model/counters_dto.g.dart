// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counters_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CountersDtoCWProxy {
  CountersDto verifications(num verifications);

  CountersDto heldRequests(num heldRequests);

  CountersDto heldMessages(num heldMessages);

  CountersDto reports(num reports);

  CountersDto disputes(num disputes);

  CountersDto submissions(num submissions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountersDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountersDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CountersDto call({
    num verifications,
    num heldRequests,
    num heldMessages,
    num reports,
    num disputes,
    num submissions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCountersDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCountersDto.copyWith.fieldName(...)`
class _$CountersDtoCWProxyImpl implements _$CountersDtoCWProxy {
  const _$CountersDtoCWProxyImpl(this._value);

  final CountersDto _value;

  @override
  CountersDto verifications(num verifications) =>
      this(verifications: verifications);

  @override
  CountersDto heldRequests(num heldRequests) =>
      this(heldRequests: heldRequests);

  @override
  CountersDto heldMessages(num heldMessages) =>
      this(heldMessages: heldMessages);

  @override
  CountersDto reports(num reports) => this(reports: reports);

  @override
  CountersDto disputes(num disputes) => this(disputes: disputes);

  @override
  CountersDto submissions(num submissions) => this(submissions: submissions);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountersDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountersDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CountersDto call({
    Object? verifications = const $CopyWithPlaceholder(),
    Object? heldRequests = const $CopyWithPlaceholder(),
    Object? heldMessages = const $CopyWithPlaceholder(),
    Object? reports = const $CopyWithPlaceholder(),
    Object? disputes = const $CopyWithPlaceholder(),
    Object? submissions = const $CopyWithPlaceholder(),
  }) {
    return CountersDto(
      verifications: verifications == const $CopyWithPlaceholder()
          ? _value.verifications
          // ignore: cast_nullable_to_non_nullable
          : verifications as num,
      heldRequests: heldRequests == const $CopyWithPlaceholder()
          ? _value.heldRequests
          // ignore: cast_nullable_to_non_nullable
          : heldRequests as num,
      heldMessages: heldMessages == const $CopyWithPlaceholder()
          ? _value.heldMessages
          // ignore: cast_nullable_to_non_nullable
          : heldMessages as num,
      reports: reports == const $CopyWithPlaceholder()
          ? _value.reports
          // ignore: cast_nullable_to_non_nullable
          : reports as num,
      disputes: disputes == const $CopyWithPlaceholder()
          ? _value.disputes
          // ignore: cast_nullable_to_non_nullable
          : disputes as num,
      submissions: submissions == const $CopyWithPlaceholder()
          ? _value.submissions
          // ignore: cast_nullable_to_non_nullable
          : submissions as num,
    );
  }
}

extension $CountersDtoCopyWith on CountersDto {
  /// Returns a callable class that can be used as follows: `instanceOfCountersDto.copyWith(...)` or like so:`instanceOfCountersDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CountersDtoCWProxy get copyWith => _$CountersDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountersDto _$CountersDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CountersDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'verifications',
          'heldRequests',
          'heldMessages',
          'reports',
          'disputes',
          'submissions',
        ],
      );
      final val = CountersDto(
        verifications: $checkedConvert('verifications', (v) => v as num),
        heldRequests: $checkedConvert('heldRequests', (v) => v as num),
        heldMessages: $checkedConvert('heldMessages', (v) => v as num),
        reports: $checkedConvert('reports', (v) => v as num),
        disputes: $checkedConvert('disputes', (v) => v as num),
        submissions: $checkedConvert('submissions', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$CountersDtoToJson(CountersDto instance) =>
    <String, dynamic>{
      'verifications': instance.verifications,
      'heldRequests': instance.heldRequests,
      'heldMessages': instance.heldMessages,
      'reports': instance.reports,
      'disputes': instance.disputes,
      'submissions': instance.submissions,
    };
