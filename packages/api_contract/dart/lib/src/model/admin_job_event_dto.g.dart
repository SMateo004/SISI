// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_job_event_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminJobEventDtoCWProxy {
  AdminJobEventDto action(String action);

  AdminJobEventDto fromStatus(String fromStatus);

  AdminJobEventDto toStatus(String toStatus);

  AdminJobEventDto actorRole(AdminJobEventDtoActorRoleEnum actorRole);

  AdminJobEventDto actorId(String? actorId);

  AdminJobEventDto note(String? note);

  AdminJobEventDto at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobEventDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobEventDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobEventDto call({
    String action,
    String fromStatus,
    String toStatus,
    AdminJobEventDtoActorRoleEnum actorRole,
    String? actorId,
    String? note,
    DateTime at,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminJobEventDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminJobEventDto.copyWith.fieldName(...)`
class _$AdminJobEventDtoCWProxyImpl implements _$AdminJobEventDtoCWProxy {
  const _$AdminJobEventDtoCWProxyImpl(this._value);

  final AdminJobEventDto _value;

  @override
  AdminJobEventDto action(String action) => this(action: action);

  @override
  AdminJobEventDto fromStatus(String fromStatus) =>
      this(fromStatus: fromStatus);

  @override
  AdminJobEventDto toStatus(String toStatus) => this(toStatus: toStatus);

  @override
  AdminJobEventDto actorRole(AdminJobEventDtoActorRoleEnum actorRole) =>
      this(actorRole: actorRole);

  @override
  AdminJobEventDto actorId(String? actorId) => this(actorId: actorId);

  @override
  AdminJobEventDto note(String? note) => this(note: note);

  @override
  AdminJobEventDto at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobEventDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobEventDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobEventDto call({
    Object? action = const $CopyWithPlaceholder(),
    Object? fromStatus = const $CopyWithPlaceholder(),
    Object? toStatus = const $CopyWithPlaceholder(),
    Object? actorRole = const $CopyWithPlaceholder(),
    Object? actorId = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return AdminJobEventDto(
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String,
      fromStatus: fromStatus == const $CopyWithPlaceholder()
          ? _value.fromStatus
          // ignore: cast_nullable_to_non_nullable
          : fromStatus as String,
      toStatus: toStatus == const $CopyWithPlaceholder()
          ? _value.toStatus
          // ignore: cast_nullable_to_non_nullable
          : toStatus as String,
      actorRole: actorRole == const $CopyWithPlaceholder()
          ? _value.actorRole
          // ignore: cast_nullable_to_non_nullable
          : actorRole as AdminJobEventDtoActorRoleEnum,
      actorId: actorId == const $CopyWithPlaceholder()
          ? _value.actorId
          // ignore: cast_nullable_to_non_nullable
          : actorId as String?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $AdminJobEventDtoCopyWith on AdminJobEventDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminJobEventDto.copyWith(...)` or like so:`instanceOfAdminJobEventDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminJobEventDtoCWProxy get copyWith => _$AdminJobEventDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJobEventDto _$AdminJobEventDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminJobEventDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'action',
          'fromStatus',
          'toStatus',
          'actorRole',
          'actorId',
          'note',
          'at',
        ],
      );
      final val = AdminJobEventDto(
        action: $checkedConvert('action', (v) => v as String),
        fromStatus: $checkedConvert('fromStatus', (v) => v as String),
        toStatus: $checkedConvert('toStatus', (v) => v as String),
        actorRole: $checkedConvert(
          'actorRole',
          (v) => $enumDecode(_$AdminJobEventDtoActorRoleEnumEnumMap, v),
        ),
        actorId: $checkedConvert('actorId', (v) => v as String?),
        note: $checkedConvert('note', (v) => v as String?),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$AdminJobEventDtoToJson(AdminJobEventDto instance) =>
    <String, dynamic>{
      'action': instance.action,
      'fromStatus': instance.fromStatus,
      'toStatus': instance.toStatus,
      'actorRole': _$AdminJobEventDtoActorRoleEnumEnumMap[instance.actorRole]!,
      'actorId': instance.actorId,
      'note': instance.note,
      'at': instance.at.toIso8601String(),
    };

const _$AdminJobEventDtoActorRoleEnumEnumMap = {
  AdminJobEventDtoActorRoleEnum.worker: 'worker',
  AdminJobEventDtoActorRoleEnum.employer: 'employer',
  AdminJobEventDtoActorRoleEnum.system: 'system',
  AdminJobEventDtoActorRoleEnum.admin: 'admin',
};
