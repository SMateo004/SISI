// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_offer_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AcceptOfferResultDtoCWProxy {
  AcceptOfferResultDto jobId(String jobId);

  AcceptOfferResultDto requestId(String requestId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AcceptOfferResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AcceptOfferResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AcceptOfferResultDto call({String jobId, String requestId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAcceptOfferResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAcceptOfferResultDto.copyWith.fieldName(...)`
class _$AcceptOfferResultDtoCWProxyImpl
    implements _$AcceptOfferResultDtoCWProxy {
  const _$AcceptOfferResultDtoCWProxyImpl(this._value);

  final AcceptOfferResultDto _value;

  @override
  AcceptOfferResultDto jobId(String jobId) => this(jobId: jobId);

  @override
  AcceptOfferResultDto requestId(String requestId) =>
      this(requestId: requestId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AcceptOfferResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AcceptOfferResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AcceptOfferResultDto call({
    Object? jobId = const $CopyWithPlaceholder(),
    Object? requestId = const $CopyWithPlaceholder(),
  }) {
    return AcceptOfferResultDto(
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String,
      requestId: requestId == const $CopyWithPlaceholder()
          ? _value.requestId
          // ignore: cast_nullable_to_non_nullable
          : requestId as String,
    );
  }
}

extension $AcceptOfferResultDtoCopyWith on AcceptOfferResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfAcceptOfferResultDto.copyWith(...)` or like so:`instanceOfAcceptOfferResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AcceptOfferResultDtoCWProxy get copyWith =>
      _$AcceptOfferResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptOfferResultDto _$AcceptOfferResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AcceptOfferResultDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['jobId', 'requestId']);
  final val = AcceptOfferResultDto(
    jobId: $checkedConvert('jobId', (v) => v as String),
    requestId: $checkedConvert('requestId', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AcceptOfferResultDtoToJson(
  AcceptOfferResultDto instance,
) => <String, dynamic>{
  'jobId': instance.jobId,
  'requestId': instance.requestId,
};
