// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditEntryDtoCWProxy {
  AuditEntryDto id(String id);

  AuditEntryDto adminId(String adminId);

  AuditEntryDto adminName(String? adminName);

  AuditEntryDto adminPhone(String adminPhone);

  AuditEntryDto action(String action);

  AuditEntryDto targetType(String targetType);

  AuditEntryDto targetId(String targetId);

  AuditEntryDto before(Map<String, Object>? before);

  AuditEntryDto after(Map<String, Object>? after);

  AuditEntryDto reason(String? reason);

  AuditEntryDto ip(String? ip);

  AuditEntryDto forwardedFor(String? forwardedFor);

  AuditEntryDto userAgent(String? userAgent);

  AuditEntryDto cityId(String? cityId);

  AuditEntryDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntryDto call({
    String id,
    String adminId,
    String? adminName,
    String adminPhone,
    String action,
    String targetType,
    String targetId,
    Map<String, Object>? before,
    Map<String, Object>? after,
    String? reason,
    String? ip,
    String? forwardedFor,
    String? userAgent,
    String? cityId,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditEntryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditEntryDto.copyWith.fieldName(...)`
class _$AuditEntryDtoCWProxyImpl implements _$AuditEntryDtoCWProxy {
  const _$AuditEntryDtoCWProxyImpl(this._value);

  final AuditEntryDto _value;

  @override
  AuditEntryDto id(String id) => this(id: id);

  @override
  AuditEntryDto adminId(String adminId) => this(adminId: adminId);

  @override
  AuditEntryDto adminName(String? adminName) => this(adminName: adminName);

  @override
  AuditEntryDto adminPhone(String adminPhone) => this(adminPhone: adminPhone);

  @override
  AuditEntryDto action(String action) => this(action: action);

  @override
  AuditEntryDto targetType(String targetType) => this(targetType: targetType);

  @override
  AuditEntryDto targetId(String targetId) => this(targetId: targetId);

  @override
  AuditEntryDto before(Map<String, Object>? before) => this(before: before);

  @override
  AuditEntryDto after(Map<String, Object>? after) => this(after: after);

  @override
  AuditEntryDto reason(String? reason) => this(reason: reason);

  @override
  AuditEntryDto ip(String? ip) => this(ip: ip);

  @override
  AuditEntryDto forwardedFor(String? forwardedFor) =>
      this(forwardedFor: forwardedFor);

  @override
  AuditEntryDto userAgent(String? userAgent) => this(userAgent: userAgent);

  @override
  AuditEntryDto cityId(String? cityId) => this(cityId: cityId);

  @override
  AuditEntryDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? adminId = const $CopyWithPlaceholder(),
    Object? adminName = const $CopyWithPlaceholder(),
    Object? adminPhone = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
    Object? targetType = const $CopyWithPlaceholder(),
    Object? targetId = const $CopyWithPlaceholder(),
    Object? before = const $CopyWithPlaceholder(),
    Object? after = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? ip = const $CopyWithPlaceholder(),
    Object? forwardedFor = const $CopyWithPlaceholder(),
    Object? userAgent = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AuditEntryDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      adminId: adminId == const $CopyWithPlaceholder()
          ? _value.adminId
          // ignore: cast_nullable_to_non_nullable
          : adminId as String,
      adminName: adminName == const $CopyWithPlaceholder()
          ? _value.adminName
          // ignore: cast_nullable_to_non_nullable
          : adminName as String?,
      adminPhone: adminPhone == const $CopyWithPlaceholder()
          ? _value.adminPhone
          // ignore: cast_nullable_to_non_nullable
          : adminPhone as String,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String,
      targetType: targetType == const $CopyWithPlaceholder()
          ? _value.targetType
          // ignore: cast_nullable_to_non_nullable
          : targetType as String,
      targetId: targetId == const $CopyWithPlaceholder()
          ? _value.targetId
          // ignore: cast_nullable_to_non_nullable
          : targetId as String,
      before: before == const $CopyWithPlaceholder()
          ? _value.before
          // ignore: cast_nullable_to_non_nullable
          : before as Map<String, Object>?,
      after: after == const $CopyWithPlaceholder()
          ? _value.after
          // ignore: cast_nullable_to_non_nullable
          : after as Map<String, Object>?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
      ip: ip == const $CopyWithPlaceholder()
          ? _value.ip
          // ignore: cast_nullable_to_non_nullable
          : ip as String?,
      forwardedFor: forwardedFor == const $CopyWithPlaceholder()
          ? _value.forwardedFor
          // ignore: cast_nullable_to_non_nullable
          : forwardedFor as String?,
      userAgent: userAgent == const $CopyWithPlaceholder()
          ? _value.userAgent
          // ignore: cast_nullable_to_non_nullable
          : userAgent as String?,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $AuditEntryDtoCopyWith on AuditEntryDto {
  /// Returns a callable class that can be used as follows: `instanceOfAuditEntryDto.copyWith(...)` or like so:`instanceOfAuditEntryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditEntryDtoCWProxy get copyWith => _$AuditEntryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryDto _$AuditEntryDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuditEntryDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'adminId',
      'adminName',
      'adminPhone',
      'action',
      'targetType',
      'targetId',
      'before',
      'after',
      'reason',
      'ip',
      'forwardedFor',
      'userAgent',
      'cityId',
      'createdAt',
    ],
  );
  final val = AuditEntryDto(
    id: $checkedConvert('id', (v) => v as String),
    adminId: $checkedConvert('adminId', (v) => v as String),
    adminName: $checkedConvert('adminName', (v) => v as String?),
    adminPhone: $checkedConvert('adminPhone', (v) => v as String),
    action: $checkedConvert('action', (v) => v as String),
    targetType: $checkedConvert('targetType', (v) => v as String),
    targetId: $checkedConvert('targetId', (v) => v as String),
    before: $checkedConvert(
      'before',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as Object)),
    ),
    after: $checkedConvert(
      'after',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as Object)),
    ),
    reason: $checkedConvert('reason', (v) => v as String?),
    ip: $checkedConvert('ip', (v) => v as String?),
    forwardedFor: $checkedConvert('forwardedFor', (v) => v as String?),
    userAgent: $checkedConvert('userAgent', (v) => v as String?),
    cityId: $checkedConvert('cityId', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$AuditEntryDtoToJson(AuditEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminId': instance.adminId,
      'adminName': instance.adminName,
      'adminPhone': instance.adminPhone,
      'action': instance.action,
      'targetType': instance.targetType,
      'targetId': instance.targetId,
      'before': instance.before,
      'after': instance.after,
      'reason': instance.reason,
      'ip': instance.ip,
      'forwardedFor': instance.forwardedFor,
      'userAgent': instance.userAgent,
      'cityId': instance.cityId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
