// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminReportDtoCWProxy {
  AdminReportDto id(String id);

  AdminReportDto targetType(AdminReportDtoTargetTypeEnum targetType);

  AdminReportDto targetId(String targetId);

  AdminReportDto reason(AdminReportDtoReasonEnum reason);

  AdminReportDto status(AdminReportDtoStatusEnum status);

  AdminReportDto createdAt(DateTime createdAt);

  AdminReportDto reporterId(String reporterId);

  AdminReportDto note(String? note);

  AdminReportDto noteHeld(bool noteHeld);

  AdminReportDto resolution(String? resolution);

  AdminReportDto reportedUser(ReportedUserDto reportedUser);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReportDto call({
    String id,
    AdminReportDtoTargetTypeEnum targetType,
    String targetId,
    AdminReportDtoReasonEnum reason,
    AdminReportDtoStatusEnum status,
    DateTime createdAt,
    String reporterId,
    String? note,
    bool noteHeld,
    String? resolution,
    ReportedUserDto reportedUser,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminReportDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminReportDto.copyWith.fieldName(...)`
class _$AdminReportDtoCWProxyImpl implements _$AdminReportDtoCWProxy {
  const _$AdminReportDtoCWProxyImpl(this._value);

  final AdminReportDto _value;

  @override
  AdminReportDto id(String id) => this(id: id);

  @override
  AdminReportDto targetType(AdminReportDtoTargetTypeEnum targetType) =>
      this(targetType: targetType);

  @override
  AdminReportDto targetId(String targetId) => this(targetId: targetId);

  @override
  AdminReportDto reason(AdminReportDtoReasonEnum reason) =>
      this(reason: reason);

  @override
  AdminReportDto status(AdminReportDtoStatusEnum status) =>
      this(status: status);

  @override
  AdminReportDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AdminReportDto reporterId(String reporterId) => this(reporterId: reporterId);

  @override
  AdminReportDto note(String? note) => this(note: note);

  @override
  AdminReportDto noteHeld(bool noteHeld) => this(noteHeld: noteHeld);

  @override
  AdminReportDto resolution(String? resolution) => this(resolution: resolution);

  @override
  AdminReportDto reportedUser(ReportedUserDto reportedUser) =>
      this(reportedUser: reportedUser);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReportDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? targetType = const $CopyWithPlaceholder(),
    Object? targetId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? reporterId = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? noteHeld = const $CopyWithPlaceholder(),
    Object? resolution = const $CopyWithPlaceholder(),
    Object? reportedUser = const $CopyWithPlaceholder(),
  }) {
    return AdminReportDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      targetType: targetType == const $CopyWithPlaceholder()
          ? _value.targetType
          // ignore: cast_nullable_to_non_nullable
          : targetType as AdminReportDtoTargetTypeEnum,
      targetId: targetId == const $CopyWithPlaceholder()
          ? _value.targetId
          // ignore: cast_nullable_to_non_nullable
          : targetId as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as AdminReportDtoReasonEnum,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AdminReportDtoStatusEnum,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      reporterId: reporterId == const $CopyWithPlaceholder()
          ? _value.reporterId
          // ignore: cast_nullable_to_non_nullable
          : reporterId as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      noteHeld: noteHeld == const $CopyWithPlaceholder()
          ? _value.noteHeld
          // ignore: cast_nullable_to_non_nullable
          : noteHeld as bool,
      resolution: resolution == const $CopyWithPlaceholder()
          ? _value.resolution
          // ignore: cast_nullable_to_non_nullable
          : resolution as String?,
      reportedUser: reportedUser == const $CopyWithPlaceholder()
          ? _value.reportedUser
          // ignore: cast_nullable_to_non_nullable
          : reportedUser as ReportedUserDto,
    );
  }
}

extension $AdminReportDtoCopyWith on AdminReportDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminReportDto.copyWith(...)` or like so:`instanceOfAdminReportDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminReportDtoCWProxy get copyWith => _$AdminReportDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReportDto _$AdminReportDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminReportDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'targetType',
          'targetId',
          'reason',
          'status',
          'createdAt',
          'reporterId',
          'note',
          'noteHeld',
          'resolution',
          'reportedUser',
        ],
      );
      final val = AdminReportDto(
        id: $checkedConvert('id', (v) => v as String),
        targetType: $checkedConvert(
          'targetType',
          (v) => $enumDecode(_$AdminReportDtoTargetTypeEnumEnumMap, v),
        ),
        targetId: $checkedConvert('targetId', (v) => v as String),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$AdminReportDtoReasonEnumEnumMap, v),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$AdminReportDtoStatusEnumEnumMap, v),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        reporterId: $checkedConvert('reporterId', (v) => v as String),
        note: $checkedConvert('note', (v) => v as String?),
        noteHeld: $checkedConvert('noteHeld', (v) => v as bool),
        resolution: $checkedConvert('resolution', (v) => v as String?),
        reportedUser: $checkedConvert(
          'reportedUser',
          (v) => ReportedUserDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminReportDtoToJson(AdminReportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetType': _$AdminReportDtoTargetTypeEnumEnumMap[instance.targetType]!,
      'targetId': instance.targetId,
      'reason': _$AdminReportDtoReasonEnumEnumMap[instance.reason]!,
      'status': _$AdminReportDtoStatusEnumEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'reporterId': instance.reporterId,
      'note': instance.note,
      'noteHeld': instance.noteHeld,
      'resolution': instance.resolution,
      'reportedUser': instance.reportedUser.toJson(),
    };

const _$AdminReportDtoTargetTypeEnumEnumMap = {
  AdminReportDtoTargetTypeEnum.request: 'request',
  AdminReportDtoTargetTypeEnum.user: 'user',
  AdminReportDtoTargetTypeEnum.chatMessage: 'chat_message',
  AdminReportDtoTargetTypeEnum.job: 'job',
};

const _$AdminReportDtoReasonEnumEnumMap = {
  AdminReportDtoReasonEnum.serviciosSexuales: 'servicios_sexuales',
  AdminReportDtoReasonEnum.drogas: 'drogas',
  AdminReportDtoReasonEnum.armas: 'armas',
  AdminReportDtoReasonEnum.ilegal: 'ilegal',
  AdminReportDtoReasonEnum.inmoral: 'inmoral',
  AdminReportDtoReasonEnum.ventaProductos: 'venta_productos',
  AdminReportDtoReasonEnum.acoso: 'acoso',
  AdminReportDtoReasonEnum.fraude: 'fraude',
  AdminReportDtoReasonEnum.noSePresento: 'no_se_presento',
  AdminReportDtoReasonEnum.suplantacion: 'suplantacion',
  AdminReportDtoReasonEnum.otro: 'otro',
};

const _$AdminReportDtoStatusEnumEnumMap = {
  AdminReportDtoStatusEnum.pendiente: 'pendiente',
  AdminReportDtoStatusEnum.valido: 'valido',
  AdminReportDtoStatusEnum.descartado: 'descartado',
};
