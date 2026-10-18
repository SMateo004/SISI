// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationResultDtoCWProxy {
  VerificationResultDto userId(String userId);

  VerificationResultDto status(VerificationResultDtoStatusEnum status);

  VerificationResultDto rejectionReason(String? rejectionReason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationResultDto call({
    String userId,
    VerificationResultDtoStatusEnum status,
    String? rejectionReason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationResultDto.copyWith.fieldName(...)`
class _$VerificationResultDtoCWProxyImpl
    implements _$VerificationResultDtoCWProxy {
  const _$VerificationResultDtoCWProxyImpl(this._value);

  final VerificationResultDto _value;

  @override
  VerificationResultDto userId(String userId) => this(userId: userId);

  @override
  VerificationResultDto status(VerificationResultDtoStatusEnum status) =>
      this(status: status);

  @override
  VerificationResultDto rejectionReason(String? rejectionReason) =>
      this(rejectionReason: rejectionReason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationResultDto call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? rejectionReason = const $CopyWithPlaceholder(),
  }) {
    return VerificationResultDto(
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VerificationResultDtoStatusEnum,
      rejectionReason: rejectionReason == const $CopyWithPlaceholder()
          ? _value.rejectionReason
          // ignore: cast_nullable_to_non_nullable
          : rejectionReason as String?,
    );
  }
}

extension $VerificationResultDtoCopyWith on VerificationResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationResultDto.copyWith(...)` or like so:`instanceOfVerificationResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationResultDtoCWProxy get copyWith =>
      _$VerificationResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationResultDto _$VerificationResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationResultDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['userId', 'status', 'rejectionReason']);
  final val = VerificationResultDto(
    userId: $checkedConvert('userId', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$VerificationResultDtoStatusEnumEnumMap, v),
    ),
    rejectionReason: $checkedConvert('rejectionReason', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$VerificationResultDtoToJson(
  VerificationResultDto instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'status': _$VerificationResultDtoStatusEnumEnumMap[instance.status]!,
  'rejectionReason': instance.rejectionReason,
};

const _$VerificationResultDtoStatusEnumEnumMap = {
  VerificationResultDtoStatusEnum.aprobado: 'aprobado',
  VerificationResultDtoStatusEnum.rechazado: 'rechazado',
};
