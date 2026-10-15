// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_contact_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobContactDtoCWProxy {
  JobContactDto jobId(String jobId);

  JobContactDto role(JobContactDtoRoleEnum role);

  JobContactDto name(String? name);

  JobContactDto phone(String phone);

  JobContactDto address(String? address);

  JobContactDto finalPriceBs(String finalPriceBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobContactDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobContactDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobContactDto call({
    String jobId,
    JobContactDtoRoleEnum role,
    String? name,
    String phone,
    String? address,
    String finalPriceBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobContactDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobContactDto.copyWith.fieldName(...)`
class _$JobContactDtoCWProxyImpl implements _$JobContactDtoCWProxy {
  const _$JobContactDtoCWProxyImpl(this._value);

  final JobContactDto _value;

  @override
  JobContactDto jobId(String jobId) => this(jobId: jobId);

  @override
  JobContactDto role(JobContactDtoRoleEnum role) => this(role: role);

  @override
  JobContactDto name(String? name) => this(name: name);

  @override
  JobContactDto phone(String phone) => this(phone: phone);

  @override
  JobContactDto address(String? address) => this(address: address);

  @override
  JobContactDto finalPriceBs(String finalPriceBs) =>
      this(finalPriceBs: finalPriceBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobContactDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobContactDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobContactDto call({
    Object? jobId = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? finalPriceBs = const $CopyWithPlaceholder(),
  }) {
    return JobContactDto(
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as JobContactDtoRoleEnum,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String?,
      finalPriceBs: finalPriceBs == const $CopyWithPlaceholder()
          ? _value.finalPriceBs
          // ignore: cast_nullable_to_non_nullable
          : finalPriceBs as String,
    );
  }
}

extension $JobContactDtoCopyWith on JobContactDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobContactDto.copyWith(...)` or like so:`instanceOfJobContactDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobContactDtoCWProxy get copyWith => _$JobContactDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobContactDto _$JobContactDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobContactDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'jobId',
          'role',
          'name',
          'phone',
          'address',
          'finalPriceBs',
        ],
      );
      final val = JobContactDto(
        jobId: $checkedConvert('jobId', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$JobContactDtoRoleEnumEnumMap, v),
        ),
        name: $checkedConvert('name', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String?),
        finalPriceBs: $checkedConvert('finalPriceBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$JobContactDtoToJson(JobContactDto instance) =>
    <String, dynamic>{
      'jobId': instance.jobId,
      'role': _$JobContactDtoRoleEnumEnumMap[instance.role]!,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'finalPriceBs': instance.finalPriceBs,
    };

const _$JobContactDtoRoleEnumEnumMap = {
  JobContactDtoRoleEnum.employer: 'employer',
  JobContactDtoRoleEnum.worker: 'worker',
};
